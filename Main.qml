import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs

import FDeviceLoader 1.0

Window {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("Device Storage")
    color: "#2e2f30"

    property int listviewwidth: 200
    property bool android: false

    property int leftmarging: 15

    ListModel{ id: devicemodel }

    property string messagetext: ""
    property string messagetitle: ""

    Rectangle{
        id: messagebox
        width: 300
        height: 150
        visible: false
        x: parent.width / 2 - messagebox.width/2
        y: parent.height / 2 - messagebox.height/2
        z:2

        // Title
        Rectangle{
            id: titlerect
            width: parent.width
            height: 24
            border.color: "gray"
            color: "lightgray"


            Text {
                text: messagetitle
                anchors.centerIn: parent
                font.letterSpacing: 2
            }


            MouseArea{
                id: dragArea
                anchors.fill: parent
                //Drag.active: true
                drag.target: messagebox
                drag.axis: Drag.XAndYAxis
            }

        }

        // Text
        Text {
            width: parent.width - 50
            x:25
            y:50
            wrapMode: Text.WordWrap
            text: messagetext
        }

        Button{
            text: "OK"
            width: 75
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 5
            onClicked: messagebox.visible = false
        }


    }

    function showMessageBox(title, text){

        messagetext = text
        messagetitle = title
        messagebox.visible = true


    }

    // C++ Class FDeviceLoader
    FDevice{
        id: device
        onErrorOccurred: (errorText) => { showMessageBox("ERROR", errorText) }
    }

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
        Menu{
            title: qsTr("Device")
            MenuBarItem{
                text: qsTr("&Add")
                onTriggered: addrect.visible = true
            }
            MenuBarItem{
                text: qsTr("&Delete")

            }
        }
    }

    function animateListview(){

        listrect.width = 0
        showbutton.visible = true

    }

    function addDevice(){

        var date = new Date
        var obj = { "date":date, "name":nameinput.text, "description":descinput.text,
        "url":urlinput.text, "pdf":pdfinput.text, "count":countinput.value,
        "price":priceinput.realValue, "image":image.source}
        device.addDevice(obj)
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

    // Device List
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
            model: devicemodel
            clip: true
            focus: true
            headerPositioning: ListView.OverlayHeader
            header: Rectangle{
                id: headerrect
                width: listview.width
                height: 30
                color: "#2e2f30"
                z:2

                Text {
                    text: qsTr("Items: ") +  device.deviceCount
                    color: "white"
                    font.pointSize: 12
                    anchors.left: headerrect.left
                    anchors.leftMargin: 5
                    anchors.verticalCenter: headerrect.verticalC
                }

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
                Row{
                    spacing: 5
                    Text {
                        text: index
                        color: wrapper.ListView.isCurrentItem ? "red" : "white"
                        font.pointSize: 12
                    }
                    Text {
                        text: name
                        color: wrapper.ListView.isCurrentItem ? "red" : "yellow"
                        font.pointSize: 12
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        listview.currentIndex = index

                        // Test to load image
                        //deviceimage.image = devicemodel.get(listview.currentIndex).image

                    }
                }
            }

            highlight: Rectangle{
                color: "blue"
                focus: true
            }

        }
    }

    // Decice Information Window
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
            rows: 8
            rowSpacing: 5

            x: 10; y:30
            Row{
            spacing: 5
                Text {
                    text: qsTr("Index:")
                    color: "gray"
                }
                Text {
                    text: listview.currentIndex
                    color: "white"
                }
            }

            Row{
                spacing: 5
                Text {
                    text: "Date: "
                    color: "gray"
                }
                Text {
                    text: devicemodel.get(listview.currentIndex).date.toLocaleDateString(Qt.locale("de_DE"))
                    color: "white"
                }
            }

            Text {
                text: qsTr("Name:")
                color: "gray"
            }
            Text {
                text: devicemodel.get(listview.currentIndex).name
                color: "#00C853"
            }
            Text {
                id: tdes
                text: qsTr("Description:")
                color: "gray"
            }
            TextInput {
                id: dinput
                width: grid.width - tdes.width - 10
                text: devicemodel.get(listview.currentIndex).description
                color: "#F57F17"
                wrapMode: Text.WordWrap

            }
            Text {
                text: qsTr("URL:")
                color: "gray"
            }
            Text {
                id: urltext
                text: devicemodel.get(listview.currentIndex).url
                color: urltext.text === "X" ? "red" : "#2979FF"
                MouseArea{
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally(urltext.text)
                }
            }
            Text {
                text: qsTr("PDF:")
                color: "gray"
            }
            Text {
                id: pdfpath
                text: devicemodel.get(listview.currentIndex).pdf
                color: pdfpath.text === "X" ? "red" : "#2979FF"
                MouseArea{
                    anchors.fill: parent
                    onClicked:{ }
                }
            }
            Text {
                text: qsTr("Count:")
                color: "gray"
            }
            Text {
                text: devicemodel.get(listview.currentIndex).count
                color: "white"
            }
            Text {
                text: qsTr("Costs:")
                color: "gray"
            }
            Text {
                text: devicemodel.get(listview.currentIndex).price +  " €"
                color: "white"
            }
            Text {
                text: qsTr("Image:")
                color: "gray"
            }

            Rectangle{
                id: imagerectangle
                width: 250
                height: 150
                border.color: "white"
                color: "transparent"

                Image{
                    id: deviceimage
                    //source: device.deviceImage
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit

                }
            }
        }
    }


    // Add Device Window
    Rectangle{
        id: addrect
        width: parent.width - 100
        height: parent.height - 100
        anchors.centerIn: parent
        visible: false
        color: "beige"

        MouseArea{ anchors.fill: parent }

        Column{
            width: addrect.width
            height: addrect.height-50
            spacing: 8
            x:leftmarging; y:10
            TextArea{
                id: nameinput
                width: parent.width - leftmarging * 2
                placeholderText: "Entere name"
                color: "#1565C0"

            }
            TextArea{
                id: descinput
                width: parent.width - leftmarging * 2
                wrapMode: Text.WordWrap
                placeholderText: "Entere description"
                color: "#1565C0"
            }
            TextArea{
                id: urlinput
                width: parent.width - leftmarging * 2
                placeholderText: "Entere url"
                color: "#1565C0"
            }
            TextArea{
                id: pdfinput
                width: parent.width - leftmarging * 2
                placeholderText: "Entere path of pdf"
                color: "#1565C0"
            }
            Row{
                spacing: 5
                Text { text: qsTr("Count:"); color: "gray" }
                SpinBox{ id: countinput; from: 1; to:9999 }
            }
            Row{
                spacing: 10
                Text { text: qsTr("Price:"); color: "gray" }
                SpinBox{
                    id: priceinput;
                    from: 0; to:9999;

                    property int decimals: 2
                    property real realValue: value / 100

                    validator: DoubleValidator {
                             bottom: Math.min(priceinput.from, priceinput.to)
                             top:  Math.max(priceinput.from, priceinput.to)
                            }

                    textFromValue: function(value, locale) {
                        return Number(value / 100).toLocaleString(locale, 'f', priceinput.decimals)
                    }

                    valueFromText: function(text, locale) {
                            return Number.fromLocaleString(locale, text) * 100
                    }
                }
            }
            Row{
                id: row
                width: parent.width
                spacing: 10
                Text {id: ti; text: qsTr("Image:"); color: "gray" }

                // The Image - Rectangle
                Rectangle{
                    id: imageinput;
                    width: parent.width - ti.width - leftmarging * 2 > 300 ? 300 : parent.width - ti.width - leftmarging * 2
                    height: imageinput.width / 2
                    border.color: "gray"

                    // The image wich was droped
                    Image {
                        id: image
                        anchors.fill: parent
                    }

                    // For droping image into the rectangle
                    DropArea{
                        anchors.fill: parent
                        onDropped: (drop)=> { image.source = drop.text }
                    }
                }
            }

        }

        Row{
            anchors.bottom: addrect.bottom
            anchors.bottomMargin: 10
            x:10
            spacing: 10
            Button{
                text: "Cancel"
                onClicked: addrect.visible = false
            }
            Button{
                text: "Accept"
                onClicked: addDevice()
            }
        }
    }

    Component.onCompleted: {

        if(Qt.platform.os === "android")
            android = true

        // Calls the C++ function
        device.loadDeviceMap()

        var list = device.getModelMap();

        for(var i = 0; i < device.deviceCount; i++){
//            console.log(list[i].name)
//            console.log(list[i].image)


            devicemodel.insert(i,{"name":list[i].name, "date":list[i].date, "description":list[i].description,
                              "pdf":list[i].pdf, "count":list[i].count, "price":list[i].price, "url":list[i].url,
                               "image":list[i].image})
        }

        listview.currentIndex = 0
        //deviceimage = device.deviceImage

        showMessageBox("Info", "Started")

    }

}
