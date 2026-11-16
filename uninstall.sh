#!/bin/bash
# Reverses install.sh: leaves the Luna themes (the theme-set hook puts the bar
# and cursor back), then removes everything that was installed.
set -uo pipefail

OMARCHY_CFG="$HOME/.config/omarchy"
STATE="$HOME/.local/state/omarchy/luna"

current=$(cat "$HOME/.local/state/omarchy/current/theme.name" 2>/dev/null || true)
if [[ $current == luna* ]]; then
  prev=$(cat "$STATE/previous-theme" 2>/dev/null || true)
  [[ -n $prev ]] || prev=$(omarchy theme list | grep -vi '^luna' | head -1)
  omarchy theme set "$prev"
fi

# Run the hook's restore branch even if we were not on a luna theme.
bash "$OMARCHY_CFG/hooks/theme-set.d/luna.sh" restore 2>/dev/null || true

if [[ -f $STATE/gtk-font ]]; then
  gsettings set org.gnome.desktop.interface font-name "$(cat "$STATE/gtk-font")"
fi

omarchy plugin disable luna.start >/dev/null 2>&1 || true
rm -rf "$OMARCHY_CFG/plugins/luna.start" "$OMARCHY_CFG/themes/luna" "$OMARCHY_CFG/themes/luna-dark" "$STATE"
rm -f "$OMARCHY_CFG/hooks/theme-set.d/luna.sh"

# Belt and braces: if the hook could not run above, Inherits=ModernXP would
# outlive the cursor we are about to delete.
if [[ -f $HOME/.local/share/icons/default/.luna ]]; then
  rm -f "$HOME/.local/share/icons/default/index.theme" "$HOME/.local/share/icons/default/.luna"
  rmdir "$HOME/.local/share/icons/default" 2>/dev/null
fi

# ModernXP is shared with other themes: keep it while one still needs it.
if ! ls "$OMARCHY_CFG/themes" 2>/dev/null | grep -q '^windows-xp'; then
  rm -rf "$HOME/.local/share/icons/ModernXP"
fi
echo "Luna removed."
