import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: subPage
    property string categoryTitle: ""

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // ÜST BAR: Geri butonu ve tam ortalanmış başlık
        Item {
            Layout.fillWidth: true
            implicitHeight: 60

            Button {
                text: "‹ Geri"
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                onClicked: stackView.pop() // Bir önceki sayfaya döner
                
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
                // Başlığı butondan bağımsız olarak tam yatay merkeze sabitler
                anchors.horizontalCenter: parent.horizontalCenter 
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Ayırıcı ince çizgi
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
            model: appControl.currentItems // Python'dan gelen kategorik listeyi kullanır
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
                    // Eğer veri bir nesneyse (ders detayı) title'ı gösterir, değilse metni gösterir
                    text: typeof modelData === "object" ? modelData.title : modelData
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    color: "#1565c0"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // Eğer tıklanan öğe bir nesne ise (ders detayı içeriyorsa)
                        if (typeof modelData === "object") {
                            appControl.selectDetail(index) // Python tarafında detay verisini hazırlar
                            stackView.push("DetailPage.qml") // Detay sayfasına geçiş yapar
                        } else {
                            console.log("Bu öğe detay içermiyor:", modelData)
                        }
                    }
                }
            }
        }
    }
}