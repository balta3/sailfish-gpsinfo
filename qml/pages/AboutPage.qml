import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: aboutPage

    allowedOrientations: Orientation.Portrait | Orientation.Landscape | Orientation.LandscapeInverted

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            anchors {
                top: parent.top
                left: parent.left
                leftMargin: aboutPage.isPortrait ? Theme.horizontalPageMargin : Theme.horizontalPageMargin * 3
            }
            width: parent.width - 2*anchors.leftMargin
            spacing: Theme.paddingLarge

            Item {
                width: parent.width
                height: Theme.paddingLarge
            }

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: Qt.resolvedUrl("/usr/share/icons/hicolor/256x256/apps/harbour-gpsinfo.png")
                width: Theme.iconSizeExtraLarge
                height: Theme.iconSizeExtraLarge
                smooth: true
                asynchronous: true
            }

            AboutLabel {
                font.pixelSize: Theme.fontSizeLarge
                color: Theme.highlightColor
                text: "GPSInfo"
            }

            AboutLabel {
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.primaryColor
                text: qsTr("An app to show all position information")
            }

            AboutLabel {
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
                text: qsTr("Version") + " 0.9-1"
            }

            AboutLabel {
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
                text: "Copyright © 2014-2016 Marcel Witte\n2019 Matti Viljanen"
            }

            AboutLabel {
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                text: qsTr("GPSInfo is open source software licensed under the terms of the GNU General Public License.")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("View license")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("LicensePage.qml"));
                }
            }

            AboutLabel {
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                text: qsTr("For suggestions, bugs and ideas visit ")
            }

            AboutLabel {
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall
                font.underline: true
                text: "https://github.com/direc85/harbour-gpsinfo"
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally(parent.text)
                }
            }

            Item {
                width: parent.width
                height: Theme.paddingMedium
            }
        }
    }
}
