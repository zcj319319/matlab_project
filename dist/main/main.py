# This is a sample Python script.

# Press Shift+F10 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.


import sys

from PyQt5 import QtWidgets

from loadingPanel import LoadingPanel

app = QtWidgets.QApplication(sys.argv)

if __name__ == '__main__':
    try:
        ex = LoadingPanel()
        ex.show()
        sys.exit(app.exec_())
    except Exception as e:
        raise e
