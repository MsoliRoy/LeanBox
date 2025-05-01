import sys
import subprocess
from PyQt6.QtWidgets import (
    QApplication, QWidget, QVBoxLayout, QLabel,
    QPushButton, QTextEdit, QCheckBox, QMessageBox
)
from PyQt6.QtGui import QPalette, QColor
from PyQt6.QtCore import Qt

class LeanBox(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("LeanBox - Dev Optimizer")
        self.setFixedSize(500, 400)
        self.set_dark_theme()

        layout = QVBoxLayout()

        title = QLabel("\u2699\ufe0f LeanBox - Optimize Your Dev Environment")
        title.setStyleSheet("font-size: 18px; font-weight: bold;")
        layout.addWidget(title)

        self.services = [
            "bluetooth.service",
            "cups.service",
            "avahi-daemon.service",
            "snapd.service",
            "ModemManager.service",
            "ufw.service"
        ]

        self.checkboxes = []
        for service in self.services:
            cb = QCheckBox(service)
            cb.setChecked(True)
            layout.addWidget(cb)
            self.checkboxes.append(cb)

        self.optimize_btn = QPushButton("Optimize System")
        self.optimize_btn.clicked.connect(self.optimize)
        layout.addWidget(self.optimize_btn)

        self.log = QTextEdit()
        self.log.setReadOnly(True)
        layout.addWidget(self.log)

        self.setLayout(layout)

    def set_dark_theme(self):
        palette = QPalette()
        palette.setColor(QPalette.ColorRole.Window, QColor(30, 30, 30))
        palette.setColor(QPalette.ColorRole.WindowText, Qt.GlobalColor.white)
        palette.setColor(QPalette.ColorRole.Base, QColor(45, 45, 45))
        palette.setColor(QPalette.ColorRole.Text, Qt.GlobalColor.white)
        palette.setColor(QPalette.ColorRole.Button, QColor(60, 60, 60))
        palette.setColor(QPalette.ColorRole.ButtonText, Qt.GlobalColor.white)
        self.setPalette(palette)

    def optimize(self):
        self.log.append("\nStarting optimization...\n")
        for i, service in enumerate(self.services):
            if self.checkboxes[i].isChecked():
                result = subprocess.run(["systemctl", "disable", "--now", service],
                                        stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
                if result.returncode == 0:
                    self.log.append(f"[+] Disabled: {service}")
                else:
                    self.log.append(f"[!] Failed to disable {service}: {result.stderr.strip()}")

        # Clean autostart entries
        result = subprocess.run("mkdir -p ~/.config/autostart/backup && mv ~/.config/autostart/*.desktop ~/.config/autostart/backup/ 2>/dev/null",
                                shell=True)
        self.log.append("\n[+] Autostart entries backed up and removed.\n")

        QMessageBox.information(self, "LeanBox", "Optimization complete!")

if __name__ == '__main__':
    app = QApplication(sys.argv)
    box = LeanBox()
    box.show()
    sys.exit(app.exec())
