import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: settingsPage

    allowedOrientations: Orientation.Portrait | Orientation.Landscape | Orientation.LandscapeInverted

    function setSpeedUnitComboBoxIndex() {
        if (settings.units === "MET") {
            speedUnitComboBox.currentIndex = settings.speedUnit === "SEC" ? 0 : 1
        } else {
            speedUnitComboBox.currentIndex = settings.speedUnit === "SEC" ? 2 : 3
        }
    }

    function setLanguageCombobox() {
        switch(settings.locale){
            case "de":
                return 1
            case "es":
                return 2
            case "fi":
                return 3
            case "fr":
                return 4
            case "nl":
                return 5
            case "pl":
                return 6
            case "ru":
                return 7
            case "sv":
                return 8
            default:
                return 0
        }
    }

    SilicaListView {
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Settings")
        }
        model: VisualItemModel {
            ComboBox {
                label: qsTr("Coordinate format")
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("degree")
                        onClicked: settings.coordinateFormat = "DEG"
                    }
                    MenuItem {
                        text: qsTr("decimal")
                        onClicked: settings.coordinateFormat = "DEC"
                    }
                }
                Component.onCompleted: currentIndex = settings.coordinateFormat === "DEG" ? 0 : 1
            }
            ComboBox {
                label: qsTr("Units")
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("metric")
                        onClicked: {
                            settings.units = "MET";
                            setSpeedUnitComboBoxIndex();
                        }
                    }
                    MenuItem {
                        text: qsTr("imperial")
                        onClicked: {
                            settings.units = "IMP";
                            setSpeedUnitComboBoxIndex();
                        }
                    }
                }
                Component.onCompleted: currentIndex = settings.units === "MET" ? 0 : 1
            }
            ComboBox {
                id: speedUnitComboBox
                label: qsTr("Speed")
                menu: ContextMenu {
                    MenuItem {
                        visible: settings.units === "MET"
                        text: qsTr("m/s")
                        onClicked: settings.speedUnit = "SEC"
                    }
                    MenuItem {
                        visible: settings.units === "MET"
                        text: qsTr("km/h")
                        onClicked: settings.speedUnit = "HOUR"
                    }
                    MenuItem {
                        visible: settings.units === "IMP"
                        text: qsTr("ft/s")
                        onClicked: settings.speedUnit = "SEC"
                    }
                    MenuItem {
                        visible: settings.units === "IMP"
                        text: qsTr("mph")
                        onClicked: settings.speedUnit = "HOUR"
                    }
                }
                Component.onCompleted: setSpeedUnitComboBoxIndex()
            }
            ComboBox {
                id: languageCombobox
                label: qsTr("Language") + "*"
                menu: ContextMenu {
                    MenuItem {
                        text: "English"
                        onClicked: settings.locale = "en"
                    }
                    MenuItem {
                        text: "Deutsch"
                        onClicked: settings.locale = "de"
                    }
                    MenuItem {
                        text: "Español"
                        onClicked: settings.locale = "es"
                    }
                    MenuItem {
                        text: "Suomi"
                        onClicked: settings.locale = "fi"
                    }
                    MenuItem {
                        text: "Français"
                        onClicked: settings.locale = "fr"
                    }
                    MenuItem {
                        text: "Nederlands"
                        onClicked: settings.locale = "nl"
                    }
                    MenuItem {
                        text: "Polskie"
                        onClicked: settings.locale = "pl"
                    }
                    MenuItem {
                        text: "Pусский"
                        onClicked: settings.locale = "ru"
                    }
                    MenuItem {
                        text: "Svenska"
                        onClicked: settings.locale = "sv"
                    }

                }
                Component.onCompleted: currentIndex = setLanguageCombobox()
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
                onReleased: settings.updateInterval = value
            }

            ComboBox {
                label: qsTr("Rotate satellite view")
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("yes")
                        onClicked: {
                            settings.rotate = true;
                        }
                    }
                    MenuItem {
                        text: qsTr("no")
                        onClicked: {
                            settings.rotate = false;
                        }
                    }
                }
                Component.onCompleted: currentIndex = settings.rotate ? 0 : 1
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
                        width: Theme.fontSizeLarge * 6.5;
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
                        text: qsTr("Movement Direction")
                    }
                    Switch {
                        checked: settings.showMovementDirectionApp
                        onClicked: settings.showMovementDirectionApp = checked
                    }
                    Switch {
                        checked: settings.showMovementDirectionCover
                        onClicked: settings.showMovementDirectionCover = checked
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

            Text {
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
                text: "*" + qsTr("requires app restart")
            }
        }
    }
}
