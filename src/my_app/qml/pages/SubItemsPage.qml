import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: subPage
    property string categoryTitle: "" // Main.qml'den gelen başlık bilgisi

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // ÜST BAR: Geri butonu ve Başlık
        Item {
            Layout.fillWidth: true
            implicitHeight: 60

            Button {
                text: "‹ Geri"
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                onClicked: stackView.pop() // Önceki sayfaya dön
                
                background: Rectangle {
                    implicitWidth: 80
                    implicitHeight: 40
                    color: parent.down ? "#d0d0d0" : "#e0e0e0"
                    radius: 8
                }
            }

            Text {
                text: categoryTitle
                font.pixelSize: 28
                font.bold: true
                color: "#2c3e50"
                anchors.centerIn: parent // Başlığı tam ortaya hizalar
            }
        }

        // İnce Ayırıcı Çizgi
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#eeeeee"
        }

        // İÇERİK LİSTESİ
        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: appControl.currentItems
            spacing: 12
            clip: true

            delegate: Rectangle {
                width: listView.width
                height: 60
                color: "#e3f2fd"
                radius: 12
                border.color: "#bbdefb"

                Text {
                    anchors.centerIn: parent
                    // Veri nesne ise başlığını, değilse kendisini yaz
                    text: typeof modelData === "object" ? modelData.title : modelData
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    color: "#1565c0"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (typeof modelData === "object") {
                            appControl.selectDetail(index)
                            
                            // 🚀 KRİTİK DÜZELTME BURADA:
                            // Detay sayfasına geçerken "Hangi kategorideyiz?" bilgisini de gönderiyoruz.
                            // Böylece detay sayfası "Öğretmen" mi "Ders" mi olduğunu anlayabiliyor.
                            stackView.push("DetailPage.qml", { "categoryTitle": categoryTitle })
                        }
                    }
                }
            }
        }
    }
}