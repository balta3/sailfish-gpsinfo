import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSensors 5.0
import gpsinfo 1.0
import "../CircleCalculator.js" as CircleCalculator

Page {
    id: satelliteInfoPage
    property Compass compass
    property GPSDataSource gpsDataSource
    PageHeader {
        title: qsTr("Satellite Info")
    }

    function repaintSatellites() {
        canvas.requestPaint();
    }

    Canvas {
        id: canvas
        width: 500
        height: 500
        anchors.centerIn: parent
        property int north : compass.reading.azimuth;
        property variant satellites : gpsDataSource.satellites;
        onNorthChanged: requestPaint();
        onSatellitesChanged: requestPaint();
        onPaint: {
            if (visible) {
                var ctx = canvas.getContext('2d');
                ctx.clearRect(0,0,500,500);

                var radius = 240;
                var center = {x: 250, y: 250};
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
                ctx.font = "16px Arial";

                //North
                ctx.fillStyle = "rgb(0,0,255)";
                ctx.fillRect(compassPos.north.x - 15, compassPos.north.y - 15, 30, 30);
                ctx.fillStyle = "rgb(255,255,255)";
                ctx.fillText("N", compassPos.north.x, compassPos.north.y + 5);

                //South
                ctx.fillStyle = "rgb(0,0,255)";
                ctx.fillRect(compassPos.south.x - 15, compassPos.south.y - 15, 30, 30);
                ctx.fillStyle = "rgb(255,255,255)";
                ctx.fillText("S", compassPos.south.x, compassPos.south.y + 5);

                //West
                ctx.fillStyle = "rgb(0,0,255)";
                ctx.fillRect(compassPos.west.x - 15, compassPos.west.y - 15, 30, 30);
                ctx.fillStyle = "rgb(255,255,255)";
                ctx.fillText("W", compassPos.west.x, compassPos.west.y + 5);

                //East
                ctx.fillStyle = "rgb(0,0,255)";
                ctx.fillRect(compassPos.east.x - 15, compassPos.east.y - 15, 30, 30);
                ctx.fillStyle = "rgb(255,255,255)";
                ctx.fillText("E", compassPos.east.x, compassPos.east.y + 5);

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
                        ctx.fillRect(x - 14, y - 14, 28, 28);
                        ctx.fillStyle = "hsl(" + hue + ",100%,35%)";
                        ctx.fillRect(x - 12, y - 12, 24, 24);
                        ctx.fillStyle = "rgb(255,255,255)";
                        ctx.font = "16px Arial";
                        ctx.fillText(sat.identifier, x, y + 5)
                    } else {
                        ctx.fillStyle = "hsl(" + hue + ",100%,35%)";
                        ctx.fillRect(x - 10, y - 10, 20, 20);
                        ctx.fillStyle = "rgb(255,255,255)";
                        ctx.font = "14px Arial";
                        ctx.fillText(sat.identifier, x, y + 5)
                    }
                });
            }
        }
    }
}
