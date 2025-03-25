import QtQuick 2.0
import Sailfish.Silica 1.0
import QtPositioning 5.2
import QtSensors 5.0
import harbour.gpsinfo 1.0

import "../LocationFormatter.js" as LocationFormater

Page {
    id: page
    property PositionSource positionSource
    property Compass compass
    property GPSDataSource gpsDataSource

    allowedOrientations: Orientation.Portrait | Orientation.Landscape | Orientation.LandscapeInverted

    SatelliteInfoPage {
        id: satelliteInfoPage
        compass: page.compass
        gpsDataSource: page.gpsDataSource
    }

    Timer {
            interval: 100
            repeat: false
            running: true
            onTriggered: {
                pageStack.pushAttached(satelliteInfoPage);
                //gpsDataSource.onSatellitesChanged = satelliteInfoPage.repaintSatellites();
            }
    }

    states: [
        State {
            name: 'landscape';
            when: orientation === Orientation.Landscape || orientation === Orientation.LandscapeInverted;
            PropertyChanges {
                target: column;
                width: page.width * 0.75;
            }
        }
    ]

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }
            MenuItem {
                text: positionSource.active ? qsTr("Deactivate GPS") : qsTr("Activate GPS")
                onClicked: {
                    if (positionSource.active) {
                        console.log("deactivating GPS");
                        positionSource.stop();
                        gpsDataSource.active = false;
                        console.log("active: " + positionSource.active);
                    } else {
                        console.log("activating GPS");
                        positionSource.start();
                        gpsDataSource.active = true;
                        console.log("active: " + positionSource.active);
                    }
                }
            }
            MenuItem {
                enabled: gpsDataSource.active
                text: qsTr("Copy location")
                onClicked: {
                    if (settings.coordinateFormat === "DEG") {
                        Clipboard.text = LocationFormater.decimalLatToDMS(positionSource.position.coordinate.latitude, 2)
                                + ", "
                                + LocationFormater.decimalLongToDMS(positionSource.position.coordinate.longitude, 2);
                    } else {
                        Clipboard.text = positionSource.position.coordinate.latitude
                                + ", "
                                + positionSource.position.coordinate.longitude
                    }
                }
            }
        }
        PageHeader {
            id: pageHeader
            title: qsTr("GPS Info")
        }

        contentHeight: column.height + pageHeader.height + 20;

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top;
            anchors.topMargin: pageHeader.height;
            InfoField {
                label: qsTr("GPS")
                visible: settings.showGpsStateApp
                value: positionSource.active ? qsTr("active") : qsTr("inactive")
            }
            InfoField {
                label: qsTr("Latitude")
                visible: settings.showLatitudeApp
                value: {
                    if (positionSource.position.latitudeValid) {
                        if (settings.coordinateFormat === "DEG") {
                            return LocationFormater.decimalLatToDMS(positionSource.position.coordinate.latitude, 2)
                        } else {
                            return positionSource.position.coordinate.latitude
                        }
                    }
                    return "-"
                }
            }
            InfoField {
                label: qsTr("Longitude")
                visible: settings.showLongitudeApp
                value: {
                    if (positionSource.position.longitudeValid) {
                        if (settings.coordinateFormat === "DEG") {
                            return LocationFormater.decimalLongToDMS(positionSource.position.coordinate.longitude, 2)
                        } else {
                            return positionSource.position.coordinate.longitude
                        }
                    }
                    return "-"
                }
            }
            InfoField {
                label: qsTr("Altitude")
                visible: settings.showAltitudeApp
                value: {
                    if (positionSource.position.altitudeValid) {
                        if (settings.units == "MET") {
                            return LocationFormater.roundToDecimal(positionSource.position.coordinate.altitude, 2) + " m"
                        } else {
                            return LocationFormater.roundToDecimal(positionSource.position.coordinate.altitude * 3.2808399, 2) + " ft"
                        }
                    }
                    return "-"
                }
            }
            InfoField {
                label: qsTr("Speed")
                visible: settings.showSpeedApp
                value: {
                    if (positionSource.position.speedValid) {
                        if (settings.units == "MET") {
                            if (settings.speedUnit == "SEC") {
                                return LocationFormater.roundToDecimal(positionSource.position.speed, 2) + " " + qsTr("m/s")
                            } else {
                                return LocationFormater.roundToDecimal(positionSource.position.speed * 60 * 60 / 1000, 2) + " " + qsTr("km/h")
                            }
                        } else {
                            if (settings.speedUnit == "SEC") {
                                return LocationFormater.roundToDecimal(positionSource.position.speed * 3.2808399, 2) + " " + qsTr("ft/s")
                            } else {
                                return LocationFormater.roundToDecimal(positionSource.position.speed * 2.23693629, 2) + " " + qsTr("mph")
                            }
                        }
                    }
                    return "-"
                }
            }
            InfoField {
                label: qsTr("Movement direction")
                visible: settings.showMovementDirectionApp
                value: isNaN(gpsDataSource.movementDirection) ? "-" : LocationFormater.formatDirection(gpsDataSource.movementDirection)
            }
            InfoField {
                label: qsTr("Last update")
                visible: settings.showLastUpdateApp
                value: Qt.formatTime(positionSource.position.timestamp, "hh:mm:ss")
            }
            InfoField {
                label: qsTr("Vertical accuracy")
                visible: settings.showVerticalAccuracyApp
                value: {
                    if (positionSource.position.verticalAccuracyValid) {
                        if (settings.units == "MET") {
                            return LocationFormater.roundToDecimal(positionSource.position.verticalAccuracy, 2) + " m"
                        } else {
                            return LocationFormater.roundToDecimal(positionSource.position.verticalAccuracy * 3.2808399, 2) + " ft"
                        }
                    }
                    return "-"
                }
            }
            InfoField {
                label: qsTr("Horizontal accuracy")
                visible: settings.showHorizontalAccuracyApp
                value: {
                    if (positionSource.position.horizontalAccuracyValid) {
                        if (settings.units == "MET") {
                            return LocationFormater.roundToDecimal(positionSource.position.horizontalAccuracy, 2) + " m"
                        } else {
                            return LocationFormater.roundToDecimal(positionSource.position.horizontalAccuracy * 3.2808399, 2) + " ft"
                        }
                    }
                    return "-"
                }
            }
            InfoField {
                label: qsTr("Satellites in use / view")
                visible: settings.showSatelliteInfoApp
                value: gpsDataSource.numberOfUsedSatellites + " / " + gpsDataSource.numberOfVisibleSatellites
            }
            InfoField {
                label: qsTr("Compass direction")
                visible: settings.showCompassDirectionApp
                value: LocationFormater.formatDirection(compass.reading.azimuth)
            }
        }
    }
}


