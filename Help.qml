import QtQuick 2.5
import QtQuick.Controls 2.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0

Dialog {
    id: helpdlg
    title: qsTr("Справка")
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
                verticalAlignment: Label.AlignVCenter
                wrapMode: Label.WordWrap
                elide: Label.ElideRight
                text: "<b><u>" + qsTr("Справочная информация") + "</u></b><br><ul>" +
                      "<li>" + qsTr("После запуска приложения будет загружен список последних оповещений.") + "</li>" +
                      "<li>" + qsTr("Приложение переходит в режим ожидания оповещений, окно можно свернуть*.") + "</li>" +
                      "<li>" + qsTr("Новые оповещения сопровождаются звуковым сигналом и информационным сообщением.") + "</li></ul><br>" +
                      qsTr("* Активность сохраняется до момента закрытия приложения.")
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
                    helpdlg.close()
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
