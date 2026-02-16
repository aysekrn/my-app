import json
from importlib.resources import files
from PyQt5.QtCore import QObject, pyqtSignal, pyqtProperty, pyqtSlot, QUrl
from PyQt5.QtMultimedia import QMediaPlayer, QMediaContent

# JSON ve Ses dosyası yolları
LESSONS_PATH = files("my_app").joinpath("data/lessons.json")
# Ses dosyasının tam yolunu buraya tanımlıyoruz
VOICE_PATH = files("my_app").joinpath("data/welcome.mp3")

class AppControl(QObject):
    # Veri değişimlerini QML'e bildiren sinyaller
    categories_changed = pyqtSignal()
    current_list_changed = pyqtSignal()
    detail_changed = pyqtSignal()

    def __init__(self):
        super().__init__()
        self._raw_data = {}          # Tüm okul verisi
        self._current_category = ""   # Seçilen ana kategori
        self._current_detail = {}     # Seçilen dersin detayları
        
        # Ses oynatıcıyı başlatıyoruz
        self.player = QMediaPlayer()
        self.load_data()

    def load_data(self):
        """JSON dosyasını okur ve school_data kısmını belleğe alır."""
        try:
            with open(LESSONS_PATH, "r", encoding="utf-8") as f:
                full_data = json.load(f)
                self._raw_data = full_data.get("school_data", {})
            self.categories_changed.emit()
        except Exception as e:
            print(f"Veri yükleme hatası: {e}")

    # --- QML PROPERTIES (Veri Okuma) ---

    @pyqtProperty(list, notify=categories_changed)
    def categories(self):
        return list(self._raw_data.keys())

    @pyqtProperty(list, notify=current_list_changed)
    def currentItems(self):
        return self._raw_data.get(self._current_category, [])

    @pyqtProperty("QVariantMap", notify=detail_changed)
    def currentDetail(self):
        return self._current_detail

    # --- QML SLOTS (İşlem Yapma) ---

    @pyqtSlot(str)
    def selectCategory(self, category_name):
        self._current_category = category_name
        self.current_list_changed.emit()

    @pyqtSlot(int)
    def selectDetail(self, index):
        items = self._raw_data.get(self._current_category, [])
        if index < len(items) and isinstance(items[index], dict):
            self._current_detail = items[index]
            self.detail_changed.emit()

    @pyqtSlot()
    def playTeacherVoice(self):
        """Öğretmen sayfasındaki sabit MP3 dosyasını çalar."""
        try:
            # VOICE_PATH'i QUrl formatına çevirip çalıyoruz
            url = QUrl.fromLocalFile(str(VOICE_PATH))
            self.player.setMedia(QMediaContent(url))
            self.player.play()
            print("Ses çalınıyor...")
        except Exception as e:
            print(f"Ses çalma hatası: {e}")