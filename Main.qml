import QtQuick
import QtQuick.Window
import QtQuick.Controls

Window {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("Device Storage")
    color: "#2e2f30"

    property int listviewwidth: 200
    property bool android: false


    MenuBar{
        id: menubar
        Menu{
            title: qsTr("App")
            MenuBarItem{
                text: qsTr("&Info")
            }
            MenuBarItem{
                text: qsTr("&Close")
                onTriggered: Qt.quit()
            }
        }
    }


    function animateListview(){

        listrect.width = 0
        showbutton.visible = true

    }

    Button{
        id: showbutton
        anchors.top: menubar.bottom
        anchors.topMargin: 0
        text: ">"
        width: android ? 50 : 30
        height: android ? 40 : 30
        onClicked: { showbutton.visible = false; listrect.width = listviewwidth  }
        visible: false
    }



    Rectangle{
        id: listrect
        x: 0
        width: listviewwidth
        color:"#404244"
        anchors.top: menubar.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.topMargin: 0

        ListView{
            id: listview
            width: parent.width - 2
            height: parent.height - 2
            x:1; y:1
            spacing: 5
            model: 50
            clip: true
            focus: true
            headerPositioning: ListView.OverlayHeader
            header: Rectangle{
                id: headerrect
                width: listview.width
                height: 30
                color: "#2e2f30"
                z:2

                Button{
                    id: viewbutton
                    anchors.right: headerrect.right
                    anchors.verticalCenter: headerrect.verticalCenter
                    text: "<"
                    width: android ? 50 : 30
                    height: android ? 40 : 30
                    onClicked: animateListview()
                }

            }

            delegate: Rectangle{
                id: wrapper
                height: 30
                width: listview.width-5
                x:2.5
                border.color: "white"
                color: "transparent"
                Text {
                    id: name
                    text: index
                    color: wrapper.ListView.isCurrentItem ? "red" : "white"
                    font.pointSize: 12
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {  listview.currentIndex = index   }
                }
            }

            highlight: Rectangle{
                color: "blue"
                focus: true
            }

        }
    }

    Rectangle{
        id: devicerect
        width: parent.width - listrect.width
        height: parent.height - menubar.height
        anchors.top: menubar.bottom
        anchors.left: listrect.right
        border.color: "gray"
        color: "transparent"

        Grid{
            id: grid
            width: devicerect.width - 20
            height: devicerect.height - 40
            columns: 2
            columnSpacing: 10
            rows: 7
            rowSpacing: 5

            x: 10; y:30
            Text {
                text: qsTr("Index:")
                color: "gray"
            }
            Text {
                text: listview.currentIndex
                color: "white"
            }
            Text {
                text: qsTr("Name:")
                color: "gray"
            }
            Text {
                text: qsTr("Name of device")
                color: "white"
            }
            Text {
                id: tdes
                text: qsTr("Description:")
                color: "gray"
            }
            TextInput {
                id: dinput
                width: grid.width - tdes.width - 10
                text: qsTr("Description of device could be a long text with more than one row!")
                color: "white"
                wrapMode: Text.WordWrap

            }
            Text {
                text: qsTr("URL:")
                color: "gray"
            }
            Text {
                id: urltext
                text:  "https://www.qt.io/product"
                color: "white"
                MouseArea{
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally(urltext.text)
                }
            }
            Text {
                text: qsTr("Count:")
                color: "gray"
            }
            Text {
                text: qsTr("Counts of device in Storage")
                color: "white"
            }
            Text {
                text: qsTr("Costs:")
                color: "gray"
            }
            Text {
                text: qsTr("Costs in €")
                color: "white"
            }
            Text {
                text: qsTr("Image:")
                color: "gray"
            }
            Image {
                id: deviceimage
                width: 100
                fillMode: Image.PreserveAspectFit
                source: ""
            }
        }



    }


    Component.onCompleted: {

        if(Qt.platform.os === "android")
            android = true

    }



}
