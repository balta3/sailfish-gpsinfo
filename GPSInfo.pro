# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-GPSInfo

CONFIG += sailfishapp

SOURCES += \
    src/gpsdatasource.cpp \
    src/qmlsettingswrapper.cpp \
    src/gpsinfosettings.cpp \
    src/harbour-GPSInfo.cpp

OTHER_FILES += \
    qml/pages/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/InfoField.qml \
    qml/pages/SettingsPage.qml \
    qml/LocationFormatter.js \
    qml/providers/Providers.qml \
    qml/pages/ShowGridRowLabel.qml \
    qml/pages/AboutPage.qml \
    qml/pages/LicensePage.qml \
    qml/license.js \
    qml/harbour-GPSInfo.qml \
    harbour-GPSInfo.desktop \
    rpm/harbour-GPSInfo.yaml \
    rpm/harbour-GPSInfo.spec

HEADERS += \
    src/gpsdatasource.h \
    src/qmlsettingswrapper.h \
    src/gpsinfosettings.h

QT += positioning
