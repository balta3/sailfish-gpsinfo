import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    width: 260
    height: 90
    color: "transparent"
    property alias text: label.text
    Label {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Theme.paddingLarge
    }
}
