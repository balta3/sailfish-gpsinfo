import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    height: Theme.iconSizeLarge
    width: parent.width
    property alias text: label.text
    property alias lSw: leftSwitch
    property alias rSw: rightSwitch

    Label {
        id: label
        anchors {
            left: parent.left
            leftMargin: Theme.paddingLarge
            right: leftSwitch.left
            verticalCenter: parent.verticalCenter
        }
        maximumLineCount: 1
        truncationMode: TruncationMode.Fade
    }

    Switch {
        id: leftSwitch
        anchors {
            verticalCenter: parent.verticalCenter
            right: rightSwitch.left
            rightMargin: Theme.paddingLarge
        }
    }
    Switch {
        id: rightSwitch
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: Theme.paddingLarge
        }
    }
}
