import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: detailPage
    // BU SATIR ÇOK ÖNEMLİ: SubItemsPage'den gelen kategori bilgisini burada tutuyoruz
    property string categoryTitle: "" 

    // Sayfa Arka Planı
    Rectangle {
        anchors.fill: parent
        color: "#f4f7f6"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 25
        spacing: 15

        // --- ÜST BAR (Geri Butonu ve Başlık) ---
        RowLayout {
            Layout.fillWidth: true
            Button {
                text: "‹ Geri"
                onClicked: stackView.pop() // Geri dön
                background: Rectangle { 
                    implicitWidth: 70; implicitHeight: 35
                    color: "#e0e0e0"; radius: 5 
                }
            }
            Text {
                // Eğer dersin kendi başlığı varsa onu yaz (Matematik), yoksa kategoriyi yaz (Öğretmenim)
                text: appControl.currentDetail.title ? appControl.currentDetail.title : categoryTitle
                font.pixelSize: 28; font.bold: true
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                color: "#2c3e50"
            }
            Item { Layout.preferredWidth: 70 } // Ortalamak için boşluk
        }

        // --- BÖLÜM 1: ÖĞRETMEN PROFİLİ ---
        // ŞART: Bu bölüm SADECE kategori "Öğretmenim" ise görünür.
        ColumnLayout {
            visible: categoryTitle === "Öğretmenim"
            Layout.fillWidth: true
            spacing: 20
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20

            // Profil Fotoğrafı Çerçevesi
            Rectangle {
                width: 150; height: 150
                radius: 75
                color: "#ecf0f1"
                Layout.alignment: Qt.AlignHCenter
                clip: true
                border.color: "#3498db"; border.width: 4

                Image {
                    source: "../images/teacher.png" // Fotoğrafı buradan çeker
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                }
            }

            // Ses Çalma Butonu
            Button {
                text: "🔊 Öğretmenini Dinle"
                Layout.alignment: Qt.AlignHCenter
                onClicked: appControl.playTeacherVoice() // Python tarafındaki sesi çalar
                
                background: Rectangle {
                    implicitWidth: 200; implicitHeight: 50
                    color: "#2ecc71"; radius: 25
                }
                contentItem: Text {
                    text: parent.text; color: "white"; font.bold: true; 
                    horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                }
            }
        }

        // --- BÖLÜM 2: DERS DETAY KARTLARI ---
        // ŞART: Bu bölüm kategori "Öğretmenim" DEĞİLSE (yani Derslerim ise) görünür.
        ScrollView {
            visible: categoryTitle !== "Öğretmenim"
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                width: parent.width - 15
                spacing: 15

                InfoCard {
                    title: "📖 Dersin Açıklaması"
                    content: appControl.currentDetail.description || ""
                    cardColor: "#e3f2fd"
                    visible: content !== ""
                }

                InfoCard {
                    title: "📝 Ders İçeriği"
                    content: appControl.currentDetail.content || ""
                    cardColor: "#f1f8e9"
                    visible: content !== ""
                }

                InfoCard {
                    title: "⏰ Ders Saati"
                    content: appControl.currentDetail.time || ""
                    cardColor: "#fff3e0"
                    visible: content !== ""
                }

                InfoCard {
                    title: "📅 Haftalık Saat"
                    content: appControl.currentDetail.weekly_hours || ""
                    cardColor: "#f3e5f5"
                    visible: content !== ""
                }

                InfoCard {
                    title: "💡 Önemli Not"
                    content: appControl.currentDetail.note || ""
                    cardColor: "#fffde7"
                    visible: content !== ""
                }
            }
        }
    }

    // --- TEKRAR KULLANILABİLİR BİLGİ KARTI ---
    component InfoCard : Rectangle {
        property string title: ""
        property string content: ""
        property color cardColor: "white"
        
        Layout.fillWidth: true
        // İçeriğe göre yüksekliği otomatik ayarla
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
                font.pixelSize: 20; font.bold: true; color: "#34495e" 
            }
            Text { 
                text: content
                font.pixelSize: 18; width: parent.width
                wrapMode: Text.WordWrap; color: "#546e7a" 
            }
        }
    }
}