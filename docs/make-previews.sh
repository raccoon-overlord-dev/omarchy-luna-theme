#!/bin/bash
# Renders docs/preview-luna.png and docs/preview-luna-dark.png from the theme
# files only (wallpaper + palette). A composed render, not a screen capture.
# Needs: envsubst, rsvg-convert, magick.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT

swatches() { # 16 ANSI colors from colors.toml, two rows of 8
  local f=$1 i x y c out=""
  for i in $(seq 0 15); do
    c=$(sed -n "s/^color$i *= *\"\(#[0-9A-Fa-f]*\)\".*/\1/p" "$f")
    x=$((140 + (i % 8) * 36)); y=$((540 + (i / 8) * 36))
    out+="    <rect x=\"$x\" y=\"$y\" width=\"30\" height=\"30\" rx=\"4\" fill=\"$c\"/>"$'\n'
  done
  printf '%s' "$out"
}

render() { # variant
  local v=$1 d=../themes/$1
  local c=$d/colors.toml
  magick "$d/backgrounds/"*.jpg -resize 1920x1080^ -gravity center -extent 1920x1080 -quality 90 "$tmp/wall.jpg"
  export WALL="$tmp/wall.jpg" THEME=$v SWATCHES="$(swatches "$c")"
  if [[ $v == luna ]]; then
    export BAR='#245EDC' BAR_FG='#FFFFFF' START_TOP='#58B858' START_MID='#3C9C3C' START_BOTTOM='#318E31'
    export PRESSED='#22701F' INSET=0.45 WS_TEXT='#FFFFFF' WS_EMPTY='#99FFFFFF' LOGO='#FFFFFF' BLOCK_OPACITY=1 BLOCK_SHADOW=0.28
    export BORDER_A='#3A81F3' BORDER_B='#3C9C3C' BORDER_INACTIVE='#C9C5B4'
    export TERM_BG='#FBFAF5' TERM_FG='#1E2430' MUTED='#7D828C' CURSOR='#0E1320' BTOP_BOX='#245EDC' METER='#E6E2D1'
    export SEL_BG='#316AC5' SEL_FG='#FFFFFF' SHADOW=0.28
    export MENU_BG='#FFFFFF' MENU_FG='#1E2430' MENU_BORDER='#245EDC' MENU_SEL='#316AC5' MENU_SEL_FG='#FFFFFF'
    export NOTIF_BG='#FFFFE1' NOTIF_FG='#1E2430' NOTIF_BORDER='#C8BE84'
    export RED='#C4281C' GREEN='#2E8B2E' YELLOW='#9A6700' BLUE='#245EDC'
  else
    export BAR='#1F2124' BAR_FG='#E6E8EB' START_TOP='#000' START_MID='#000' START_BOTTOM='#000'
    export PRESSED='#3FA34A' INSET=0 WS_TEXT='#E6E8EB' WS_EMPTY='#6E747C' LOGO='#4C8DFF' BLOCK_OPACITY=0 BLOCK_SHADOW=0
    export BORDER_A='#4C8DFF' BORDER_B='#5CC25C' BORDER_INACTIVE='#34373D'
    export TERM_BG='#1C1D20' TERM_FG='#D9DCE1' MUTED='#6E747C' CURSOR='#F4F6F8' BTOP_BOX='#3A3D44' METER='#2C2F34'
    export SEL_BG='#2F5FBF' SEL_FG='#FFFFFF' SHADOW=0.5
    export MENU_BG='#232528' MENU_FG='#E6E8EB' MENU_BORDER='#34373D' MENU_SEL='#2F5FBF' MENU_SEL_FG='#FFFFFF'
    export NOTIF_BG='#26282C' NOTIF_FG='#F4F6F8' NOTIF_BORDER='#3A3D44'
    export RED='#F0605A' GREEN='#5CC25C' YELLOW='#E8B43A' BLUE='#4C8DFF'
  fi
  envsubst <preview.svg.tpl >"$tmp/$v.svg"
  rsvg-convert "$tmp/$v.svg" -o "$tmp/$v.png"
  magick "$tmp/$v.png" -quality 88 "preview-$v.jpg"
}

render luna
render luna-dark
