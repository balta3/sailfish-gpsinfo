import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSensors 5.0
import harbour.gpsinfo 1.0
import "../components"

Page {
    id: satelliteInfoPage

    allowedOrientations: Orientation.Portrait | Orientation.Landscape | Orientation.LandscapeInverted

    property Compass compass
    property GPSDataSource gpsDataSource
    PageHeader {
        title: qsTr("Satellite Info")
    }

    function repaintSatellites() {
        canvas.requestPaint();
    }

    onVisibleChanged: canvasBackground.requestPaint()

    states: [
        State {
            name: 'landscape';
            when: orientation === Orientation.Landscape || orientation === Orientation.LandscapeInverted;
            AnchorChanges {
                target: canvas;
                anchors.horizontalCenter: undefined;
                anchors.left: satelliteInfoPage.left;
            }
            PropertyChanges {
                target: satellitesInfo;
                width: satelliteInfoPage.width / 2;
                anchors.leftMargin: satelliteInfoPage.width / 2.2;
            }
        }
    ]

    property int canvasWidth: Screen.width - 30
    property int radius: canvasWidth / 2 - 30
    property int center: canvasWidth / 2

    Canvas {
        id: canvasBackground
        anchors.fill: canvas
        onVisibleChanged: if(visible) requestPaint()
        onPaint: {
            var ctx = canvasBackground.getContext('2d');

            ctx.clearRect(0, 0, canvasWidth, canvasWidth);

            //Background
            var grd=ctx.createRadialGradient(center,center,5,center,center,radius);
            grd.addColorStop(0,Qt.rgba(0.0, 1.0, 0.0, 0.3));
            grd.addColorStop(1,Qt.rgba(0.0, 1.0, 0.0, 0.6));
            ctx.fillStyle = grd;
            ctx.beginPath();
            ctx.arc(center, center, radius, 0, Math.PI * 2, false);
            ctx.closePath();
            ctx.fill();

            // Circles
            ctx.strokeStyle = Qt.rgba(0.0, 1.0, 0.0, 1.0);

            ctx.beginPath();
            ctx.arc(center, center, radius * Math.cos(Math.PI * 1 / 6), 0, Math.PI * 2, false);
            ctx.closePath();
            ctx.stroke();

            ctx.beginPath();
            ctx.arc(center, center, radius * Math.cos(Math.PI * 2 / 6), 0, Math.PI * 2, false);
            ctx.closePath();
            ctx.stroke();
        }
    }

    Canvas {
        id: canvas
        width: Screen.width - 30;
        height: Screen.width - 30;
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: satelliteInfoPage.horizontalCenter;
        anchors.left: undefined;
        property int north : !settings.rotate || compass.reading === null ? 0 : compass.reading.azimuth;
        property variant satellites : gpsDataSource.satellites;
        property int signSizeSmall: Theme.fontSizeExtraSmall + 4;
        property int signSizeActive: Theme.fontSizeExtraSmall + 4;
        onNorthChanged: requestPaint();
        onSatellitesChanged: requestPaint();
        onVisibleChanged: if(visible) requestPaint()
        onPaint: {
            if (visible) {
                var ctx = canvas.getContext('2d');
                ctx.clearRect(0, 0, canvasWidth, canvasWidth);
                var northRad = north * Math.PI / 180;
                var compassPos = {
                    north: {
                        x: center - Math.sin(northRad) * radius,
                        y: center - Math.cos(northRad) * radius
                    },
                    south: {
                        x: center + Math.sin(northRad) * radius,
                        y: center + Math.cos(northRad) * radius
                    },
                    west: {
                        x: center + Math.sin(northRad - Math.PI / 2) * radius,
                        y: center + Math.cos(northRad - Math.PI / 2) * radius
                    },
                    east: {
                        x: center + Math.sin(northRad + Math.PI / 2) * radius,
                        y: center + Math.cos(northRad + Math.PI / 2) * radius
                    }
                }

                // Lines
                ctx.strokeStyle = Qt.rgba(0.0, 1.0, 0.0, 1.0);
                ctx.beginPath();
                ctx.moveTo(compassPos.north.x, compassPos.north.y);
                ctx.lineTo(compassPos.south.x, compassPos.south.y);
                ctx.closePath();
                ctx.stroke();
                ctx.beginPath();
                ctx.moveTo(compassPos.west.x, compassPos.west.y);
                ctx.lineTo(compassPos.east.x, compassPos.east.y);
                ctx.closePath();
                ctx.stroke();

                // Draw satellites one by one
                ctx.textAlign = "center";
                ctx.font = Theme.fontSizeExtraSmall + "px Sail Sans Pro";
                var azimuthRad, elevationRad, x, y, dx;
                satellites.forEach(function(sat) {
//                    var inUseStr = sat.inUse ? "in use" : "not in use";
//                    console.log("drawing sat " + sat.identifier
//                                + "\tat azimuth " + sat.azimuth
//                                + "\t and elevation " + sat.elevation
//                                + "\twith signal strength " + sat.signalStrength
//                                + " \t" + inUseStr);
                    azimuthRad = ((sat.azimuth - north) % 360) * Math.PI / 180;
                    elevationRad = sat.elevation * Math.PI / 180;
                    x = center + Math.sin(azimuthRad) * radius * Math.cos(elevationRad);
                    y = center - Math.cos(azimuthRad) * radius * Math.cos(elevationRad);
                    dx = sat.identifier >= 100 ? 1.4 : (sat.identifier >= 10 ? 1.2 : 1.0);

                    ctx.fillStyle = "hsl(" + (sat.signalStrength < 40 ? sat.signalStrength : 40) * 3 + ",100%,35%)";
                    if (sat.inUse) {
                        ctx.fillRect(x - signSizeActive*dx / 2 - 2, y - signSizeActive / 2 - 2, signSizeActive*dx + 4, signSizeActive + 4);
                        ctx.fillRect(x - signSizeActive*dx / 2,     y - signSizeActive / 2,     signSizeActive*dx,     signSizeActive);
                    } else {
                        ctx.fillRect(x - signSizeSmall*dx / 2,      y - signSizeSmall / 2,      signSizeSmall*dx,      signSizeSmall);
                    }

                    ctx.fillStyle = Qt.rgba(1.0, 1.0, 1.0, 1.0);
                    ctx.fillText(sat.identifier, x, y + Theme.fontSizeExtraSmall / 2 - 5)
                });

                // Signs
                ctx.textAlign = "center";
                ctx.font = Theme.fontSizeSmall + "px Sail Sans Pro";
                var signSize = Theme.fontSizeSmall + 3;

                // North, South, West, East
                ctx.fillStyle = Qt.rgba(0.0, 0.0, 1.0, 1.0);
                ctx.fillRect(compassPos.north.x - signSize / 2, compassPos.north.y - signSize / 2, signSize, signSize);
                ctx.fillRect(compassPos.south.x - signSize / 2, compassPos.south.y - signSize / 2, signSize, signSize);
                ctx.fillRect(compassPos.west.x  - signSize / 2, compassPos.west.y  - signSize / 2, signSize, signSize);
                ctx.fillRect(compassPos.east.x  - signSize / 2, compassPos.east.y  - signSize / 2, signSize, signSize);

                ctx.fillStyle = Qt.rgba(1.0, 1.0, 1.0, 1.0);
                ctx.fillText("N", compassPos.north.x, compassPos.north.y + Theme.fontSizeSmall / 2 - 5);
                ctx.fillText("S", compassPos.south.x, compassPos.south.y + Theme.fontSizeSmall / 2 - 5);
                ctx.fillText("W", compassPos.west.x,  compassPos.west.y  + Theme.fontSizeSmall / 2 - 5);
                ctx.fillText("E", compassPos.east.x,  compassPos.east.y  + Theme.fontSizeSmall / 2 - 5);
            }
        }
    }
    InfoField {
        id: satellitesInfo
        label: qsTr("Satellites in use / view")
        value: gpsDataSource.numberOfUsedSatellites + " / " + gpsDataSource.numberOfVisibleSatellites
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.paddingLarge
    }
}
