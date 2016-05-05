import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSensors 5.0
import harbour.gpsinfo 1.0
import "../CircleCalculator.js" as CircleCalculator

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

    Canvas {
        id: canvas
        width: Screen.width - 30;
        height: Screen.width - 30;
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: satelliteInfoPage.horizontalCenter;
        anchors.left: undefined;
        property int north : compass.reading.azimuth;
        property variant satellites : gpsDataSource.satellites;
        onNorthChanged: requestPaint();
        onSatellitesChanged: requestPaint();
        onPaint: {
            if (visible) {
                var ctx = canvas.getContext('2d');
                var canvasSize = Screen.width - 30;
                ctx.clearRect(0, 0, canvasSize, canvasSize);

                var radius = canvasSize / 2 - 30;
                var center = {x: canvasSize / 2, y: canvasSize / 2};
                var northRad = CircleCalculator.degreeToRad(north);
                var compassPos = {
                    north: {
                        x: center.x - Math.sin(northRad) * radius,
                        y: center.y - Math.cos(northRad) * radius
                    },
                    south: {
                        x: center.x + Math.sin(northRad) * radius,
                        y: center.y + Math.cos(northRad) * radius
                    },
                    west: {
                        x: center.x + Math.sin(northRad - Math.PI / 2) * radius,
                        y: center.y + Math.cos(northRad - Math.PI / 2) * radius
                    },
                    east: {
                        x: center.x + Math.sin(northRad + Math.PI / 2) * radius,
                        y: center.y + Math.cos(northRad + Math.PI / 2) * radius
                    }
                }

                //Background
                var grd=ctx.createRadialGradient(center.x,center.y,5,center.x,center.y,radius);
                grd.addColorStop(0,"rgba(0,255,0,0.3)");
                grd.addColorStop(1,"rgba(0,255,0,0.6)");
                ctx.fillStyle = grd;
                ctx.beginPath();
                ctx.arc(center.x, center.y, radius, 0, Math.PI * 2, false);
                ctx.closePath();
                ctx.fill();

                //Lines
                ctx.strokeStyle = "rgb(0,255,0)";
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

                ctx.beginPath();
                ctx.arc(center.x, center.y, radius * Math.cos(Math.PI * 1 / 6), 0, Math.PI * 2, false);
                ctx.closePath();
                ctx.stroke();

                ctx.beginPath();
                ctx.arc(center.x, center.y, radius * Math.cos(Math.PI * 2 / 6), 0, Math.PI * 2, false);
                ctx.closePath();
                ctx.stroke();

                //Signs
                ctx.textAlign = "center";
                ctx.font = Theme.fontSizeSmall + "px Sail Sans Pro";
                var signSize = Theme.fontSizeSmall + 3;

                //North
                ctx.fillStyle = "rgb(0,0,255)";
                ctx.fillRect(compassPos.north.x - signSize / 2, compassPos.north.y - signSize / 2, signSize, signSize);
                ctx.fillStyle = "rgb(255,255,255)";
                ctx.fillText("N", compassPos.north.x, compassPos.north.y + Theme.fontSizeSmall / 2 - 5);

                //South
                ctx.fillStyle = "rgb(0,0,255)";
                ctx.fillRect(compassPos.south.x - signSize / 2, compassPos.south.y - signSize / 2, signSize, signSize);
                ctx.fillStyle = "rgb(255,255,255)";
                ctx.fillText("S", compassPos.south.x, compassPos.south.y + Theme.fontSizeSmall / 2 - 5);

                //West
                ctx.fillStyle = "rgb(0,0,255)";
                ctx.fillRect(compassPos.west.x - signSize / 2, compassPos.west.y - signSize / 2, signSize, signSize);
                ctx.fillStyle = "rgb(255,255,255)";
                ctx.fillText("W", compassPos.west.x, compassPos.west.y + Theme.fontSizeSmall / 2 - 5);

                //East
                ctx.fillStyle = "rgb(0,0,255)";
                ctx.fillRect(compassPos.east.x - signSize / 2, compassPos.east.y - signSize / 2, signSize, signSize);
                ctx.fillStyle = "rgb(255,255,255)";
                ctx.fillText("E", compassPos.east.x, compassPos.east.y + Theme.fontSizeSmall / 2 - 5);

                var signSizeSmall = Theme.fontSizeExtraSmall + 4;
                var signSizeActive = Theme.fontSizeExtraSmall + 4;
                satellites.forEach(function(sat) {
                    /*var inUseStr = sat.inUse ? "in use" : "not in use";
                    console.log("drawing sat " + sat.identifier
                                + "\tat azimuth " + sat.azimuth
                                + "\t and elevation " + sat.elevation
                                + "\twith signal strength " + sat.signalStrength
                                + " \t" + inUseStr);*/
                    var azimuthRad = CircleCalculator.degreeToRad((sat.azimuth - north) % 360);
                    var elevationRad = CircleCalculator.degreeToRad(sat.elevation);
                    var x = center.x + Math.sin(azimuthRad) * radius * Math.cos(elevationRad);
                    var y = center.y - Math.cos(azimuthRad) * radius * Math.cos(elevationRad);

                    var hue = (sat.signalStrength < 40 ? sat.signalStrength : 40) * 3;
                    if (sat.inUse) {
                        ctx.fillStyle = "rgb(255,255,255)";
                        ctx.fillRect(x - signSizeActive / 2 - 2, y - signSizeActive / 2 - 2, signSizeActive + 4, signSizeActive + 4);
                        ctx.fillStyle = "hsl(" + hue + ",100%,35%)";
                        ctx.fillRect(x - signSizeActive / 2, y - signSizeActive / 2, signSizeActive, signSizeActive);
                        ctx.fillStyle = "rgb(255,255,255)";
                        ctx.font = Theme.fontSizeExtraSmall + "px Sail Sans Pro";
                        ctx.fillText(sat.identifier, x, y + Theme.fontSizeExtraSmall / 2 - 5)
                    } else {
                        ctx.fillStyle = "hsl(" + hue + ",100%,35%)";
                        ctx.fillRect(x - signSizeSmall / 2, y - signSizeSmall / 2, signSizeSmall, signSizeSmall);
                        ctx.fillStyle = "rgb(255,255,255)";
                        ctx.font = Theme.fontSizeExtraSmall + "px Sail Sans Pro";
                        ctx.fillText(sat.identifier, x, y + Theme.fontSizeExtraSmall / 2 - 5)
                    }
                });
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
