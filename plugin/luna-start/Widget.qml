import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Commons as Commons
import qs.Ui

// Luna "start block": Omarchy logo + workspaces in one rounded block flush to
// the left screen edge. Colors come from [luna] in the theme's shell.toml and
// fall back to the native bar colors, so the widget looks fine on any theme.
BarWidget {
  id: root
  moduleName: "luna.start"

  function lc(key, fallback) {
    var v = Commons.Color.shellValues["luna." + key]
    return v ? v : fallback
  }

  readonly property color blockTop:    lc("start-top", "transparent")
  readonly property color blockMid:    lc("start-mid", "transparent")
  readonly property color blockBottom: lc("start-bottom", "transparent")
  readonly property color pressedColor: lc("start-pressed", Commons.Color.accent)
  readonly property color textColor:   lc("start-text", Commons.Color.bar.text)
  readonly property color logoColor:   lc("start-logo", textColor)
  readonly property color shadowColor: lc("start-shadow", "transparent")
  readonly property color emptyColor:  lc("ws-empty", Qt.alpha(Commons.Color.bar.text, 0.5))
  readonly property bool inset: lc("inset", "0") === "1"

  // Same monitor/block model as omarchy.workspaces: each monitor owns ten
  // workspaces, numbered in blocks of ten by Hyprland.
  readonly property int slots: 10
  readonly property int count: Math.max(1, Math.min(slots, Number(setting("count", 5))))

  readonly property var monitor: {
    var window = root.QsWindow.window
    var screen = window ? window.screen : null
    return screen ? Hyprland.monitorFor(screen) : Hyprland.focusedMonitor
  }
  readonly property string monitorName: root.monitor ? root.monitor.name : ""
  property var blocks: ({})

  function readBlocks(text) {
    var next = {}
    var lines = String(text || "").split("\n")
    for (var i = 0; i < lines.length; i++) {
      var f = lines[i].split("\t")
      if (f.length >= 3 && f[1] !== "") next[f[1]] = parseInt(f[0], 10)
    }
    root.blocks = next
  }

  FileView {
    path: (Quickshell.env("XDG_STATE_HOME") || Quickshell.env("HOME") + "/.local/state") + "/omarchy/monitor-workspaces"
    watchChanges: true
    printErrors: false
    onFileChanged: reload()
    onLoaded: root.readBlocks(text())
    onLoadFailed: root.readBlocks("")
  }

  function blockOf(id) { return Math.floor((id - 1) / root.slots) }
  function slotOf(id) { return (id - 1) % root.slots + 1 }
  function activeWorkspaceId() {
    return root.monitor && root.monitor.activeWorkspace ? root.monitor.activeWorkspace.id : -1
  }

  readonly property int block: {
    var b = root.blocks[root.monitorName]
    if (b !== undefined) return b
    var active = root.activeWorkspaceId()
    return active > 0 ? root.blockOf(active) : 0
  }

  function workspaceById(id) {
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) if (values[i].id === id) return values[i]
    return null
  }

  // The first `count` workspaces of this monitor, plus any later one that exists.
  function workspaceIds() {
    var base = root.block * root.slots
    var ids = []
    for (var n = 1; n <= root.count; n++) ids.push(base + n)
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      var id = values[i].id
      if (id > 0 && root.blockOf(id) === root.block && ids.indexOf(id) === -1) ids.push(id)
    }
    ids.sort(function(a, b) { return a - b })
    return ids
  }

  function dispatch(expression) {
    if (root.bar) root.bar.run("hyprctl dispatch " + Util.shellQuote(expression))
  }

  function focusWorkspace(id) {
    root.dispatch("o.workspaces.focus(" + root.slotOf(id) + ", \"" + root.monitorName + "\")")
  }

  property real wheelAccumulator: 0

  function scrollWorkspaces(delta) {
    var wheel = Util.wheelSteps(root.wheelAccumulator, delta)
    root.wheelAccumulator = wheel.remainder
    if (wheel.steps === 0) return
    var ids = root.workspaceIds()
    var index = ids.indexOf(root.activeWorkspaceId())
    if (index === -1) return
    var target = ids[Util.clamp(index - wheel.steps, 0, ids.length - 1)]
    if (target !== ids[index]) root.focusWorkspace(target)
  }

  Connections {
    target: Hyprland
    function onRawEvent(event) {
      var name = event ? String(event.name) : ""
      var switched = name === "workspacev2" && root.monitor !== null && root.monitor.focused
      if (switched || name === "moveworkspacev2" || name === "changeworkspaceid") {
        Hyprland.refreshMonitors()
        Hyprland.refreshWorkspaces()
      }
    }
  }

  // Layout (horizontal bars): block spans the full bar height, flush left by
  // cancelling the section's 8-unit margin. Inner padding 12 left / 16 right.
  readonly property real edge: Commons.Style.space(8)
  readonly property real padLeft: 12
  readonly property real padRight: 16
  readonly property real contentOffset: Math.max(0, padLeft - edge)

  implicitWidth: contentOffset + row.implicitWidth + padRight
  implicitHeight: barSize

  Rectangle {
    id: blockShape
    visible: false
    layer.enabled: true
    x: -root.edge
    width: root.width + root.edge
    height: root.height
    topRightRadius: 15
    bottomRightRadius: 15
    gradient: Gradient {
      GradientStop { position: 0.0;  color: root.blockTop }
      GradientStop { position: 0.55; color: root.blockMid }
      GradientStop { position: 1.0;  color: root.blockBottom }
    }
  }

  MultiEffect {
    anchors.fill: blockShape
    source: blockShape
    visible: !root.vertical
    shadowEnabled: root.shadowColor.a > 0
    shadowColor: root.shadowColor
    shadowHorizontalOffset: 2
    shadowBlur: 0.5
  }

  Row {
    id: row
    x: root.contentOffset
    anchors.verticalCenter: parent.verticalCenter
    spacing: 12

    // Omarchy logo: 9px outlined diamond. Left click = menu, right = terminal.
    Item {
      id: logo
      width: 18
      height: root.barSize
      anchors.verticalCenter: parent.verticalCenter

      Rectangle {
        anchors.centerIn: parent
        width: 11.5
        height: 11.5
        rotation: 45
        color: "transparent"
        border.width: 1.5
        border.color: root.logoColor
      }

      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: function(mouse) {
          if (!root.bar) return
          if (mouse.button === Qt.RightButton) root.bar.run("xdg-terminal-exec")
          else root.bar.run("omarchy-shell shell toggle omarchy.menu '{\"menu\":\"root\"}'")
        }
      }
    }

    Row {
      spacing: 3
      anchors.verticalCenter: parent.verticalCenter

      Repeater {
        model: root.workspaceIds()

        Rectangle {
          id: ws
          required property int modelData
          readonly property var workspace: root.workspaceById(modelData)
          readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
          readonly property bool shown: root.monitor !== null && root.monitor.activeWorkspace !== null && root.monitor.activeWorkspace.id === modelData

          width: 26
          height: 22
          radius: 5
          color: shown ? root.pressedColor : (hover.hovered ? Qt.alpha(root.textColor, 0.18) : "transparent")

          // Pressed-in look for the active button (light variant only).
          Rectangle {
            visible: ws.shown && root.inset
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 5
            radius: 5
            gradient: Gradient {
              GradientStop { position: 0.0; color: "#73000000" }
              GradientStop { position: 1.0; color: "#00000000" }
            }
          }

          Text {
            anchors.centerIn: parent
            textFormat: Text.PlainText
            text: ws.modelData === 0 ? "0" : String(root.slotOf(ws.modelData) === root.slots ? 0 : root.slotOf(ws.modelData))
            color: ws.shown || ws.occupied ? (ws.shown ? "#FFFFFF" : root.textColor) : root.emptyColor
            font.family: Commons.Style.font.family
            font.pixelSize: Commons.Style.font.body
            font.bold: ws.shown
            renderType: Text.NativeRendering
          }

          HoverHandler { id: hover }
          MouseArea {
            anchors.fill: parent
            onClicked: root.focusWorkspace(ws.modelData)
            onWheel: function(wheel) { root.scrollWorkspaces(wheel.angleDelta.y) }
          }
        }
      }
    }
  }
}
