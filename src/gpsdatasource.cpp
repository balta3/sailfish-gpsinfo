#include "gpsdatasource.h"
#include <QDebug>

GPSDataSource::GPSDataSource(QObject *parent) :
    QObject(parent)
{
    this->pSource = QGeoPositionInfoSource::createDefaultSource(this);
    if (this->pSource) {
        qDebug() << "created QGeoPositionInfoSource" << this->pSource->sourceName();
        connect(this->pSource, SIGNAL(positionUpdated(QGeoPositionInfo)), this, SLOT(positionUpdated(QGeoPositionInfo)));
        this->pSource->startUpdates();
    } else {
        qDebug() << "cannot create default QGeoPositionInfoSource";
    }
    this->sSource = QGeoSatelliteInfoSource::createDefaultSource(this);
    if (this->sSource) {
        qDebug() << "created QGeoSatelliteInfoSource" << this->sSource->sourceName();
        connect(this->sSource, SIGNAL(satellitesInUseUpdated(QList<QGeoSatelliteInfo>)), this, SLOT(satellitesInUseUpdated(QSatelliteInfo)));
        connect(this->sSource, SIGNAL(satellitesInViewUpdated(QList<QGeoSatelliteInfo>)), this, SLOT(satellitesInViewUpdated(QSatelliteInfo)));
        this->sSource->startUpdates();
    } else {
        qDebug() << "cannot create default QGeoSatelliteInfoSource";
    }
}

void GPSDataSource::positionUpdated(const QGeoPositionInfo &info) {
    qDebug() << info;
}

void GPSDataSource::satellitesInUseUpdated(const QGeoSatelliteInfo &info) {
    qDebug() << info;
}

void GPSDataSource::satellitesInViewUpdated(const QGeoSatelliteInfo &info) {
    qDebug() << info;
}
