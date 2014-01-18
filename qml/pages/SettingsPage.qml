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
                currentIndex: settings.coordinateFormat === "DEG" ? 0 : 1
                onCurrentIndexChanged: {
                    settings.coordinateFormat = (currentIndex === 0 ? "DEG" : "DEC")
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
            ComboBox {
                label: "Units"
                currentIndex: settings.units === "MET" ? 0 : 1
                onCurrentIndexChanged: {
                    settings.units = (currentIndex === 0 ? "MET" : "IMP")
                }
                menu: ContextMenu {
                    MenuItem {
                        text: "metric"
                    }
                    MenuItem {
                        text: "imperial"
                    }
                }
            }

            Rectangle {
                anchors.leftMargin: Theme.paddingMedium
                height: grid.height
                Grid {
                    id: grid
                    width: parent.width
                    columns: 3
                    columnSpacing: 20

                    Rectangle {
                        width: 220
                        height: label.height
                        color: "transparent"
                        Label {
                            id: label
                            anchors.left: parent.left
                            anchors.leftMargin: Theme.paddingLarge
                            text: "Show..."
                        }
                    }
                    Label {
                        text: "Appview"
                    }
                    Label {
                        text: "Cover"
                    }

                    ShowGridRowLabel {
                        text: "GPS state"
                    }
                    Switch {
                        checked: settings.showGpsStateApp
                        onClicked: settings.showGpsStateApp = checked
                    }
                    Switch {
                        checked: settings.showGpsStateCover
                        onClicked: settings.showGpsStateCover = checked
                    }

                    ShowGridRowLabel {
                        text: "Latitude"
                    }
                    Switch {
                        checked: settings.showLatitudeApp
                        onClicked: settings.showLatitudeApp = checked
                    }
                    Switch {
                        checked: settings.showLatitudeCover
                        onClicked: settings.showLatitudeCover = checked
                    }

                    ShowGridRowLabel {
                        text: "Longitude"
                    }
                    Switch {
                        checked: settings.showLongitudeApp
                        onClicked: settings.showLongitudeApp = checked
                    }
                    Switch {
                        checked: settings.showLongitudeCover
                        onClicked: settings.showLongitudeCover = checked
                    }

                    ShowGridRowLabel {
                        text: "Altitude"
                    }
                    Switch {
                        checked: settings.showAltitudeApp
                        onClicked: settings.showAltitudeApp = checked
                    }
                    Switch {
                        checked: settings.showAltitudeCover
                        onClicked: settings.showAltitudeCover = checked
                    }

                    ShowGridRowLabel {
                        text: "Speed"
                    }
                    Switch {
                        checked: settings.showSpeedApp
                        onClicked: settings.showSpeedApp = checked
                    }
                    Switch {
                        checked: settings.showSpeedCover
                        onClicked: settings.showSpeedCover = checked
                    }

                    ShowGridRowLabel {
                        text: "Last Update"
                    }
                    Switch {
                        checked: settings.showLastUpdateApp
                        onClicked: settings.showLastUpdateApp = checked
                    }
                    Switch {
                        checked: settings.showLastUpdateCover
                        onClicked: settings.showLastUpdateCover = checked
                    }

                    ShowGridRowLabel {
                        text: "Vertical Accuracy"
                    }
                    Switch {
                        checked: settings.showVerticalAccuracyApp
                        onClicked: settings.showVerticalAccuracyApp = checked
                    }
                    Switch {
                        checked: settings.showVerticalAccuracyCover
                        onClicked: settings.showVerticalAccuracyCover = checked
                    }

                    ShowGridRowLabel {
                        text: "Horizontal Accuracy"
                    }
                    Switch {
                        checked: settings.showHorizontalAccuracyApp
                        onClicked: settings.showHorizontalAccuracyApp = checked
                    }
                    Switch {
                        checked: settings.showHorizontalAccuracyCover
                        onClicked: settings.showHorizontalAccuracyCover = checked
                    }

                    ShowGridRowLabel {
                        text: "Compass Direction"
                    }
                    Switch {
                        checked: settings.showCompassDirectionApp
                        onClicked: settings.showCompassDirectionApp = checked
                    }
                    Switch {
                        checked: settings.showCompassDirectionCover
                        onClicked: settings.showCompassDirectionCover = checked
                    }
                }
            }
        }
    }
}
