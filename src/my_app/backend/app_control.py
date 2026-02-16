from importlib.resources import files
import json
from PyQt5.QtCore import QObject, pyqtSignal, pyqtProperty, pyqtSlot

# JSON dosyasının yolu
LESSONS_PATH = files("my_app").joinpath("data/lessons.json")

class AppControl(QObject):
    # Veri değişimlerini QML'e bildiren sinyaller
    categories_changed = pyqtSignal()
    current_list_changed = pyqtSignal()
    detail_changed = pyqtSignal()

    def __init__(self):
        super().__init__()
        self._raw_data = {}          # Tüm okul verisi
        self._current_category = ""   # Seçilen ana kategori (Örn: Derslerim)
        self._current_detail = {}     # Seçilen dersin detayları (Örn: Matematik saati)
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
        """Ana menüdeki buton isimlerini (Key'leri) döndürür."""
        return list(self._raw_data.keys())

    @pyqtProperty(list, notify=current_list_changed)
    def currentItems(self):
        """Seçilen kategorinin içeriğini döndürür."""
        return self._raw_data.get(self._current_category, [])

    @pyqtProperty("QVariantMap", notify=detail_changed)
    def currentDetail(self):
        """Seçilen dersin detay bilgilerini (saat, not) döndürür."""
        return self._current_detail

    # --- QML SLOTS (İşlem Yapma) ---

    @pyqtSlot(str)
    def selectCategory(self, category_name):
        """Kullanıcı ana menüden bir kategori seçtiğinde çalışır."""
        self._current_category = category_name
        self.current_list_changed.emit()

    @pyqtSlot(int)
    def selectDetail(self, index):
        """Listedeki spesifik bir ders tıklandığında detaylarını hazırlar."""
        items = self._raw_data.get(self._current_category, [])
        # Eğer öğe bir sözlükse (detay içeriyorsa) seç
        if index < len(items) and isinstance(items[index], dict):
            self._current_detail = items[index]
            self.detail_changed.emit()
            print(f"Detay seçildi: {self._current_detail.get('title')}")