#ifndef GPSDATASOURCE_H
#define GPSDATASOURCE_H

#include <QObject>
#include <QGeoPositionInfoSource>
#include <QGeoSatelliteInfoSource>

class GPSDataSource : public QObject
{
    Q_OBJECT
public:
    explicit GPSDataSource(QObject *parent = 0);
private:
    QGeoPositionInfoSource* pSource;
    QGeoSatelliteInfoSource* sSource;
signals:

public slots:
    void positionUpdated(const QGeoPositionInfo &info);
    void satellitesInUseUpdated(const QGeoSatelliteInfo &info);
    void satellitesInViewUpdated(const QGeoSatelliteInfo &info);
};

#endif // GPSDATASOURCE_H
