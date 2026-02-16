from importlib.resources import files
import json
from PyQt5.QtCore import QObject, pyqtSignal, pyqtProperty, pyqtSlot

# JSON dosyasının yolu
LESSONS_PATH = files("my_app").joinpath("data/lessons.json")

class AppControl(QObject):
    # QML tarafını uyarmak için kullanılan sinyaller
    categories_changed = pyqtSignal()
    current_list_changed = pyqtSignal()

    def __init__(self):
        super().__init__()
        self._raw_data = {}         # Tüm JSON verisi burada tutulur
        self._current_category = ""  # Seçili olan kategori (Derslerim vb.)
        self.load_data()

    def load_data(self):
        """JSON dosyasını okur ve school_data kısmını yükler."""
        try:
            # Dosyayı UTF-8 formatında açıyoruz
            with open(LESSONS_PATH, "r", encoding="utf-8") as f:
                full_data = json.load(f)
                # Sadece senin istediğin okul kategorilerini alıyoruz
                self._raw_data = full_data.get("school_data", {})
            
            self.categories_changed.emit()
            print("Veri başarıyla yüklendi.")
        except Exception as e:
            print(f"JSON okuma hatası: {e}")

    # --- QML TARAFINDAN ERİŞİLEBİLEN ÖZELLİKLER (PROPERTIES) ---

    @pyqtProperty(list, notify=categories_changed)
    def categories(self):
        """Sol menü veya ana butonlar için kategori isimlerini döndürür."""
        # ["Derslerim", "Ders Programı", "Öğretmenim", "Ödevler"]
        return list(self._raw_data.keys())

    @pyqtProperty(list, notify=current_list_changed)
    def currentItems(self):
        """Seçilen kategoriye ait alt listeyi döndürür."""
        # Örneğin "Derslerim" seçiliyse: ["Matematik", "Türkçe" ...]
        return self._raw_data.get(self._current_category, [])

    # --- QML TARAFINDAN ÇAĞRILAN FONKSİYONLAR (SLOTS) ---

    @pyqtSlot(str)
    def selectCategory(self, category_name):
        """Kullanıcı bir butona bastığında hangi listenin açılacağını belirler."""
        self._current_category = category_name
        # Sağ taraftaki veya Popup içindeki listenin yenilenmesini sağlar
        self.current_list_changed.emit()
        print(f"Seçilen kategori: {category_name}")