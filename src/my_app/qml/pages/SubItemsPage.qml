import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: subPage
    // Main.qml'den gelen başlık bilgisini (Örn: "Derslerim") tutar
    property string categoryTitle: ""

    // 1. DÜZELTME: Arka plan BEYAZ yapıldı.
    // Böylece Main.qml'deki üst bar ile kusursuz birleşir.
    Rectangle {
        anchors.fill: parent
        color: "white"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // --- ÜST BAR (Geri Butonu ve Başlık) ---
        Item {
            Layout.fillWidth: true
            implicitHeight: 60

            Button {
                text: "‹ Geri"
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                onClicked: stackView.pop() // Bir önceki sayfaya dön
                
                background: Rectangle {
                    implicitWidth: 80; implicitHeight: 40
                    color: parent.down ? "#e0e0e0" : "#f5f5f5" // Beyaz fonda belli olması için çok açık gri
                    radius: 8
                    border.color: "#e0e0e0" // Hafif çerçeve
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

        // İnce Ayırıcı Çizgi (Çok silik gri, estetik durur)
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#f0f0f0"
        }

        // --- LİSTE (Dersler veya İsimler) ---
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
                // Beyaz zemin üzerinde kaybolmaması için çok açık mavi tonu
                color: "#f8fbff" 
                radius: 12
                border.color: "#e3f2fd" // İnce mavi çerçeve

                Text {
                    anchors.centerIn: parent
                    // Veri nesne ise başlığını (Title), değilse kendisini yaz
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
                            
                            // 🚀 KRİTİK NOKTA:
                            // Detay sayfasına geçerken "Hangi kategorideyiz?" bilgisini de gönderiyoruz.
                            // Bu sayede detay sayfası "Öğretmen" mi "Ders" mi olduğunu anlıyor.
                            stackView.push("DetailPage.qml", { "categoryTitle": categoryTitle })
                        }
                    }
                }
            }
        }
    }
}