<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="1920" height="1080" viewBox="0 0 1920 1080" font-family="JetBrainsMono Nerd Font, JetBrains Mono, monospace">
  <defs>
    <linearGradient id="start" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="${START_TOP}"/><stop offset="0.55" stop-color="${START_MID}"/><stop offset="1" stop-color="${START_BOTTOM}"/>
    </linearGradient>
    <linearGradient id="border" x1="0" y1="1" x2="1" y2="0">
      <stop offset="0" stop-color="${BORDER_A}"/><stop offset="1" stop-color="${BORDER_B}"/>
    </linearGradient>
    <linearGradient id="meter" x1="0" y1="0" x2="1" y2="0">
      <stop offset="0" stop-color="${GREEN}"/><stop offset="0.6" stop-color="${YELLOW}"/><stop offset="1" stop-color="${RED}"/>
    </linearGradient>
    <linearGradient id="inset" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="#000" stop-opacity="${INSET}"/><stop offset="1" stop-color="#000" stop-opacity="0"/>
    </linearGradient>
    <filter id="shadow" x="-10%" y="-10%" width="120%" height="125%"><feDropShadow dx="0" dy="10" stdDeviation="14" flood-color="#000" flood-opacity="${SHADOW}"/></filter>
    <filter id="blockShadow" x="-5%" y="-20%" width="115%" height="140%"><feDropShadow dx="2" dy="0" stdDeviation="2.5" flood-color="#000" flood-opacity="${BLOCK_SHADOW}"/></filter>
  </defs>

  <image href="${WALL}" x="0" y="0" width="1920" height="1080" preserveAspectRatio="xMidYMid slice"/>

  <!-- background window (inactive border): system monitor -->
  <g filter="url(#shadow)">
    <rect x="1040" y="500" width="780" height="470" rx="8" fill="${TERM_BG}" stroke="${BORDER_INACTIVE}" stroke-width="2"/>
  </g>
  <g font-size="15" fill="${TERM_FG}">
    <rect x="1062" y="522" width="736" height="206" rx="4" fill="none" stroke="${BTOP_BOX}" stroke-width="1.5"/>
    <text x="1078" y="526" font-weight="bold" fill="${TERM_BG}" stroke="${TERM_BG}" stroke-width="8" paint-order="stroke">cpu</text>
    <text x="1078" y="527" font-weight="bold" fill="${BTOP_BOX}">cpu</text>
    <rect x="1084" y="550" width="330" height="10" rx="2" fill="${METER}"/><rect x="1084" y="550" width="214" height="10" rx="2" fill="url(#meter)"/>
    <text x="1426" y="560">C0  65%</text>
    <rect x="1084" y="580" width="330" height="10" rx="2" fill="${METER}"/><rect x="1084" y="580" width="118" height="10" rx="2" fill="url(#meter)"/>
    <text x="1426" y="590">C1  36%</text>
    <rect x="1084" y="610" width="330" height="10" rx="2" fill="${METER}"/><rect x="1084" y="610" width="282" height="10" rx="2" fill="url(#meter)"/>
    <text x="1426" y="620">C2  86%</text>
    <rect x="1084" y="640" width="330" height="10" rx="2" fill="${METER}"/><rect x="1084" y="640" width="76" height="10" rx="2" fill="url(#meter)"/>
    <text x="1426" y="650">C3  23%</text>
    <text x="1084" y="700" fill="${MUTED}">load avg 0.82 0.74 0.69</text>
    <rect x="1062" y="746" width="736" height="200" rx="4" fill="none" stroke="${BTOP_BOX}" stroke-width="1.5"/>
    <text x="1078" y="750" font-weight="bold" fill="${TERM_BG}" stroke="${TERM_BG}" stroke-width="8" paint-order="stroke">proc</text>
    <text x="1078" y="751" font-weight="bold" fill="${BTOP_BOX}">proc</text>
    <rect x="1070" y="776" width="720" height="24" rx="3" fill="${SEL_BG}"/>
    <text x="1084" y="793" fill="${SEL_FG}">1423  hyprland        4.2%   612M</text>
    <text x="1084" y="823">2210  omarchy-shell    2.9%   488M</text>
    <text x="1084" y="853">3361  alacritty        1.1%    96M</text>
    <text x="1084" y="883">4102  nvim             0.6%   142M</text>
    <text x="1084" y="913" fill="${MUTED}">5077  btop             0.4%    18M</text>
  </g>

  <!-- active window: terminal, with the blue to green border -->
  <g filter="url(#shadow)">
    <rect x="110" y="100" width="900" height="560" rx="8" fill="${TERM_BG}" stroke="url(#border)" stroke-width="3"/>
  </g>
  <g font-size="20" fill="${TERM_FG}">
    <text x="140" y="148"><tspan fill="${GREEN}">user</tspan><tspan fill="${MUTED}">@</tspan><tspan fill="${BLUE}">omarchy</tspan> <tspan fill="${YELLOW}">~/luna</tspan> <tspan fill="${MUTED}">$</tspan> omarchy theme set ${THEME}</text>
    <text x="140" y="184" fill="${MUTED}">applying ${THEME} ...</text>
    <text x="140" y="214" fill="${GREEN}">done</text>
    <text x="140" y="262"><tspan fill="${GREEN}">user</tspan><tspan fill="${MUTED}">@</tspan><tspan fill="${BLUE}">omarchy</tspan> <tspan fill="${YELLOW}">~/luna</tspan> <tspan fill="${MUTED}">$</tspan> ls themes/</text>
    <text x="140" y="298"><tspan fill="${BLUE}">luna</tspan>  <tspan fill="${BLUE}">luna-dark</tspan></text>
    <text x="140" y="346"><tspan fill="${GREEN}">user</tspan><tspan fill="${MUTED}">@</tspan><tspan fill="${BLUE}">omarchy</tspan> <tspan fill="${YELLOW}">~/luna</tspan> <tspan fill="${MUTED}">$</tspan> git status</text>
    <text x="140" y="382">On branch main</text>
    <text x="140" y="412" fill="${RED}">  modified:   themes/luna/shell.popups.toml</text>
    <text x="140" y="442" fill="${GREEN}">  new file:   wallpaper/luna-hills.svg</text>
    <text x="140" y="490"><tspan fill="${GREEN}">user</tspan><tspan fill="${MUTED}">@</tspan><tspan fill="${BLUE}">omarchy</tspan> <tspan fill="${YELLOW}">~/luna</tspan> <tspan fill="${MUTED}">$</tspan> <tspan fill="${CURSOR}">▍</tspan></text>
${SWATCHES}
  </g>

  <!-- Omarchy menu -->
  <g filter="url(#shadow)">
    <rect x="1040" y="100" width="300" height="372" fill="${MENU_BG}" stroke="${MENU_BORDER}" stroke-width="1.5"/>
  </g>
  <g font-size="16" fill="${MENU_FG}">
    <text x="1060" y="136" fill="${MUTED}">Go…</text>
    <text x="1096" y="172">Apps</text>
    <text x="1096" y="204">Learn</text>
    <text x="1096" y="236">Appearance</text>
    <text x="1096" y="268">Trigger</text>
    <text x="1096" y="300">Setup</text>
    <rect x="1050" y="316" width="280" height="30" fill="${MENU_SEL}"/>
    <text x="1096" y="337" fill="${MENU_SEL_FG}">Install</text>
    <text x="1096" y="372">Remove</text>
    <text x="1096" y="404">Update</text>
    <text x="1096" y="436">System</text>
    <g fill="${MUTED}"><rect x="1062" y="160" width="14" height="14" rx="2"/><rect x="1062" y="192" width="14" height="14" rx="2"/><rect x="1062" y="224" width="14" height="14" rx="2"/><rect x="1062" y="256" width="14" height="14" rx="2"/><rect x="1062" y="288" width="14" height="14" rx="2"/><rect x="1062" y="360" width="14" height="14" rx="2"/><rect x="1062" y="392" width="14" height="14" rx="2"/><rect x="1062" y="424" width="14" height="14" rx="2"/></g>
    <rect x="1062" y="324" width="14" height="14" rx="2" fill="${MENU_SEL_FG}"/>
  </g>

  <!-- notification -->
  <g filter="url(#shadow)">
    <rect x="1400" y="60" width="460" height="86" fill="${NOTIF_BG}" stroke="${NOTIF_BORDER}" stroke-width="1.5"/>
  </g>
  <text x="1424" y="96" font-size="18" font-weight="bold" fill="${NOTIF_FG}">Theme applied</text>
  <text x="1424" y="126" font-size="16" fill="${NOTIF_FG}">${THEME} is now active</text>

  <!-- bar -->
  <rect x="0" y="0" width="1920" height="40" fill="${BAR}"/>
  <g filter="url(#blockShadow)" opacity="${BLOCK_OPACITY}">
    <path d="M0 0 H 228 A 15 15 0 0 1 243 15 V 25 A 15 15 0 0 1 228 40 H 0 Z" fill="url(#start)"/>
  </g>
  <rect x="21" y="14" width="9" height="9" transform="rotate(45 25.5 18.5) translate(-1 4)" fill="none" stroke="${LOGO}" stroke-width="2"/>
  <g font-size="16" text-anchor="middle">
    <rect x="52" y="8" width="29" height="24" rx="5" fill="${PRESSED}"/>
    <rect x="52" y="8" width="29" height="24" rx="5" fill="url(#inset)"/>
    <text x="66.5" y="25" font-weight="bold" fill="#FFFFFF">1</text>
    <text x="100" y="25" fill="${WS_TEXT}">2</text>
    <text x="133" y="25" fill="${WS_TEXT}">3</text>
    <text x="166" y="25" fill="${WS_EMPTY}">4</text>
    <text x="199" y="25" fill="${WS_EMPTY}">5</text>
  </g>
  <text x="960" y="26" font-size="16" text-anchor="middle" fill="${BAR_FG}">Monday 12:00</text>
  <g font-size="16" fill="${BAR_FG}" text-anchor="end">
    <text x="1890" y="26">100%  ◂))  ●</text>
  </g>
</svg>
