import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: detailPage
    property string categoryTitle: "" 

    // Arka plan BEYAZ
    Rectangle {
        anchors.fill: parent
        color: "white" 
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 25
        spacing: 15

        // --- ÜST BAR (Geri Butonu ve Başlık) ---
        RowLayout {
            Layout.fillWidth: true
            Layout.maximumHeight: 50 // Yüksekliği sınırladık ki aşağıyı itmesin
            
            Button {
                text: "‹ Geri"
                onClicked: stackView.pop()
                background: Rectangle { 
                    implicitWidth: 70; implicitHeight: 35
                    color: "#f5f5f5"; radius: 5
                    border.color: "#e0e0e0"
                }
            }

            Text {
                text: appControl.currentDetail.title ? appControl.currentDetail.title : categoryTitle
                font.pixelSize: 28; font.bold: true
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                color: "#2c3e50"
            }
            Item { Layout.preferredWidth: 70 } 
        }

        // --- BÖLÜM 1: ÖĞRETMEN PROFİLİ ---
        ColumnLayout {
            visible: categoryTitle === "Öğretmenim"
            Layout.fillWidth: true
            Layout.fillHeight: true // Tüm dikey alanı kullanmasına izin veriyoruz
            spacing: 25 // Elemanlar arası boşluk
            
            // Başlıktan biraz aşağıda dursun
            Item { Layout.preferredHeight: 20 } 

            // Profil Fotoğrafı
            Rectangle {
                width: 160; height: 160
                radius: 80
                color: "white"
                Layout.alignment: Qt.AlignHCenter // Yatayda ortala
                clip: true
                border.color: "#3498db"; border.width: 4

                Image {
                    source: "../images/teacher.png"
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                }
            }

            // İsim (Opsiyonel: Eğer JSON'da title varsa yazar, yoksa boş geçer)
            Text {
                text: appControl.currentDetail.title || "" 
                font.pixelSize: 22; font.bold: true; color: "#34495e"
                Layout.alignment: Qt.AlignHCenter
                visible: text !== ""
            }

            // Ses Çalma Butonu
            Button {
                text: "🔊 Öğretmenini Dinle"
                Layout.alignment: Qt.AlignHCenter
                onClicked: appControl.playTeacherVoice()
                
                background: Rectangle {
                    implicitWidth: 220; implicitHeight: 55
                    color: "#2ecc71"; radius: 28
                    // Butona biraz gölge ekleyelim şık dursun
                    layer.enabled: true
                }
                contentItem: Text {
                    text: parent.text; color: "white"; font.bold: true; 
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                }
            }

            // 🚀 SİHİRLİ DOKUNUŞ: SPACER (İTİCİ GÜÇ)
            // Bu görünmez eleman, kalan tüm boşluğu doldurarak
            // üstteki fotoğrafı ve butonu YUKARI (başlığa doğru) iter.
            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
        }

        // --- BÖLÜM 2: DERS DETAY KARTLARI ---
        ScrollView {
            visible: categoryTitle !== "Öğretmenim"
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                width: parent.width - 15
                spacing: 15

                InfoCard { title: "📖 Dersin Açıklaması"; content: appControl.currentDetail.description || ""; cardColor: "#e3f2fd"; visible: content !== "" }
                InfoCard { title: "📝 Ders İçeriği"; content: appControl.currentDetail.content || ""; cardColor: "#f1f8e9"; visible: content !== "" }
                InfoCard { title: "⏰ Ders Saati"; content: appControl.currentDetail.time || ""; cardColor: "#fff3e0"; visible: content !== "" }
                InfoCard { title: "📅 Haftalık Saat"; content: appControl.currentDetail.weekly_hours || ""; cardColor: "#f3e5f5"; visible: content !== "" }
                InfoCard { title: "💡 Önemli Not"; content: appControl.currentDetail.note || ""; cardColor: "#fffde7"; visible: content !== "" }
            }
        }
    }

    component InfoCard : Rectangle {
        property string title: ""; property string content: ""; property color cardColor: "white"
        Layout.fillWidth: true; implicitHeight: infoColumn.height + 40 
        color: cardColor; radius: 12; border.color: Qt.darker(cardColor, 1.1)
        Column {
            id: infoColumn; anchors.centerIn: parent; width: parent.width - 40; spacing: 8
            Text { text: title; font.pixelSize: 20; font.bold: true; color: "#34495e" }
            Text { text: content; font.pixelSize: 18; width: parent.width; wrapMode: Text.WordWrap; color: "#546e7a" }
        }
    }
}