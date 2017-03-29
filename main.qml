import QtQuick 2.5
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtMultimedia 5.0
import QtQuick.Window 2.0
import Qt.labs.settings 1.0
import QtQuick.Dialogs 1.2
import "javascript/main.js" as MainJS

ApplicationWindow {
    id: mainwindow
    title: qsTr("GoEcho 1.0")
    visible: true
    minimumHeight: 200
    minimumWidth: 300
    height: 250
    width: 350
    flags: Qt.Window | Qt.WindowTitleHint | Qt.WindowSystemMenuHint
           | Qt.CustomizeWindowHint | Qt.WindowCloseButtonHint

    property int timer_interval: 20000
    property int vk_count: 10
    property int report_max_count: 15
    property double sound_volume: 0.7
    property int domain_counter: 0
    property var vk_domains: [{"title":qsTr("Первый оперативный"), "name":"covnovorossia", "lastdate":0,
            "regular":/оперативная\s*\d{2}.\d{2}.\d{4}\s*,\s*\d{2}:\d{2}/ig},
        {"title":qsTr("GO Группа"), "name":"opoveshenie", "lastdate":0,
            "regular":/#важно/ig}]

    property int dpi: Screen.pixelDensity * 25.4

    function dp(x){
        if(dpi < 120) {
            return x;
        } else {
            return x*(dpi/160);
        }
    }

    Settings {
        property alias cfg_x: mainwindow.x
        property alias cfg_y: mainwindow.y
        property alias cfg_width: mainwindow.width
        property alias cfg_height: mainwindow.height

        property alias cfg_timer_interval: mainwindow.timer_interval
        property alias cfg_vk_count: mainwindow.vk_count
        property alias cfg_report_max_count: mainwindow.report_max_count
        property alias cfg_sound_volume: mainwindow.sound_volume
    }

    About {
        id: aboutdlg
    }

    Help {
        id: helpdlg
    }

    Config {
        id: configdlg
    }

    Connections {
        target: systemTray
        onSignalShow: {
            mainwindow.show();
        }

        onSignalQuit: {
            mainwindow.show();
            close()
        }

        onSignalConfig: {
            mainwindow.show();
            configdlg.open()
        }

        onSignalHelp: {
            mainwindow.show();
            helpdlg.open()
        }


        onSignalAbout: {
            mainwindow.show();
            aboutdlg.open()
        }

        onSignalIconActivated: {
            mainwindow.show()
        }
    }

    ListModel {
        id: reportsModel
    }

    header: ToolBar {
        id: toolBarMenu
        height: mainwindow.dp(32) + mainwindow.dp(10)
        width: parent.width
        background: Rectangle {
            color: "#eeeeee"
        }
        Row {
            anchors.fill: parent
            anchors.leftMargin: mainwindow.dp(10)
            anchors.rightMargin: mainwindow.dp(10)
            spacing: 0
            ToolButton {
                height: parent.height
                width: parent.height
                Image {
                    anchors.fill: parent
                    anchors.margins: (parent.width / 100) * 10
                    source: "images/minimize.svg"
                    sourceSize.width: parent.width
                    sourceSize.height: parent.height
                }
                onClicked: {
                    if(Qt.platform.os === "android")
                    {
                        goeApp.appminimized()
                    }
                    else if(Qt.platform.os === "windows") {
                        mainwindow.hide()
                    }
                }
            }
            ToolButton {
                height: parent.height
                width: parent.height
                Image {
                    anchors.fill: parent
                    anchors.margins: (parent.width / 100) * 10
                    source: "images/about.svg"
                    sourceSize.width: parent.width
                    sourceSize.height: parent.height
                }
                onClicked: {
                    aboutdlg.open()
                }
            }
            Column {
                width: parent.width - parent.height * 4
                height: parent.height
                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: parent.height / 2 - height / 2
                    text: qsTr("- ОПОВЕЩЕНИЕ -")
                }
            }
            ToolButton {
                height: parent.height
                width: parent.height
                Image {
                    anchors.fill: parent
                    anchors.margins: (parent.width / 100) * 10
                    source: "images/help.svg"
                    sourceSize.width: parent.width
                    sourceSize.height: parent.height
                }
                onClicked: {
                    helpdlg.open()
                }
            }
            ToolButton {
                height: parent.height
                width: parent.height
                Image {
                    anchors.fill: parent
                    anchors.margins: (parent.width / 100) * 10
                    source: "images/config.svg"
                    sourceSize.width: parent.width
                    sourceSize.height: parent.height
                }
                onClicked: {
                    configdlg.open()
                }
            }
        }
    }

    footer: Rectangle {
        height: copyright.height + 10
        color: "#eeeeee"
        Label {
            id: copyright
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("© 2017, GoEcho.")
        }
    }


    Component {
        id: reportsDelegate

        Rectangle {
            width: parent.width
            height: contentText.height + 20
            anchors.horizontalCenter: parent.horizontalCenter
            color: rcolor
            border {
                color: '#ffffff'
                width: 2
            }
            radius: 10

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(Qt.platform.os === "android")
                    {
                        goeApp.notifremove()
                    }
                    reportsModel.setProperty(index, "rcolor", "#000000")
                }
            }

            Row {
                anchors.margins: 10
                anchors.fill: parent
                spacing: 10

                Text {
                    id: contentText
                    width: parent.width - parent.spacing
                    anchors.verticalCenter: parent.verticalCenter
                    elide: Text.ElideRight
                    wrapMode: Text.WordWrap
                    text: rtext
                    color: "#ffffff"
                }
            }
        }
    }

    ListView {
        id: reportsView
        anchors.fill: parent
        model: reportsModel
        anchors.margins: 10
        clip: true

        Label {
            id: noReportText
            anchors.fill: parent
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
            elide: Label.ElideRight
            wrapMode: Label.WordWrap
            text: "<b>" + qsTr("Оповещения не загружены.") + "<br>" + qsTr("Подождите...") + "</b>" +
                  "<br><br>" + qsTr("Возможные причины:") +
                  "<br><br>" + qsTr("- Последние оповещения отсутствуют -") +
                  "<br>" + qsTr("- Нет соединения с Интернет -") +
                  "<br>" + qsTr("- Сайт не доступен -")
            color: "#000000"
        }
        onCountChanged: {
            MainJS.sortReport(reportsModel)
            MainJS.removeReport(reportsModel, mainwindow.report_max_count)
        }
        delegate: reportsDelegate
    }

    WorkerScript {
        id: goEchoThread
        source: "javascript/main.js"
        onMessage: {
            if(messageObject.error && messageObject.error === 200)
            {
                if(goeTimer.interval != 250)
                {
                    goeTimer.interval = 250
                }
            }
            else if(messageObject.repeat && messageObject.repeat === true)
            {
                if(goeTimer.interval != mainwindow.timer_interval)
                {
                    goeTimer.interval = mainwindow.timer_interval
                }
            }
            else
            {
                var isnext = true
                for(var i = 0; i < mainwindow.vk_domains.length; i++)
                {
                    if(mainwindow.vk_domains[i].lastdate === 0)
                    {
                        isnext = false
                    }
                    if(messageObject.reports)
                    {
                        if(mainwindow.vk_domains[i].name === messageObject.reports[0].domain)
                        {
                            mainwindow.vk_domains[i].lastdate = messageObject.reports[0].unixtime
                        }
                    }
                    if(messageObject.lastpost)
                    {
                        if(mainwindow.vk_domains[i].name === messageObject.lastpost.domain)
                        {
                            mainwindow.vk_domains[i].lastdate = messageObject.lastpost.lastdate
                        }
                    }
                }
                if(messageObject.reports)
                {
                    noReportText.visible = false
                    reportsModel.insert(0, messageObject.reports)
                    if(isnext)
                    {
                        playSound.volume = mainwindow.sound_volume
                        soundTimer.start()
                    }
                }
                if(goeTimer.interval != mainwindow.timer_interval)
                {
                    goeTimer.interval = mainwindow.timer_interval
                }
            }
            mainwindow.domain_counter++
            if(mainwindow.domain_counter === mainwindow.vk_domains.length)
            {
                mainwindow.domain_counter = 0
                if(goeTimer.running === false)
                {
                    goeTimer.start()
                }
            }
        }
    }
    Component.onCompleted: {
        for(var i = 0; i < mainwindow.vk_domains.length; i++)
        {
            goEchoThread.sendMessage({'unixtime': mainwindow.vk_domains[i].lastdate, 'domain': mainwindow.vk_domains[i], 'count': mainwindow.vk_count, 'isnext': false})
        }
    }

    Timer {
        id: soundTimer
        interval: 250
        onTriggered: {
            if(Qt.platform.os === "android")
            {
                goeApp.notifset(qsTr("GoEcho"), qsTr("Получено новое оповещение!"))
            }
            else if(Qt.platform.os === "windows")
            {
                systemTray.showMessage(qsTr("GoEcho"), qsTr("Получено новое оповещение!"))
            }
            reportsView.positionViewAtIndex(0, ListView.Beginning)
            playSound.play()
        }
    }

    Timer {
        id: goeTimer
        onTriggered: {
            var isnext = true
            var i
            for(i = 0; i < mainwindow.vk_domains.length; i++)
            {
                if(mainwindow.vk_domains[i].lastdate === 0)
                {
                    isnext = false
                    break
                }
            }
            for(i = 0; i < mainwindow.vk_domains.length; i++)
            {
                goEchoThread.sendMessage({'unixtime': mainwindow.vk_domains[i].lastdate, 'domain': mainwindow.vk_domains[i], 'count': mainwindow.vk_count, 'isnext': isnext})
            }
        }
    }

    SoundEffect {
        id: playSound
        volume: mainwindow.sound_volume
        source: "sounds/beep.wav"
    }

    onClosing: {
        if(Qt.platform.os === "windows")
        {
            close.accepted = false
            closedlg.open()
        }
    }

    Dialog {
        id: closedlg
        title: qsTr("Выход")
        contentItem: Rectangle {
            implicitWidth: Qt.platform.os === "android" ? Screen.width-Screen.width*0.1 : 300
            implicitHeight: textLabel.height + dividerHorizontal.height + rowButton.height + 30
            Rectangle {
                id: recText
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: dividerHorizontal.top
                anchors.margins: 15

                Label {
                    id: textLabel
                    width: parent.width
                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter
                    wrapMode: Label.WordWrap
                    elide: Label.ElideRight
                    text: qsTr("Вы действительно хотите выйти?")
                }
            }

            Rectangle {
                id: dividerHorizontal
                color: "#d7d7d7"
                height: 2
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: rowButton.top
            }
            Row {
                id: rowButton
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right

                Button {
                    id: dialogButtonCancel
                    text: qsTr("Отмена")
                    width: parent.width/2 - dividerVertical.width/2
                    onClicked: {
                        closedlg.close()
                    }
                }

                Rectangle {
                    id: dividerVertical
                    width: 2
                    anchors.top: dialogButtonCancel.top
                    anchors.bottom: dialogButtonCancel.bottom
                    color: "#d7d7d7"
                }

                Button {
                    id: dialogButtonOk
                    text: qsTr("Да")
                    width: parent.width/2 - dividerVertical.width/2
                    onClicked: {
                        systemTray.hideIconTray()
                        Qt.quit()
                    }
                }
            }
            onHeightChanged: {
                if(recText.height > 0)
                {
                    textLabel.height = recText.height
                }
            }
        }
    }
}
