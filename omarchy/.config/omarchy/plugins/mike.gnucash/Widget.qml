import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui

// A small polled status label using the stock bar's widget API.
BarWidget {
  id: root
  property string outputText: ""
  property string outputTooltip: ""
  implicitWidth: outputText !== "" ? button.implicitWidth : 0
  implicitHeight: button.implicitHeight
  visible: outputText !== ""

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.outputText
    tooltipText: root.outputTooltip || String(root.setting("tooltip", ""))
    foreground: root.setting("color", root.bar ? root.bar.barForeground : Color.foreground)
    onPressed: function(mouseButton) {
      var key = mouseButton === Qt.RightButton ? "onRightClick"
        : mouseButton === Qt.MiddleButton ? "onMiddleClick" : "onClick"
      var command = String(root.setting(key, ""))
      if (command && root.bar) root.bar.run(command)
    }
  }

  Process {
    id: process
    command: ["bash", "-lc", String(root.setting("command", ""))]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        var data = Util.parseModuleJson(text)
        root.outputText = data.text || String(text || "").trim()
        root.outputTooltip = data.tooltip || ""
      }
    }
  }

  Timer {
    interval: Math.max(1, Number(root.setting("interval", 5))) * 1000
    running: String(root.setting("command", "")) !== ""
    repeat: true
    triggeredOnStart: true
    onTriggered: if (!process.running) process.running = true
  }
}
