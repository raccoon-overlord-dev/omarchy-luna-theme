#!/bin/bash
# Installs the Luna themes, the luna.start bar widget, the ModernXP cursor and
# the theme-set hook. Safe to run again.
#   LUNA_OPENSANS=1|0  answer the Open Sans question without asking
set -euo pipefail

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
OMARCHY_CFG="$HOME/.config/omarchy"
STATE="$HOME/.local/state/omarchy/luna"

command -v omarchy >/dev/null || { echo "Omarchy not found." >&2; exit 1; }
command -v jq >/dev/null || { echo "jq is required." >&2; exit 1; }
mkdir -p "$STATE"

# Remember where to go back to on uninstall (never record a luna theme).
current=$(cat "$HOME/.local/state/omarchy/current/theme.name" 2>/dev/null || true)
[[ -n $current && $current != luna* ]] && echo "$current" >"$STATE/previous-theme"

echo "==> Themes"
mkdir -p "$OMARCHY_CFG/themes"
for t in luna luna-dark; do
  rm -rf "$OMARCHY_CFG/themes/$t"
  cp -r "$HERE/themes/$t" "$OMARCHY_CFG/themes/$t"
done

echo "==> Bar widget (luna.start)"
mkdir -p "$OMARCHY_CFG/plugins"
rm -rf "$OMARCHY_CFG/plugins/luna.start"
cp -r "$HERE/plugin/luna-start" "$OMARCHY_CFG/plugins/luna.start"
omarchy plugin enable luna.start >/dev/null 2>&1 || true

echo "==> Cursor (ModernXP)"
mkdir -p "$HOME/.local/share/icons"
rm -rf "$HOME/.local/share/icons/ModernXP"
cp -r "$HERE/cursors/ModernXP" "$HOME/.local/share/icons/ModernXP"

echo "==> Hook"
omarchy hook install theme-set "$HERE/hooks/theme-set.d/luna.sh"

# Optional: Open Sans as GTK interface font (close to Tahoma/Verdana).
want=${LUNA_OPENSANS:-}
if [[ -z $want && -t 0 ]]; then
  read -r -p "Set Open Sans as the GTK interface font? [y/N] " a
  [[ $a == [yY]* ]] && want=1
fi
if [[ $want == 1 ]]; then
  fc-list | grep -qi "open sans" || omarchy pkg add ttf-opensans
  prev=$(gsettings get org.gnome.desktop.interface font-name | tr -d "'")
  [[ -f $STATE/gtk-font ]] || echo "$prev" >"$STATE/gtk-font"
  gsettings set org.gnome.desktop.interface font-name "Open Sans 10"
fi

echo "==> Applying luna"
omarchy theme set luna
echo "Done. Try: omarchy theme set luna-dark"
