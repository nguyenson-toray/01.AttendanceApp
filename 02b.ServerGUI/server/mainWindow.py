# This Python file uses the following encoding: utf-8
import sys

from PySide6.QtWidgets import QApplication, QMainWindow

# Important:
# You need to run the following command to generate the ui_form.py file
#     pyside6-uic form.ui -o ui_form.py, or
#     pyside2-uic form.ui -o ui_form.py
from ui_mainWindow import Ui_MainWindow


class MainWindow(QMainWindow):

    def __init__(self, parent=None):
        super().__init__(parent)
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)
        self.initUI()
    def initUI(self):
        ipMachines = self.ui.ipMachines
        buttonGetlogs = self.ui.buttonGetlogs
        buttonGetlogs.clicked.connect(self.buttonGetlogsClick)
    def buttonGetlogsClick(self):
        print("Button clicked!!!!!!")
        print (self.sender().text())
        print (self.parent.ipMachines.text())
if __name__ == "__main__":
    app = QApplication(sys.argv)
    widget = MainWindow()
    widget.show()
    sys.exit(app.exec())

