import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui

// A small polled status label using the stock bar's widget API.
BarWidget {
  id: root
  property string outputText: ""
  property string outputTooltip: ""
  implicitWidth: button.visible ? button.implicitWidth : 0
  implicitHeight: button.implicitHeight
  // Reserve space even before the first reading arrives.
  visible: true

  FontMetrics {
    id: labelMetrics
    font.family: button.fontFamily
    font.pixelSize: button.fontSize
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.outputText
    labelVisible: false

    // Keep the stock button's click/tooltip handling with a right-aligned label.
    Text {
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      anchors.leftMargin: button.scaledHorizontalMargin
      anchors.rightMargin: button.scaledHorizontalMargin
      text: root.outputText
      textFormat: Text.PlainText
      horizontalAlignment: Text.AlignRight
      color: button.foreground
      font.family: button.fontFamily
      font.pixelSize: button.fontSize
      renderType: Text.NativeRendering
    }
    tooltipText: root.outputTooltip || String(root.setting("tooltip", ""))
    fontSize: Style.font.body
    keepSpace: true
    fixedWidth: root.vertical ? root.barSize : Math.ceil(labelMetrics.advanceWidth(
      String(root.setting("widthText", "9.9G/31G")))) + scaledHorizontalMargin * 2
    foreground: root.setting("color", root.bar ? root.bar.barForeground : Color.foreground)
    horizontalMargin: 3
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
