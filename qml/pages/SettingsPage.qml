import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: settingsPage
    SilicaListView {
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Settings")
        }
        model: VisualItemModel {
            ComboBox {
                label: qsTr("Coordinate format")
                currentIndex: settings.coordinateFormat === "DEG" ? 0 : 1
                onCurrentIndexChanged: {
                    settings.coordinateFormat = (currentIndex === 0 ? "DEG" : "DEC")
                }
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("degree")
                    }
                    MenuItem {
                        text: qsTr("decimal")
                    }
                }
            }
            ComboBox {
                label: qsTr("Units")
                currentIndex: settings.units === "MET" ? 0 : 1
                onCurrentIndexChanged: {
                    settings.units = (currentIndex === 0 ? "MET" : "IMP")
                }
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("metric")
                    }
                    MenuItem {
                        text: qsTr("imperial")
                    }
                }
            }
            ComboBox {
                label: qsTr("Language")
                currentIndex: settings.locale === "de" ? 0 : 1
                onCurrentIndexChanged: {
                    settings.locale = (currentIndex === 0 ? "de" : "en")
                }
                menu: ContextMenu {
                    MenuItem {
                        text: "Deutsch"
                    }
                    MenuItem {
                        text: "English"
                    }
                }
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingMedium * 2
                text: qsTr("Update interval")
            }

            Slider {
                minimumValue: 1
                maximumValue: 120
                stepSize: 1
                value: settings.updateInterval
                valueText: value + "s"
                width: parent.width
                onValueChanged: settings.updateInterval = value
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
                            text: qsTr("Show") + "..."
                        }
                    }
                    Label {
                        text: qsTr("Appview")
                    }
                    Label {
                        text: qsTr("Cover")
                    }

                    ShowGridRowLabel {
                        text: qsTr("GPS state")
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
                        text: qsTr("Latitude")
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
                        text: qsTr("Longitude")
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
                        text: qsTr("Altitude")
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
                        text: qsTr("Speed")
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
                        text: qsTr("Last Update")
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
                        text: qsTr("Vertical Accuracy")
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
                        text: qsTr("Horizontal Accuracy")
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
                        text: qsTr("Satellite Info")
                    }
                    Switch {
                        checked: settings.showSatelliteInfoApp
                        onClicked: settings.showSatelliteInfoApp = checked
                    }
                    Switch {
                        checked: settings.showSatelliteInfoCover
                        onClicked: settings.showSatelliteInfoCover = checked
                    }

                    ShowGridRowLabel {
                        text: qsTr("Compass Direction")
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
