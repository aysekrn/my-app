import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: window
    visible: true
    width: 800
    height: 800
    title: "Okul Yönetim Sistemi"

    // Sadeleştirilmiş StackView: Çakışmaları önlemek için sadece anchors.fill kullanıldı
    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: mainPage
    }

    // --- ANA SAYFA BİLEŞENİ ---
    Component {
        id: mainPage
        Item {
            anchors.fill: parent

            Rectangle {
                anchors.fill: parent
                color: "#f8f9fa"
            }

            // Sol Üst İkon
            Image {
                source: "file:icon.png"
                width: 60
                height: 60
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 20
                fillMode: Image.PreserveAspectFit
            }

            ColumnLayout {
                anchors.centerIn: parent
                width: parent.width * 0.7
                spacing: 20

                Text {
                    text: "OKUL SİSTEMİ"
                    font.pixelSize: 32
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                    color: "#2c3e50"
                }

                Repeater {
                    // Güvenlik Kontrolü: appControl yüklenmeden veri okunmasını engeller
                    model: appControl ? appControl.categories : [] 
                    
                    delegate: Button {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 70
                        
                        contentItem: Text {
                            text: modelData
                            font.pixelSize: 22
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "white"
                        }

                        background: Rectangle {
                            color: parent.down ? "#2980b9" : "#3498db"
                            radius: 12
                        }

                        onClicked: {
                            appControl.selectCategory(modelData)
                            stackView.push("pages/SubItemsPage.qml", { "categoryTitle": modelData })
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: appControl
        function onCurrent_list_changed() {
            console.log("Navigasyon hazır, liste güncellendi.")
        }
    }
}