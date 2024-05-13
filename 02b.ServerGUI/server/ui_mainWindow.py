# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'mainWindow.ui'
##
## Created by: Qt User Interface Compiler version 6.7.0
##
## WARNING! All changes made in this file will be lost when recompiling UI file!
################################################################################

from PySide6.QtCore import (QCoreApplication, QDate, QDateTime, QLocale,
    QMetaObject, QObject, QPoint, QRect,
    QSize, QTime, QUrl, Qt)
from PySide6.QtGui import (QBrush, QColor, QConicalGradient, QCursor,
    QFont, QFontDatabase, QGradient, QIcon,
    QImage, QKeySequence, QLinearGradient, QPainter,
    QPalette, QPixmap, QRadialGradient, QTransform)
from PySide6.QtWidgets import (QApplication, QComboBox, QFrame, QGridLayout,
    QLabel, QLineEdit, QMainWindow, QMenuBar,
    QPushButton, QSizePolicy, QStatusBar, QToolBox,
    QWidget)

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        if not MainWindow.objectName():
            MainWindow.setObjectName(u"MainWindow")
        MainWindow.resize(850, 665)
        sizePolicy = QSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Expanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(MainWindow.sizePolicy().hasHeightForWidth())
        MainWindow.setSizePolicy(sizePolicy)
        self.centralwidget = QWidget(MainWindow)
        self.centralwidget.setObjectName(u"centralwidget")
        self.centralwidget.setEnabled(True)
        sizePolicy.setHeightForWidth(self.centralwidget.sizePolicy().hasHeightForWidth())
        self.centralwidget.setSizePolicy(sizePolicy)
        self.gridLayout = QGridLayout(self.centralwidget)
        self.gridLayout.setObjectName(u"gridLayout")
        self.toolBox = QToolBox(self.centralwidget)
        self.toolBox.setObjectName(u"toolBox")
        sizePolicy.setHeightForWidth(self.toolBox.sizePolicy().hasHeightForWidth())
        self.toolBox.setSizePolicy(sizePolicy)
        self.toolBox.setMinimumSize(QSize(800, 600))
        self.toolBox.setAutoFillBackground(True)
        self.pageAtt = QWidget()
        self.pageAtt.setObjectName(u"pageAtt")
        self.pageAtt.setGeometry(QRect(0, 0, 828, 507))
        self.gridLayout_2 = QGridLayout(self.pageAtt)
        self.gridLayout_2.setObjectName(u"gridLayout_2")
        self.frame = QFrame(self.pageAtt)
        self.frame.setObjectName(u"frame")
        self.frame.setFrameShape(QFrame.StyledPanel)
        self.frame.setFrameShadow(QFrame.Raised)
        self.gridLayout_3 = QGridLayout(self.frame)
        self.gridLayout_3.setObjectName(u"gridLayout_3")
        self.buttonGetlogs = QPushButton(self.frame)
        self.buttonGetlogs.setObjectName(u"buttonGetlogs")
        self.buttonGetlogs.setCheckable(False)

        self.gridLayout_3.addWidget(self.buttonGetlogs, 0, 1, 1, 1)

        self.ipMachines = QLineEdit(self.frame)
        self.ipMachines.setObjectName(u"ipMachines")

        self.gridLayout_3.addWidget(self.ipMachines, 0, 3, 1, 1)

        self.label_2 = QLabel(self.frame)
        self.label_2.setObjectName(u"label_2")
        sizePolicy.setHeightForWidth(self.label_2.sizePolicy().hasHeightForWidth())
        self.label_2.setSizePolicy(sizePolicy)

        self.gridLayout_3.addWidget(self.label_2, 6, 0, 1, 4)

        self.label_4 = QLabel(self.frame)
        self.label_4.setObjectName(u"label_4")

        self.gridLayout_3.addWidget(self.label_4, 1, 0, 1, 1)

        self.comboBoxOneOrRealtime = QComboBox(self.frame)
        self.comboBoxOneOrRealtime.addItem("")
        self.comboBoxOneOrRealtime.addItem("")
        self.comboBoxOneOrRealtime.setObjectName(u"comboBoxOneOrRealtime")

        self.gridLayout_3.addWidget(self.comboBoxOneOrRealtime, 0, 0, 1, 1)

        self.label = QLabel(self.frame)
        self.label.setObjectName(u"label")

        self.gridLayout_3.addWidget(self.label, 0, 2, 1, 1)

        self.label_5 = QLabel(self.frame)
        self.label_5.setObjectName(u"label_5")

        self.gridLayout_3.addWidget(self.label_5, 3, 0, 1, 1)

        self.label_3 = QLabel(self.frame)
        self.label_3.setObjectName(u"label_3")
        sizePolicy1 = QSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Fixed)
        sizePolicy1.setHorizontalStretch(0)
        sizePolicy1.setVerticalStretch(0)
        sizePolicy1.setHeightForWidth(self.label_3.sizePolicy().hasHeightForWidth())
        self.label_3.setSizePolicy(sizePolicy1)
        self.label_3.setMinimumSize(QSize(0, 40))

        self.gridLayout_3.addWidget(self.label_3, 2, 0, 1, 4)


        self.gridLayout_2.addWidget(self.frame, 0, 0, 1, 1)

        self.toolBox.addItem(self.pageAtt, u"Attendance machines, logs")
        self.pageExcel = QWidget()
        self.pageExcel.setObjectName(u"pageExcel")
        self.gridLayout_4 = QGridLayout(self.pageExcel)
        self.gridLayout_4.setObjectName(u"gridLayout_4")
        self.label_7 = QLabel(self.pageExcel)
        self.label_7.setObjectName(u"label_7")
        sizePolicy.setHeightForWidth(self.label_7.sizePolicy().hasHeightForWidth())
        self.label_7.setSizePolicy(sizePolicy)

        self.gridLayout_4.addWidget(self.label_7, 1, 0, 1, 2)

        self.label_6 = QLabel(self.pageExcel)
        self.label_6.setObjectName(u"label_6")

        self.gridLayout_4.addWidget(self.label_6, 0, 0, 1, 1)

        self.toolBox.addItem(self.pageExcel, u"Data from excel")
        self.pageDb = QWidget()
        self.pageDb.setObjectName(u"pageDb")
        self.pageDb.setGeometry(QRect(0, 0, 828, 507))
        self.toolBox.addItem(self.pageDb, u"Database")

        self.gridLayout.addWidget(self.toolBox, 0, 0, 1, 1)

        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QMenuBar(MainWindow)
        self.menubar.setObjectName(u"menubar")
        self.menubar.setGeometry(QRect(0, 0, 850, 21))
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QStatusBar(MainWindow)
        self.statusbar.setObjectName(u"statusbar")
        MainWindow.setStatusBar(self.statusbar)

        self.retranslateUi(MainWindow)

        self.toolBox.setCurrentIndex(0)


        QMetaObject.connectSlotsByName(MainWindow)
    # setupUi

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QCoreApplication.translate("MainWindow", u"MainWindow", None))
        self.buttonGetlogs.setText(QCoreApplication.translate("MainWindow", u"Connect, get logs", None))
        self.ipMachines.setText(QCoreApplication.translate("MainWindow", u"192.168.1.31 192.168.1.32 192.168.1.33 192.168.1.34 ", None))
        self.label_2.setText(QCoreApplication.translate("MainWindow", u"Logs", None))
        self.label_4.setText(QCoreApplication.translate("MainWindow", u"Status:", None))
        self.comboBoxOneOrRealtime.setItemText(0, QCoreApplication.translate("MainWindow", u"Real time", None))
        self.comboBoxOneOrRealtime.setItemText(1, QCoreApplication.translate("MainWindow", u"One  time", None))

        self.label.setText(QCoreApplication.translate("MainWindow", u"IP address", None))
        self.label_5.setText(QCoreApplication.translate("MainWindow", u"Logs:", None))
        self.label_3.setText(QCoreApplication.translate("MainWindow", u"Status :", None))
        self.toolBox.setItemText(self.toolBox.indexOf(self.pageAtt), QCoreApplication.translate("MainWindow", u"Attendance machines, logs", None))
        self.label_7.setText(QCoreApplication.translate("MainWindow", u"Logs", None))
        self.label_6.setText(QCoreApplication.translate("MainWindow", u"Logs:", None))
        self.toolBox.setItemText(self.toolBox.indexOf(self.pageExcel), QCoreApplication.translate("MainWindow", u"Data from excel", None))
        self.toolBox.setItemText(self.toolBox.indexOf(self.pageDb), QCoreApplication.translate("MainWindow", u"Database", None))
    # retranslateUi

