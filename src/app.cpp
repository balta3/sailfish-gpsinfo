#include "app.h"
#include <QGuiApplication>
#include <QDebug>

App::App(QObject *parent) :
    QObject(parent)
{
}

void App::localeChanged(QString locale) {
    QGuiApplication::removeTranslator(&(this->translator));
    qDebug() << "locale changed to" << locale;
    QString fileName = locale.compare("en") == 0 ? "harbour-gpsinfo.qm" : "harbour-gpsinfo_"+locale+".qm";
    this->translator.load(fileName, "/usr/share/harbour-gpsinfo/translations");
    QGuiApplication::installTranslator(&(this->translator));
}
