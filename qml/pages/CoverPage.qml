import QtQuick 2.0
import Sailfish.Silica 1.0
import QtPositioning 5.0
import QtSensors 5.0
import gpsinfo 1.0

import "../LocationFormatter.js" as LocationFormater

CoverBackground {
    property PositionSource positionSource
    property Compass compass
    property GPSDataSource gpsDataSource
    Label {
        id: label
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 4
        text: qsTr("GPS Info")
    }
    Column {
        id: column
        anchors.top: label.bottom
        width: parent.width
        spacing: Theme.paddingLarge
        InfoField {
            label: qsTr("GPS")
            visible: settings.showGpsStateCover
            value: positionSource.active ? qsTr("active") : qsTr("inactive")
        }
        InfoField {
            label: positionSource.position.latitudeValid ? "" : qsTr("Latitude")
            visible: settings.showLatitudeCover
            fontpixelSize: Theme.fontSizeMedium
            value: {
                if (positionSource.position.latitudeValid) {
                    if (settings.value("coordinateFormat") === "DEG") {
                        return LocationFormater.decimalLatToDMS(positionSource.position.coordinate.latitude, 0)
                    } else {
                        return positionSource.position.coordinate.latitude
                    }
                }
                return "-"
            }
        }
        InfoField {
            label: positionSource.position.longitudeValid ? "" : qsTr("Longitude")
            visible: settings.showLongitudeCover
            fontpixelSize: Theme.fontSizeMedium
            value: {
                if (positionSource.position.longitudeValid) {
                    if (settings.value("coordinateFormat") === "DEG") {
                        return LocationFormater.decimalLongToDMS(positionSource.position.coordinate.longitude, 0)
                    } else {
                        return positionSource.position.coordinate.longitude
                    }
                }
                return "-"
            }
        }
        InfoField {
            label: qsTr("Altitude")
            visible: settings.showAltitudeCover
            value: {
                if (positionSource.position.altitudeValid) {
                    if (settings.value("units") == "MET") {
                        return positionSource.position.coordinate.altitude + " m"
                    } else {
                        return LocationFormater.roundToDecimal(positionSource.position.coordinate.altitude * 3.2808399, 2) + " ft"
                    }
                }
                return "-"
            }
        }
        InfoField {
            label: positionSource.position.speedValid ? "" : qsTr("Speed")
            visible: settings.showSpeedCover
            value: {
                if (positionSource.position.speedValid) {
                    if (settings.value("units") == "MET") {
                        return LocationFormater.roundToDecimal(positionSource.position.speed, 2) + " m/s"
                    } else {
                        return LocationFormater.roundToDecimal(positionSource.position.speed * 3.2808399, 2) + " ft/s"
                    }
                }
                return "-"
            }
        }
        InfoField {
            label: ""
            visible: settings.showLastUpdateCover
            value: Qt.formatTime(positionSource.position.timestamp, "hh:mm:ss")
        }
        InfoField {
            label: qsTr("Vert. acc.")
            visible: settings.showVerticalAccuracyCover
            value: {
                if (positionSource.position.verticalAccuracyValid) {
                    if (settings.value("units") == "MET") {
                        return positionSource.position.verticalAccuracy + " m"
                    } else {
                        return LocationFormater.roundToDecimal(positionSource.position.verticalAccuracy * 3.2808399, 2) + " ft"
                    }
                }
                return "-"
            }
        }
        InfoField {
            label: qsTr("Hor. acc.")
            visible: settings.showHorizontalAccuracyCover
            value: {
                if (positionSource.position.horizontalAccuracyValid) {
                    if (settings.value("units") == "MET") {
                        return positionSource.position.horizontalAccuracy + " m"
                    } else {
                        return LocationFormater.roundToDecimal(positionSource.position.horizontalAccuracy * 3.2808399, 2) + " ft"
                    }
                }
                return "-"
            }
        }
        InfoField {
            label: qsTr("Satel.")
            visible: settings.showSatelliteInfoCover
            value: gpsDataSource.numberOfUsedSatellites + "/" + gpsDataSource.numberOfVisibleSatellites
        }
        InfoField {
            label: ""
            visible: settings.showCompassDirectionCover
            value: LocationFormater.formatDirection(compass.reading.azimuth)
        }
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: positionSource.active ? "image://theme/icon-cover-cancel" : "image://theme/icon-cover-play"
            onTriggered: {
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
    }
}


