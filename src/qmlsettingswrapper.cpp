#include "qmlsettingswrapper.h"

QMLSettingsWrapper::QMLSettingsWrapper(QString organisation, QString application, QObject *parent) :
    QObject(parent)
{
    this->settings = new QSettings(organisation, application, this);
}

QVariant QMLSettingsWrapper::value(const QString &key){
   return this->settings->value(key);
}

void QMLSettingsWrapper::setValue(const QString &key, const QVariant &value){
   this->settings->setValue(key, value);
}
