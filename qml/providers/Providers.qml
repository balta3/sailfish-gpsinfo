import QtQuick 2.0
import QtPositioning 5.2
import QtSensors 5.0
import harbour.gpsinfo 1.0

Item {
    id: providers
    property alias positionSource: positionSource
    property alias compass: compass
    property alias gpsDataSource: gpsDataSource
    PositionSource {
        id: positionSource
        updateInterval: settings.updateInterval
        active: true
    }

    Compass {
        id: compass
        active: true
    }

    GPSDataSource {
        id: gpsDataSource
        updateInterval: settings.updateInterval
        active: true
    }
}
