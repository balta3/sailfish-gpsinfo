import QtQuick 2.0
import QtPositioning 5.0
import QtSensors 5.0

Item {
    id: providers
    property alias positionSource: positionSource
    property alias compass: compass
    PositionSource {
        id: positionSource
        updateInterval: settings.updateInterval
        active: true
    }

    Compass {
        id: compass
        active: true
    }
}
