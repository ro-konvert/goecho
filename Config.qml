import QtQuick 2.5
import QtQuick.Controls 2.1
import QtQuick.Dialogs 1.2
import QtMultimedia 5.0
import QtQuick.Window 2.0

Dialog {
    id: configdlg
    title: qsTr("Настройки")

    property var arrayTInterval: [5, 10, 20, 30, 60]
    property var arrayVKCount: [3, 5, 10, 15, 20]
    property var arrayRepCount: [10, 15, 20, 25, 30]

    contentItem: Rectangle {
        implicitWidth: Qt.platform.os === "android" ? Screen.width-Screen.width*0.1 : 300
        implicitHeight: recChild.height + dividerHorizontal.height + rowButton.height + 30
        Rectangle {
            id: recMain
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: dividerHorizontal.top
            anchors.margins: 15

            Rectangle {
                id: recChild
                width: parent.width
                height: childrenRect.height
                y: (recMain.height - childrenRect.height) / 2

                Label {
                    id: cfgLabelTInterval
                    anchors.margins: 10
                    wrapMode: Label.WordWrap
                    elide: Label.ElideRight
                    text: qsTr("Интервал проверки, сек.")
                }
                ComboBox {
                    id: cfgComboBoxTInterval
                    anchors.top: cfgLabelTInterval.bottom
                    anchors.margins: 10
                    width: recMain.width
                    currentIndex: arrayTInterval.indexOf(mainwindow.timer_interval/1000)
                    model: arrayTInterval
                    onCurrentIndexChanged: mainwindow.timer_interval = model[currentIndex] * 1000
                }

                Label {
                    id: cfgLabelVKCount
                    anchors.top: cfgComboBoxTInterval.bottom
                    anchors.margins: 10
                    wrapMode: Label.WordWrap
                    elide: Label.ElideRight
                    text: qsTr("Проверять последние, шт.")
                }
                ComboBox {
                    id: cfgComboBoxVKCount
                    anchors.top: cfgLabelVKCount.bottom
                    anchors.margins: 10
                    width: recMain.width
                    currentIndex: arrayVKCount.indexOf(mainwindow.vk_count)
                    model: arrayVKCount
                    onCurrentIndexChanged: mainwindow.vk_count = model[currentIndex]
                }

                Label {
                    id: cfgLabelRepCount
                    anchors.top: cfgComboBoxVKCount.bottom
                    anchors.margins: 10
                    wrapMode: Label.WordWrap
                    elide: Label.ElideRight
                    text: qsTr("Список оповещений, шт.")
                }
                ComboBox {
                    id: cfgComboBoxRepCount
                    anchors.top: cfgLabelRepCount.bottom
                    anchors.margins: 10
                    width: recMain.width
                    currentIndex: arrayRepCount.indexOf(mainwindow.report_max_count)
                    model: arrayRepCount
                    onCurrentIndexChanged: mainwindow.report_max_count = model[currentIndex]
                }

                Label {
                    id: cfgLabelVolume
                    anchors.top: cfgComboBoxRepCount.bottom
                    anchors.margins: 10
                    wrapMode: Label.WordWrap
                    elide: Label.ElideRight
                    text: qsTr("Громкость сигнала")
                }
                Slider {
                    id: cfgSliderVolume
                    anchors.top: cfgLabelVolume.bottom
                    anchors.margins: 10
                    width: recMain.width
                    value: mainwindow.sound_volume
                    onValueChanged: {
                        mainwindow.sound_volume = value
                        if(configdlg.visible === true) {
                            playVolume.play()
                        }
                    }
                }
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
                text: qsTr("Закрыть окно")
                width: parent.width
                onClicked: {
                    configdlg.close()
                }
            }
        }
    }
    SoundEffect {
        id: playVolume
        volume: mainwindow.sound_volume
        source: "sounds/volume.wav"
    }
}
