import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 800
    height: 800
    title: "Okul Sistemi"

    // Arka Plan
    Rectangle {
        anchors.fill: parent
        color: "#f4f7f6"
    }

    // 1. SOL ÜST İKON BÖLÜMÜ
    Image {
        id: appLogo
        source: "file:icon.png" // Ana dizindeki icon.png dosyasını okur
        width: 60
        height: 60
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 20
        fillMode: Image.PreserveAspectFit
        
        // İkonun altına küçük bir etiket (isteğe bağlı)
        Text {
            anchors.top: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            
            font.pixelSize: 12
            color: "#7f8c8d"
        }
    }

    // 2. ORTA MENÜ (Butonlar)
    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width * 0.7
        spacing: 15

        Text {
            text: "OKUL YÖNETİMİ"
            font.pixelSize: 30
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
            color: "#2c3e50"
            Layout.bottomMargin: 10
        }

        Repeater {
            model: appControl.categories // Python'daki sözlük anahtarlarını çeker
            delegate: Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 65
                
                contentItem: Text {
                    text: modelData
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "white"
                }

                background: Rectangle {
                    color: parent.down ? "#2ecc71" : "#27ae60" // Yeşil tonları okul temasına uygundur
                    radius: 12
                    border.color: "#219150"
                    border.width: 1
                }

                onClicked: {
                    appControl.selectCategory(modelData) // Seçilen kategoriyi Python'a bildirir
                    detailPopup.title = modelData
                    detailPopup.open()
                }
            }
        }
    }

    // 3. İÇERİK POPUP (Pencere)
    Popup {
        id: detailPopup
        property string title: ""
        width: parent.width * 0.85
        height: parent.height * 0.6
        anchors.centerIn: parent
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            radius: 15
            color: "white"
            border.color: "#bdc3c7"
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 25

            Text {
                text: detailPopup.title
                font.pixelSize: 24
                font.bold: true
                color: "#2c3e50"
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                Layout.fillWidth: true
                height: 2
                color: "#ecf0f1"
            }

            ListView {
                id: listView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: appControl.currentItems // Seçilen kategoriye ait listeyi gösterir
                spacing: 8
                
                delegate: Rectangle {
                    width: listView.width
                    height: 50
                    color: "#f8f9fa"
                    radius: 8
                    border.color: "#e9ecef"
                    
                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        font.pixelSize: 18
                        color: "#34495e"
                    }
                }
            }

            Button {
                text: "Geri Dön"
                Layout.alignment: Qt.AlignHCenter
                onClicked: detailPopup.close()
            }
        }
    }
}