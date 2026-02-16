import sys
import signal
from PyQt5.QtGui import QGuiApplication, QCursor
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import Qt

from importlib.resources import files

from my_app.backend.app_control import AppControl

# signal.signal(signal.SIGINT, signal.SIG_DFL)


def main():
    app = QGuiApplication(sys.argv)
    # app.setOverrideCursor(QCursor(Qt.BlankCursor))
    engine = QQmlApplicationEngine()

    assets_path = files("my_app").joinpath("assets")

    engine.rootContext().setContextProperty(
        "ASSETS_PATH",
        assets_path.as_uri()
    )

    app_control = AppControl()
    engine.rootContext().setContextProperty("appControl", app_control)

    qml_dir = files("my_app").joinpath("qml")
    print(qml_dir)
    engine.load(str(qml_dir / "Main.qml"))

    if not engine.rootObjects():
        sys.exit(-1)
    window = engine.rootObjects()[0]
    # window.showFullScreen()
    sys.exit(app.exec())

if __name__ == "__main__":
    main()