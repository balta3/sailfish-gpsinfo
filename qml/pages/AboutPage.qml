import QtQuick 2.0
import Sailfish.Silica 1.0

Page {

    allowedOrientations: Orientation.Portrait | Orientation.Landscape | Orientation.LandscapeInverted

    states: [
        State {
            name: 'landscape';
            when: orientation === Orientation.Landscape || orientation === Orientation.LandscapeInverted;
            PropertyChanges {
                target:infoLabel
                anchors.topMargin: Theme.paddingLarge
            }
            AnchorChanges {
                target: versionLabel
                anchors.horizontalCenter: undefined
                anchors.left: parent.left
            }
            PropertyChanges {
                target: versionLabel
                width: parent.width * 0.4
                anchors.leftMargin: 0.05 * parent.width
            }
            AnchorChanges {
                target: copyrightLabel
                anchors.horizontalCenter: undefined
                anchors.left: parent.left
            }
            PropertyChanges {
                target: copyrightLabel
                width: parent.width * 0.4
                anchors.leftMargin: 0.05 * parent.width
            }
            AnchorChanges {
                target: licenseLabel
                anchors.horizontalCenter: undefined
                anchors.right: parent.right
                anchors.top: infoLabel.bottom
            }
            PropertyChanges {
                target: licenseLabel
                width: parent.width * 0.4
                anchors.rightMargin: 0.05 * parent.width
            }
            AnchorChanges {
                target: licenseButtonBox
                anchors.horizontalCenter: undefined
                anchors.right: parent.right
            }
            PropertyChanges {
                target: licenseButtonBox
                width: parent.width * 0.4
                anchors.rightMargin: 0.05 * parent.width
            }
            AnchorChanges {
                target: linkText
                anchors.horizontalCenter: undefined
                anchors.left: parent.left
                anchors.top: copyrightLabel.bottom
            }
            PropertyChanges {
                target: linkText
                width: parent.width * 0.4
                anchors.leftMargin: 0.05 * parent.width
            }
            AnchorChanges {
                target: link
                anchors.horizontalCenter: undefined
                anchors.left: parent.left
            }
            PropertyChanges {
                target: link
                width: parent.width * 0.4
                anchors.leftMargin: 0.05 * parent.width
            }
        }
    ]

    Image {
        id: icon
        anchors.top: parent.top
        anchors.topMargin: 2 * Theme.paddingLarge
        anchors.horizontalCenter: parent.horizontalCenter
        source: Qt.resolvedUrl("/usr/share/icons/hicolor/256x256/apps/harbour-gpsinfo.png")
        width: Theme.iconSizeExtraLarge
        height: Theme.iconSizeExtraLarge
        smooth: true
        asynchronous: true
    }

    Label {
        id: nameLabel
        anchors.top: icon.bottom
        anchors.topMargin: Theme.paddingLarge
        anchors.horizontalCenter: parent.horizontalCenter
        width: 0.8 * parent.width
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Theme.fontSizeLarge
        color: Theme.highlightColor
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        text: "GPSInfo"
    }

    Label {
        id: infoLabel
        anchors.top: nameLabel.bottom
        anchors.topMargin: 2 * Theme.paddingLarge
        anchors.horizontalCenter: parent.horizontalCenter
        width: 0.8 * parent.width
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Theme.fontSizeMedium
        color: Theme.primaryColor
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        text: qsTr("An app to show all position information")
    }

    Label {
        id: versionLabel
        anchors.top: infoLabel.bottom
        anchors.topMargin: 2 * Theme.paddingLarge
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Theme.fontSizeExtraSmall
        color: Theme.secondaryColor
        text: qsTr("Version") + " 0.8"
    }

    Label {
        id: copyrightLabel
        anchors.top: versionLabel.bottom
        anchors.topMargin: Theme.paddingSmall
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Theme.fontSizeExtraSmall
        color: Theme.secondaryColor
        text: "Copyright © 2014-2016 Marcel Witte\n2019 Matti Viljanen"
    }

    Label {
        id: licenseLabel
        anchors.top: copyrightLabel.bottom
        anchors.topMargin: 2 * Theme.paddingLarge
        anchors.horizontalCenter: parent.horizontalCenter
        width: 0.8 * parent.width
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.secondaryColor
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        text: qsTr("GPSInfo is open source software licensed under the terms of the GNU General Public License.")
    }

    Item {
        id: licenseButtonBox
        anchors.top: licenseLabel.bottom
        anchors.topMargin: 2 * Theme.paddingLarge
        anchors.horizontalCenter: parent.horizontalCenter
        width: 0.8 * parent.width
        height: licenseButton.height
        Button {
            id: licenseButton
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("View license")
            onClicked: {
                pageStack.push(Qt.resolvedUrl("LicensePage.qml"));
            }
        }
    }

    Label {
        id: linkText
        anchors.top: licenseButtonBox.bottom
        anchors.topMargin: 2 * Theme.paddingLarge
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.secondaryColor
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        text: qsTr("For suggestions, bugs and ideas visit ")
    }

    Label {
        id: link
        anchors.top: linkText.bottom
        anchors.topMargin: Theme.paddingLarge
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        color: Theme.secondaryColor
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Theme.fontSizeSmall
        font.underline: true
        text: "https://github.com/balta3/sailfish-gpsinfo"
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        MouseArea {
            anchors.fill: parent
            onClicked: Qt.openUrlExternally("https://github.com/balta3/sailfish-gpsinfo")
        }
    }
}
