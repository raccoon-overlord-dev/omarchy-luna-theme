#!/bin/bash
# Luna theme-set hook (installed to ~/.config/omarchy/hooks/theme-set.d/).
# On luna / luna-dark: put the luna.start widget in the bar (replacing the menu
# and workspaces widgets) and use the ModernXP cursor.
# On any other theme: put the replaced widgets and the previous cursor back.
THEME=$1
STATE="$HOME/.local/state/omarchy/luna"
SHELL_JSON="$HOME/.config/omarchy/shell.json"
mkdir -p "$STATE"

# Rewrites shell.json in place (same inode) so the shell's file watcher reloads it.
edit_shell_json() {
  local tmp
  [[ -f $SHELL_JSON ]] || return 0
  tmp=$(mktemp)
  jq "$@" "$SHELL_JSON" >"$tmp" && cat "$tmp" >"$SHELL_JSON"
  rm -f "$tmp"
}

set_cursor() {
  hyprctl setcursor "$1" 24 >/dev/null 2>&1
  [[ -n ${DBUS_SESSION_BUS_ADDRESS:-} ]] && gsettings set org.gnome.desktop.interface cursor-theme "$1"
}

case $THEME in
  luna|luna-dark)
    if [[ ! -f $STATE/removed.json ]]; then
      jq -c '[.bar.layout.left[]? | select(.id == "omarchy.menu" or (.id | endswith(".workspaces")))]' \
        "$SHELL_JSON" >"$STATE/removed.json"
      # A bar that already shows luna.start has nothing of ours to restore later.
      [[ $(jq '[.bar.layout.left[]? | select(.id == "luna.start")] | length' "$SHELL_JSON") -gt 0 && \
         $(jq length "$STATE/removed.json") -eq 0 ]] && rm -f "$STATE/removed.json"
    fi
    edit_shell_json '.bar.layout.left = ([{"id":"luna.start"}] + [.bar.layout.left[]? | select(.id != "luna.start" and .id != "omarchy.menu" and (.id | endswith(".workspaces") | not))])'

    if [[ ! -f $STATE/cursor ]]; then
      cur=$(gsettings get org.gnome.desktop.interface cursor-theme 2>/dev/null | tr -d "'")
      [[ $cur == ModernXP ]] && cur=default
      echo "${cur:-default}" >"$STATE/cursor"
    fi
    set_cursor ModernXP
    ;;
  *)
    if [[ -f $STATE/removed.json ]]; then
      edit_shell_json --slurpfile removed "$STATE/removed.json" \
        '.bar.layout.left = ($removed[0] + [.bar.layout.left[]? | select(.id != "luna.start")])'
      rm -f "$STATE/removed.json"
    else
      edit_shell_json '.bar.layout.left |= [.[]? | select(.id != "luna.start")]'
    fi

    if [[ -f $STATE/cursor ]]; then
      # windows-xp* themes pick their own cursor through another hook.
      [[ $THEME == windows-xp* ]] || set_cursor "$(cat "$STATE/cursor")"
      rm -f "$STATE/cursor"
    fi
    ;;
esac
