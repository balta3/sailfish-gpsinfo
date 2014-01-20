#ifndef APP_H
#define APP_H

#include <QObject>
#include <QTranslator>

class App : public QObject
{
    Q_OBJECT
public:
    explicit App(QObject *parent = 0);

signals:

public slots:
    void localeChanged(QString locale);
private:
    QTranslator translator;
};

#endif // APP_H
