#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include <QTranslator>
#include "gpsdatasource.h"
#include "gpsinfosettings.h"
#include "app.h"


int main(int argc, char *argv[]) {
    //GPSDataSource* source = new GPSDataSource();
    GPSInfoSettings* settings = new GPSInfoSettings();
    QGuiApplication* qGuiAppl = SailfishApp::application(argc, argv);
    App* app = new App();
    app->connect(settings, SIGNAL(localeChanged(QString)), app, SLOT(localeChanged(QString)));

    QStringList locales;
    QString baseName("/usr/share/harbour-GPSInfo/locales/");
    QDir localesDir(baseName);
    if (localesDir.exists()) {
        locales = localesDir.entryList(QStringList() << "*.qm", QDir::Files | QDir::NoDotAndDotDot, QDir::Name | QDir::IgnoreCase);
    }
    locales.replaceInStrings(".qm", "");
    QString currentLocale = settings->getLocale();
    if (locales.contains(currentLocale)) {
        qDebug() << "loading" << currentLocale;
        QTranslator* translator = new QTranslator();
        translator->load(currentLocale, "/usr/share/harbour-GPSInfo/locales", QString(), ".qm");
        QGuiApplication::installTranslator(translator);
    } else {
        qDebug() << "missing translation for" << currentLocale;
        qDebug() << "existing translations:" << locales;
    }

    QQuickView *view = SailfishApp::createView();
    view->rootContext()->setContextProperty("settings", settings);
    view->setSource(SailfishApp::pathTo("qml/harbour-GPSInfo.qml"));
    view->showFullScreen();
    return qGuiAppl->exec();
}
