import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Ui
import "Model.js" as Model

// The Waybar year calendar, with Sunday-first weeks and ISO week numbers.
Panel {
  id: root
  moduleName: "omarchy.clock"
  manageIpc: false
  property var anchorItem: null
  property var hostWidget: null
  property date today: new Date()
  property int viewYear: today.getFullYear()
  readonly property int cellSize: Math.ceil(Math.max(calendarFont.advanceWidth("Mo"),
    calendarFont.advanceWidth("30"))) + 6
  readonly property var labelLocale: Qt.locale("en_US")

  FontMetrics {
    id: calendarFont
    font.family: Style.font.family
    font.pixelSize: Style.font.caption
  }

  function refresh() { today = new Date() }
  function moveYear(delta) { viewYear += delta }
  function toggleWeekStart() {}
  function cells(month) {
    var result = [{ label: "", color: "#99ffdd" }]
    for (var d = 0; d < 7; d++)
      result.push({ label: labelLocale.dayName(d === 0 ? 7 : d, Locale.ShortFormat).substring(0, 2), color: "#ffcc66" })
    var weeks = Model.monthGrid(viewYear, month, 0, Model.keyForDate(today))
    for (var w = 0; w < weeks.length; w++) {
      result.push({ label: String(weeks[w].week), color: "#99ffdd" })
      for (var i = 0; i < 7; i++) {
        var day = weeks[w].days[i]
        result.push({ label: day.inMonth ? String(day.day) : "", color: day.today ? "#000000" : "#ecc6d9", today: day.today && day.inMonth })
      }
    }
    return result
  }

  SystemClock { precision: SystemClock.Minutes; onDateChanged: root.today = date }

  KeyboardPanel {
    id: popup
    anchorItem: root.anchorItem
    owner: root.hostWidget || root
    bar: root.bar
    open: root.opened
    centerOnBar: true
    focusTarget: keys
    contentWidth: popup.fittedContentWidth(months.implicitWidth + popup.padding * 2
      + Border.left(popup.borderSpec) + Border.right(popup.borderSpec))
    contentHeight: popup.fittedContentHeight(content.implicitHeight)

    PanelKeyCatcher {
      id: keys
      anchors.fill: parent
      onMoveRequested: function(dx, dy) { root.moveYear(dx || dy) }
      onActivateRequested: root.viewYear = root.today.getFullYear()
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }
    }

    Flickable {
      anchors.fill: parent
      clip: true
      contentWidth: width
      contentHeight: content.implicitHeight

      ColumnLayout {
        id: content
        width: parent.width
        spacing: Style.space(8)

        RowLayout {
          Layout.fillWidth: true
          WidgetButton { bar: root.bar; text: "‹"; onPressed: root.moveYear(-1) }
          Text {
            Layout.fillWidth: true
            text: String(root.viewYear)
            color: "#ffead3"
            font.family: Style.font.family
            font.pixelSize: Style.font.title
            horizontalAlignment: Text.AlignHCenter
          }
          WidgetButton { bar: root.bar; text: "›"; onPressed: root.moveYear(1) }
        }

        GridLayout {
          id: months
          Layout.alignment: Qt.AlignHCenter
          columns: 3
          columnSpacing: Style.space(8)
          rowSpacing: Style.space(8)
          Repeater {
            model: 12
            ColumnLayout {
              id: monthCell
              required property int index
              spacing: 2
              Text {
                Layout.fillWidth: true
                text: root.labelLocale.monthName(monthCell.index, Locale.LongFormat)
                color: "#ffead3"
                font.family: Style.font.family
                font.pixelSize: Style.font.caption
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
              }
              GridLayout {
                columns: 8
                columnSpacing: 0
                rowSpacing: 0
                Repeater {
                  model: root.cells(monthCell.index)
                  Rectangle {
                    required property var modelData
                    implicitWidth: root.cellSize
                    implicitHeight: root.cellSize
                    color: modelData.today ? "#E4002B" : "transparent"
                    Text {
                      anchors.centerIn: parent
                      text: parent.modelData.label
                      color: parent.modelData.color
                      font.family: Style.font.family
                      font.pixelSize: Style.font.caption
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
