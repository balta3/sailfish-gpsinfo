import QtQuick 2.0
import Sailfish.Silica 1.0
import QtPositioning 5.2
import QtSensors 5.0
import harbour.gpsinfo 1.0
import "../components"

import "../LocationFormatter.js" as LocationFormater

CoverBackground {
    property PositionSource positionSource
    property Compass compass
    property GPSDataSource gpsDataSource
    Image {
        id: bgimg
        source: "../../images/coverbg.png"
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: sourceSize.height * width / sourceSize.width
    }
    Column {
        id: column
        anchors.top: parent.top
        anchors.topMargin: Theme.paddingMedium
        width: parent.width
        spacing: Theme.paddingLarge
        InfoField {
            label: qsTr("GPS")
            visible: settings.showGpsStateCover
            fontpixelSize: Theme.fontSizeMedium
            value: positionSource.active ? qsTr("active") : qsTr("inactive")
        }
        InfoField {
            label: positionSource.position.latitudeValid ? "" : qsTr("Latitude")
            visible: settings.showLatitudeCover
            fontpixelSize: Theme.fontSizeMedium
            value: {
                if (positionSource.position.latitudeValid) {
                    if (settings.coordinateFormat === "DEG") {
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
                    if (settings.coordinateFormat === "DEG") {
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
            fontpixelSize: Theme.fontSizeMedium
            value: {
                if (positionSource.position.altitudeValid) {
                    if (settings.units == "MET") {
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
            fontpixelSize: Theme.fontSizeMedium
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
            label: qsTr("Mov.")
            visible: settings.showMovementDirectionCover
            fontpixelSize: Theme.fontSizeMedium
            value: isNaN(gpsDataSource.movementDirection) ? "-" : LocationFormater.formatDirection(gpsDataSource.movementDirection)
        }
        InfoField {
            label: ""
            visible: settings.showLastUpdateCover
            fontpixelSize: Theme.fontSizeMedium
            value: Qt.formatTime(positionSource.position.timestamp, "hh:mm:ss")
        }
        InfoField {
            label: qsTr("Vert. acc.")
            visible: settings.showVerticalAccuracyCover
            fontpixelSize: Theme.fontSizeMedium
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
            label: qsTr("Hor. acc.")
            visible: settings.showHorizontalAccuracyCover
            fontpixelSize: Theme.fontSizeMedium
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
            label: qsTr("Satel.")
            visible: settings.showSatelliteInfoCover
            fontpixelSize: Theme.fontSizeMedium
            value: gpsDataSource.numberOfUsedSatellites + "/" + gpsDataSource.numberOfVisibleSatellites
        }
        InfoField {
            label: qsTr("Com.")
            visible: settings.showCompassDirectionCover
            fontpixelSize: Theme.fontSizeMedium
            value: LocationFormater.formatDirection(compass.reading === null ? 0 : compass.reading.azimuth)
        }
        InfoField {
            label: qsTr("Cal.")
            visible: settings.showCompassCalibrationCover
            fontpixelSize: Theme.fontSizeMedium
            value: compass.reading === null ? "-" : Math.round(compass.reading.calibrationLevel * 100) + "%"
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


