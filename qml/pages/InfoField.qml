import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    property alias label: label.text
    property alias value: value.text
    property variant fontpixelSize: Theme.fontSizeLarge
    anchors.left: parent.left
    anchors.leftMargin: Theme.paddingMedium
    anchors.right: parent.right
    anchors.rightMargin: Theme.paddingMedium
    height: 40
    Label {
        id: label
        color: Theme.primaryColor
        font.pixelSize: Theme.fontSizeLarge
        text: "Label"
    }
    Label {
        id: value
        anchors.right: parent.right
        color: Theme.secondaryHighlightColor
        font.pixelSize: Theme.fontSizeLarge
        text: "Value"
    }
}
