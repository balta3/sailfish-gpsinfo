import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: settingsPage
    SilicaListView {
        anchors.fill: parent
        header: PageHeader {
            title: "Settings"
        }
        model: VisualItemModel {
            ComboBox {
                label: "Coordinate format"
                currentIndex: settings.value("coordinateFormat") === "DEG" ? 0 : 1
                onCurrentIndexChanged: {
                    settings.setValue("coordinateFormat", currentIndex === 0 ? "DEG" : "DEC")
                }
                menu: ContextMenu {
                    MenuItem {
                        text: "degree"
                    }
                    MenuItem {
                        text: "decimal"
                    }
                }
            }
        }
    }
}
