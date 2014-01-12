import QtQuick 2.0
import Sailfish.Silica 1.0
import QtPositioning 5.0
import QtSensors 5.0

Page {
    id: page
    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: positionSource.active ? "deactivate GPS" : "activate GPS"
                onClicked: {
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
        }

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: "GPS Info"
            }
            InfoField {
                label: "GPS"
                value: positionSource.active ? "active" : "inactive"
            }
            InfoField {
                label: "Current latitude"
                value: positionSource.position.latitudeValid ? positionSource.position.coordinate.latitude : "-"
            }
            InfoField {
                label: "Current longitude"
                value: positionSource.position.longitudeValid ? positionSource.position.coordinate.longitude : "-"
            }
            InfoField {
                label: "Current altitude"
                value: positionSource.position.altitudeValid ? positionSource.position.coordinate.altitude + " m" : "-"
            }
            InfoField {
                label: "Current speed"
                value: positionSource.position.speedValid ? positionSource.position.speed + " m/s" : "-"
            }
            InfoField {
                label: "Last update"
                value: positionSource.position.timestamp
            }
            InfoField {
                label: "Vertical accuracy"
                value: positionSource.position.verticalAccuracyValid ? positionSource.position.verticalAccuracy + " m" : "-"
            }
            InfoField {
                label: "Horizontal accuracy"
                value: positionSource.position.horizontalAccuracyValid ? positionSource.position.horizontalAccuracy + " m" : "-"
            }
            InfoField {
                label: "Compass direction"
                value: compass.reading.azimuth
            }
        }
    }

    PositionSource {
        id: positionSource
        updateInterval: 1000
        active: true
    }

    Compass {
        id: compass
        active: true
    }
}


