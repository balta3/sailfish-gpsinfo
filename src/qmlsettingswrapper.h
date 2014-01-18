#ifndef QMLSETTINGSWRAPPER_H
#define QMLSETTINGSWRAPPER_H

#include <QObject>
#include <QSettings>

class QMLSettingsWrapper : public QObject
{
    Q_OBJECT
public:
    explicit QMLSettingsWrapper(QString organisation, QString application, QObject *parent = 0);
private:
    QSettings* settings;
signals:

public slots:
    QVariant value(const QString &key);
    QVariant value(const QString &key, const QVariant &defaultValue);
    void setValue(const QString &key, const QVariant &value);
};

#endif // QMLSETTINGSWRAPPER_H
