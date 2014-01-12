# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = GPSInfo

CONFIG += sailfishapp

SOURCES += src/GPSInfo.cpp \
    src/gpsdatasource.cpp \
    src/qmlsettingswrapper.cpp

OTHER_FILES += qml/GPSInfo.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    rpm/GPSInfo.spec \
    rpm/GPSInfo.yaml \
    GPSInfo.desktop \
    qml/pages/InfoField.qml \
    qml/pages/SettingsPage.qml \
    qml/LocationFormatter.js

HEADERS += \
    src/gpsdatasource.h \
    src/qmlsettingswrapper.h

QT += positioning
