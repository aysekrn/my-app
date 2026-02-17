import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: window
    visible: true
    width: 800
    height: 800
    title: "Okul Yönetim Sistemi"
    
    // DÜZELTME 1: Arka planı tamamen beyaz yaptık (f8f9fa yerine)
    color: "white" 

    // --- 1. SABİT ÜST BAR (SADECE LOGO) ---
    Rectangle {
        id: topBar
        width: parent.width
        height: 80 
        // DÜZELTME 2: Bar rengi de beyaz, böylece pencere ile birleşiyor
        color: "white" 
        z: 100 
        
        // DÜZELTME 3: Buradaki "Alt Çizgi" (Rectangle) kodunu SİLDİM.
        // Artık arada kesici bir çizgi yok.

        // SOL ÜSTTEKİ LOGO
        Image {
            source: "file:icon.png"
            height: 60 // Logo biraz daha belirgin olsun
            width: 60
            anchors.left: parent.left
            anchors.leftMargin: 25
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
        }
    }

    // --- 2. SAYFA YÖNETİCİSİ ---
    StackView {
        id: stackView
        // Logo barının hemen altından başlar ama renk aynı olduğu için bütün görünür
        anchors.top: topBar.bottom 
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        initialItem: mainPage
    }

    // --- 3. ANA SAYFA İÇERİĞİ ---
    Component {
        id: mainPage
        Item {
            // Ana sayfa içeriği
            ColumnLayout {
                anchors.centerIn: parent
                width: parent.width * 0.6
                spacing: 40

                // BAŞLIK
                Text {
                    text: "OKUL SİSTEMİ"
                    font.pixelSize: 42
                    font.bold: true
                    color: "#2c3e50"
                    Layout.alignment: Qt.AlignHCenter
                }

                // BUTONLAR
                Repeater {
                    model: appControl ? appControl.categories : []
                    
                    delegate: Button {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                        
                        contentItem: Text {
                            text: modelData
                            font.pixelSize: 24
                            font.bold: true
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        background: Rectangle {
                            color: parent.down ? "#2980b9" : "#3498db"
                            radius: 15
                            // Butonlara hafif gölge ekleyerek beyaz zemin üzerinde öne çıkardık
                            layer.enabled: true
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
}