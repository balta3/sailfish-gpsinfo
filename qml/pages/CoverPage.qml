import QtQuick 2.0
import Sailfish.Silica 1.0
import QtPositioning 5.0
import QtSensors 5.0

import "../LocationFormatter.js" as LocationFormater

CoverBackground {
    property PositionSource positionSource
    property Compass compass
    Label {
        id: label
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 4
        text: "GPS Info"
    }
    Column {
        id: column
        anchors.top: label.bottom
        width: parent.width
        spacing: Theme.paddingLarge
        InfoField {
            label: "GPS"
            visible: settings.showGpsStateCover
            value: positionSource.active ? "active" : "inactive"
        }
        InfoField {
            label: positionSource.position.latitudeValid ? "" : "Latitude"
            visible: settings.showLatitudeCover
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
            label: positionSource.position.longitudeValid ? "" : "Longitude"
            visible: settings.showLongitudeCover
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
            label: "Altitude"
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
            label: positionSource.position.speedValid ? "" : "Speed"
            visible: settings.showSpeedCover
            value: {
                if (positionSource.position.speedValid) {
                    if (settings.value("units") == "MET") {
                        return positionSource.position.speed + " m/s"
                    } else {
                        return LocationFormater.roundToDecimal(positionSource.position.speed * 3.2808399, 2) + " ft/s"
                    }
                }
                return "-"
            }
        }
        InfoField {
            label: "Last update"
            visible: settings.showLastUpdateCover
            value: positionSource.position.timestamp
        }
        InfoField {
            label: "Vert. acc."
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
            label: "Hor. acc."
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
            label: "Compass direction"
            visible: settings.showCompassDirectionCover
            value: compass.reading.azimuth
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
                    console.log("active: " + positionSource.active);
                } else {
                    console.log("activating GPS");
                    positionSource.start();
                    console.log("active: " + positionSource.active);
                }
            }
        }

        /*CoverAction {
            iconSource: "image://theme/icon-cover-pause"
        }*/
    }
}


