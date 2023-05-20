import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs
import QtCore


import FDeviceLoader 1.0
import FDeviceNetwork 1.0

Window {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("Device Storage")
    color: "#2e2f30"

    property int listviewwidth: 200
    property bool android: false
    property bool itemselected: false
    property bool deleteitem: false
    property bool changeitem: false

    property int leftmarging: 15
    property int fontsize: 12

    ListModel{ id: devicemodel }

    // MessageBox
    // ---------------------------------------------
    property string messagetext: ""
    property string messagetitle: ""
    property bool okbutton: true
    property bool cancelbutton: false

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
                id: title
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

        Row{
            spacing: 5
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 5
            Button{
                text: "Cancel"
                width: 75
                visible: cancelbutton
                onClicked: messagebox.visible = false
            }
            Button{
                text: "OK"
                width: 75
                visible: okbutton
                onClicked: {

                    messagebox.visible = false
                    if(deleteitem){
                        deleteitem = false
                        var key = devicemodel.get( listview.currentIndex).name
                        if( device.deleteDevice( key ) ){
                            updateListView()
                        }
                    }
                }
            }
        }
    }

    function showMessageBox(title, text, ok, cancel){

        messagetext = text
        messagetitle = title
        messagebox.visible = true
        okbutton = ok
        cancelbutton = cancel
    }
    // !--------------------------------------------

    // Open Dialog
    // ---------------------------------------------
    FileDialog {
           id: fileDialog
           currentFolder: StandardPaths.standardLocations(StandardPaths.DownloadLocation)[0]
           onAccepted: {
               device.loadDeviceDatas( currentFile )
               updateListView()
           }
       }
    // !--------------------------------------------


    // C++ Class FDeviceLoader
    FDevice{
        id: device
        onErrorOccurred: (errorText) => { showMessageBox("ERROR", errorText, true, false) }
        onInfo: (infoText) => { showMessageBox("Info", infoText, true, false)    }
        onDeviceAdded: (status) => {

            if(status){
                addrect.visible = false
                updateListView()
                changeitem = false
                clearForm()
            }else{
                showMessageBox("Error", qsTr("Could not save device!"), true, false)
            }
        }
    }

    // C++ Class FDeviceNetwork
    FNetwork{
        id: network
        onNetworkError: (errorText) => { showMessageBox("Error", errorText, true , false)  }
        onNetworkFinished: (infoText) => { showMessageBox("Network", infoText, true , false) }
    }


    // Menu
    // ---------------------------------------------
    MenuBar{
        id: menubar
        Menu{
            title: qsTr("App")
            MenuBarItem{
                text: qsTr("&Info")
                icon.source: "qrc:/png/info.png"
                onTriggered: { inforect.visible = true  }

            }
            MenuBarItem{
                text: qsTr("&Close")
                icon.source: "qrc:/png/close.png"
                onTriggered: Qt.quit()
            }
        }
        Menu{
            title: qsTr("Device")
            MenuBarItem{
                text: qsTr("&Add")
                icon.source: "qrc:/png/add.png"
                onTriggered: { addrect.visible = true; changeitem = false; clearForm() }
                enabled:  addrect.visible ? false : true
            }
            MenuBarItem{
                text: qsTr("&Delete")
                icon.source: "qrc:/png/garbage.png"
                enabled: itemselected ? true : false
                onTriggered: {

                    var itemname = devicemodel.get( listview.currentIndex).name
                    deleteitem = true
                    var text = "Do you want delete Item: " + itemname
                    showMessageBox("Delete",text, true, true )
                }
            }
        }
        Menu{
            title: qsTr("&File")
            MenuBarItem{
                text: qsTr("&Open")
                icon.source: "qrc:/png/open.png"
                onTriggered: {

                    fileDialog.open()
                }
            }
            MenuBarItem{
                text: qsTr("&Find")
                icon.source: "qrc:/png/search.png"
            }
            MenuBarItem{
                text: qsTr("&Download")
                icon.source: "qrc:/png/download.png"
                onTriggered: network.tryNetwork()
            }
        }
    }
    //!----------------------------------------------

    function animateListview(){

        listrect.width = 0
        showbutton.visible = true

    }

    function addDevice(){

        var date = new Date
        var obj = { "date":date, "name":nameinput.text, "description":descinput.text,
        "url":urlinput.text, "pdf":pdfinput.text, "count":countinput.value,
        "price":priceinput.realValue, "image":image.source, "imagepath":image.source}
        device.addDevice(obj, changeitem)
    }

    function updateListView(){

        devicemodel.clear()
        var list = device.getModelMap();

        for(var i = 0; i < device.deviceCount; i++){

            devicemodel.insert(i,{"name":list[i].name, "date":list[i].date, "description":list[i].description,
                              "pdf":list[i].pdf, "count":list[i].count, "price":list[i].price, "url":list[i].url,
                               "image":list[i].image, "imagepath":list[i].imagepath})
        }

        if( device.deviceCount > 0 )
             listview.currentIndex = 0

    }

    function setDeviceForChange(){

        changeitem = true

        // Copy datas from DeviceWindow to AddDeviceWindow
        nameinput.text = devicemodel.get(listview.currentIndex).name
        descinput.text = devicemodel.get(listview.currentIndex).description
        urlinput.text = devicemodel.get(listview.currentIndex).url
        pdfinput.text = devicemodel.get(listview.currentIndex).pdf
        countinput.value = devicemodel.get(listview.currentIndex).count
        priceinput.value = devicemodel.get(listview.currentIndex).price * 100
        image.source = devicemodel.get(listview.currentIndex).imagepath
    }

    function clearForm(){

        nameinput.text = ""
        descinput.text = ""
        urlinput.text = ""
        pdfinput.text = ""
        countinput.value = 1
        priceinput.value = 0.0
        image.source = ""
    }

    // Button to open ListView
    // --------------------------------------------------
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
    // !-------------------------------------------------

    // Device List
    // --------------------------------------------------
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

                // Button to open ListView
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

            footerPositioning: ListView.OverlayFooter
            footer: Rectangle{
                id: footerrect
                width: listview.width
                height: 30
                color: "#2e2f30"
                border.color: "white"
                Text {
                    x: 5
                    text: qsTr("Total: ") + device.totalCost.toFixed(2) + " €"
                    color: "white"
                    font.pointSize: fontsize
                    anchors.verticalCenter: parent.verticalCenter
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
                    x:5
                    anchors.verticalCenter: parent.verticalCenter
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
                        itemselected = true

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
    // !-------------------------------------------------

    // Decice Information Window
    // --------------------------------------------------
    Rectangle{
        id: devicerect
        width: parent.width - listrect.width
        height: parent.height - menubar.height
        anchors.top: menubar.bottom
        anchors.left: listrect.right
        border.color: "gray"
        color: "transparent"

        // Button for open device to edit
        Button{
            id: editbutton
            text: ""
            anchors.right: parent.right
            icon.source: "qrc:/png/edit.png"
            onClicked: {

                setDeviceForChange()
                addrect.visible = true


            }
        }

        // Next device button
        Button{
            id: nextbutton
            anchors.right: editbutton.left
            anchors.rightMargin: 20
            icon.source: "qrc:/png/next.png"
            enabled: listview.currentIndex >= listview.count-1 ? false : true
            onClicked: { listview.currentIndex++ }
        }
        Button{
            id: previousbutton
            anchors.right: nextbutton.left
            anchors.rightMargin: 5
            icon.source: "qrc:/png/previous.png"
            enabled: listview.currentIndex <= 0 ? false : true
            onClicked: { listview.currentIndex-- }
        }



        Grid{
            id: grid
            width: devicerect.width - 20
            height: devicerect.height - 40
            columns: 2
            columnSpacing: 10
            rows: 9
            rowSpacing: 5

            x: 10; y:30
            Row{
            spacing: 5
                Text {
                    text: qsTr("Index:")
                    color: "gray"
                    font.pointSize: fontsize
                }
                Text {
                    text: listview.currentIndex
                    color: "white"
                    font.pointSize: fontsize
                }
            }

            Row{
                spacing: 5
                Text {
                    text: "Date: "
                    color: "gray"
                    font.pointSize: fontsize
                }
                Text {
                    text: listview.currentIndex >= 0 ?  devicemodel.get(listview.currentIndex).date.toLocaleDateString(Qt.locale("de_DE")) : " "
                    color: "white"
                    font.pointSize: fontsize
                }
            }

            Text {
                text: qsTr("Name:")
                color: "gray"
                font.pointSize: fontsize
            }
            Text {
                text: listview.currentIndex >= 0 ? devicemodel.get(listview.currentIndex).name : " "
                color: "#00C853"
                font.pointSize: fontsize
            }
            Text {
                id: tdes
                text: qsTr("Description:")
                color: "gray"
                font.pointSize: fontsize
            }
            TextInput {
                id: dinput
                width: grid.width - tdes.width - 10
                text: listview.currentIndex >= 0 ? devicemodel.get(listview.currentIndex).description : " "
                color: "#F57F17"
                font.pointSize: fontsize
                wrapMode: Text.WordWrap

            }
            Text {
                text: qsTr("URL:")
                color: "gray"
                font.pointSize: fontsize
            }
            Text {
                id: urltext
                width: grid.width - tdes.width - 10
                text: listview.currentIndex >= 0 ? devicemodel.get(listview.currentIndex).url : " "
                color: urltext.text === "X" ? "red" : "#2979FF"
                font.pointSize: fontsize
                wrapMode: Text.WordWrap

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: { urltext.color = device.colorLighter( urltext.color, 150 ) }
                    onExited: {  urltext.color = device.getOriginalColor()  }
                    onClicked: Qt.openUrlExternally(urltext.text)
                }
            }
            Text {
                text: qsTr("PDF:")
                color: "gray"
                font.pointSize: fontsize
            }
            Text {
                id: pdfpath
                text: listview.currentIndex >= 0 ? devicemodel.get(listview.currentIndex).pdf : " "
                color: pdfpath.text === "X" ? "red" : "#E91E63"
                font.pointSize: fontsize
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: { pdfpath.color = device.colorLighter( pdfpath.color, 150 ) }
                    onExited: {  pdfpath.color = device.getOriginalColor()  }
                    onClicked:{  Qt.openUrlExternally(pdfpath.text) }

                }
            }
            Text {
                text: qsTr("Count:")
                color: "gray"
                font.pointSize: fontsize
            }
            Text {
                text: listview.currentIndex >= 0 ? devicemodel.get(listview.currentIndex).count : " "
                color: "white"
                font.pointSize: fontsize
            }
            Text {
                text: qsTr("Costs:")
                color: "gray"
                font.pointSize: fontsize
            }
            Text {
                text: listview.currentIndex >= 0 ? devicemodel.get(listview.currentIndex).price +  " €" : " €"
                color: "white"
                font.pointSize: fontsize
            }
            Text {
                text: qsTr("Image:")
                color: "gray"
                font.pointSize: fontsize
            }

            Rectangle{
                id: imagerectangle
                width: 250
                height: 150
                border.color: "white"
                color: "transparent"

                Image{
                    id: deviceimage
                    source: listview.currentIndex >= 0 ? devicemodel.get(listview.currentIndex).imagepath : ""
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit

                }
            }
            Text {
                text: "Path:"
                color: "lightgray"
                font.pointSize: fontsize

            }
            Text {
                id: imagesource
                text: listview.currentIndex >= 0 ? devicemodel.get(listview.currentIndex).imagepath : "/"
                color: "white"
                font.pointSize: fontsize
            }
        }
    }
    // !-------------------------------------------------

    // Add Device Window
    // --------------------------------------------------
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
                font.pointSize: fontsize
                color: "#1565C0"
                onEditingFinished: { acceptbutton.enabled = true }

            }
            TextArea{
                id: descinput
                width: parent.width - leftmarging * 2
                font.pointSize: fontsize
                wrapMode: Text.WordWrap
                placeholderText: "Entere description"
                color: "#1565C0"
            }
            TextArea{
                id: urlinput
                width: parent.width - leftmarging * 2
                font.pointSize: fontsize
                placeholderText: "Entere url"
                color: "#1565C0"
            }
            TextArea{
                id: pdfinput
                width: parent.width - leftmarging * 2
                font.pointSize: fontsize
                placeholderText: "Entere path of pdf"
                color: "#1565C0"

                // For droping pdf file into the area
                DropArea{
                    anchors.fill: parent
                    onDropped: (drop)=> { pdfinput.text = drop.text }
                }

            }
            Row{
                spacing: 5
                Text { text: qsTr("Count:"); color: "gray"; font.pointSize: fontsize }
                SpinBox{
                    id: countinput;
                    height: android ? 38 : 24
                    from: 1; to:9999
                    editable: true
                    font.pointSize: fontsize
                }
            }
            Row{
                spacing: 10
                Text { text: qsTr("Price:"); color: "gray"; font.pointSize: fontsize }
                SpinBox{
                    id: priceinput;
                    height: android ? 38 : 24
                    from: 0; to:9999;
                    editable: true
                    font.pointSize: fontsize
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
                Text {id: ti; text: qsTr("Image:"); color: "gray"; font.pointSize: fontsize }

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
                height: android ? 38 : 24
                width: android ? 140 : 77
                onClicked: addrect.visible = false
            }
            Button{
                id: acceptbutton
                height: android ? 38 : 24
                width: android ? 140 : 77
                text: "Accept"
                enabled: false
                onClicked: { addrect.visible = false; addDevice() }

            }
        }
    }
    // !-------------------------------------------------

    // Rectangle about this application
    // --------------------------------------------------
    Rectangle{
        id: inforect
        width: parent.width - 100
        height: parent.height -100
        anchors.centerIn: parent
        border.color: "magenta"
        color: "beige"
        visible: false

        Image {
            anchors.centerIn: parent
            width: parent.width-100
            fillMode: Image.PreserveAspectFit
            source: "/png/storage"
            opacity: 0.25
        }


        // Caption
        Text {
            id: caption
            text: Qt.application.name
            color: "blue"
            font.pointSize: 14
            font.letterSpacing: 2
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Grid{
            id: infogrid
            columns: 2
            columnSpacing: 10
            rows: 7
            rowSpacing: 5
            x: 10
            anchors.top: caption.bottom
            anchors.topMargin: 20
            Text {
                text: qsTr("App:")
                font.pointSize: 12
                color: "gray"
            }
            Text {
                text: Qt.application.name
                font.pointSize: 12
                color: "blue"
            }
            Text {
                text: qsTr("Version:")
                font.pointSize: 12
                color: "gray"
            }
            Text {
                text: Qt.application.version
                font.pointSize: 12
                color: "blue"
            }
            Text {
                text: qsTr("Developer:")
                font.pointSize: 12
                color: "gray"
            }
            Text {
                text: "Farschad Saberi"
                font.pointSize: 12
                color: "blue"
            }
            Text {
                text: qsTr("IDE:")
                font.pointSize: 12
                color: "gray"
            }
            Text {
                text: "Qt 6 C++ and QML"
                font.pointSize: 12
                color: "blue"
            }
            Text {
                text: qsTr("Licence:")
                font.pointSize: 12
                color: "gray"
            }
            Text {
                text: "GNU General Public License v3"
                font.pointSize: 12
                color: "blue"
            }

        }

        Button{
            text: "Close"
            width: android ? 120 : 75
            height: 30
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 5
            onClicked: { inforect.visible = false   }
        }
    }
    // !-------------------------------------------------


    Settings{
        id: settings
        property alias width: root.width
        property alias height: root.height
        property alias posx: root.x
        property alias posy: root.y
    }


    Component.onCompleted: {

        if(Qt.platform.os === "android")
            android = true


        // Calls the C++ function
        device.loadDeviceMap()
        updateListView()
    }

}
