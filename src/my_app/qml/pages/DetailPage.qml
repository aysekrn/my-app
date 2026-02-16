import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: detailPage
    
    Rectangle {
        anchors.fill: parent
        color: "#f4f7f6"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 25
        spacing: 15

        // ÜST BAR
        RowLayout {
            Layout.fillWidth: true
            Button {
                text: "‹ Geri"
                onClicked: stackView.pop()
                background: Rectangle { implicitWidth: 70; implicitHeight: 35; color: "#e0e0e0"; radius: 5 }
            }
            Text {
                text: appControl.currentDetail.title
                font.pixelSize: 28; font.bold: true
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                color: "#2c3e50"
            }
            Item { Layout.preferredWidth: 70 } 
        }

        // BİLGİ KARTLARI (Kaydırılabilir Alan)
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                width: parent.width - 10 // Kaydırma çubuğu için küçük pay
                spacing: 15

                InfoCard {
                    title: "📖 Dersin Açıklaması"
                    content: appControl.currentDetail.description
                    cardColor: "#e3f2fd"
                }

                InfoCard {
                    title: "📝 Ders İçeriği"
                    content: appControl.currentDetail.content
                    cardColor: "#f1f8e9"
                }

                // HATA DÜZELTME: Yan yana duran saatleri alt alta aldık
                InfoCard {
                    title: "⏰ Ders Saati"
                    content: appControl.currentDetail.time
                    cardColor: "#fff3e0"
                }

                InfoCard {
                    title: "📅 Haftalık Saat"
                    content: appControl.currentDetail.weekly_hours
                    cardColor: "#f3e5f5"
                }

                InfoCard {
                    title: "💡 Önemli Not"
                    content: appControl.currentDetail.note
                    cardColor: "#fffde7"
                }
            }
        }
    }

    // Bilgi Kartı Bileşeni
    component InfoCard : Rectangle {
        property string title: ""
        property string content: ""
        property color cardColor: "white"
        
        Layout.fillWidth: true
        // İçerik uzunluğuna göre yüksekliği otomatik ayarlar
        implicitHeight: infoColumn.height + 40 
        color: cardColor
        radius: 12
        border.color: Qt.darker(cardColor, 1.1)

        Column {
            id: infoColumn
            anchors.centerIn: parent
            width: parent.width - 40
            spacing: 8
            Text { 
                text: title
                font.pixelSize: 20
                font.bold: true
                color: "#34495e" 
            }
            Text { 
                text: content
                font.pixelSize: 18
                width: parent.width
                wrapMode: Text.WordWrap
                color: "#546e7a" 
            }
        }
    }
}