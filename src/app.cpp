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
    this->translator.load(locale, "/usr/share/harbour-GPSInfo/locales", QString(), ".qm");
    QGuiApplication::installTranslator(&(this->translator));
}
