TARGET = harbour-gpsinfo

CONFIG += sailfishapp sailfishapp_i18n

SOURCES += \
    src/gpsdatasource.cpp \
    src/qmlsettingswrapper.cpp \
    src/gpsinfosettings.cpp \
    src/app.cpp \
    src/harbour-gpsinfo.cpp

OTHER_FILES += \
    translations/harbour-gpsinfo*.ts

DISTFILES += qml/pages/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/components/InfoField.qml \
    qml/pages/SettingsPage.qml \
    qml/LocationFormatter.js \
    qml/components/Providers.qml \
    qml/components/ShowGridRowLabel.qml \
    qml/pages/AboutPage.qml \
    qml/pages/LicensePage.qml \
    qml/license.js \
    rpm/harbour-gpsinfo.spec \
    harbour-gpsinfo.desktop \
    qml/harbour-gpsinfo.qml \
    qml/pages/SatelliteInfoPage.qml \
    images/coverbg.png \
    rpm/harbour-gpsinfo.yaml

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172 256x256

HEADERS += \
    src/gpsdatasource.h \
    src/qmlsettingswrapper.h \
    src/gpsinfosettings.h \
    src/app.h

QT += positioning

TRANSLATIONS += translations/harbour-gpsinfo_*.ts

images.files = \
    images/coverbg.png

images.path = /usr/share/harbour-gpsinfo/images

INSTALLS += images
