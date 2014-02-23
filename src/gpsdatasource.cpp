#include "gpsdatasource.h"
#include <QDebug>

GPSSatellite::GPSSatellite(QObject *parent) :
    QObject(parent) {
}

GPSDataSource::GPSDataSource(QObject *parent) :
    QObject(parent)
{
    this->sSource = QGeoSatelliteInfoSource::createDefaultSource(this);
    if (this->sSource) {
        qDebug() << "created QGeoSatelliteInfoSource" << this->sSource->sourceName();
        connect(this->sSource, SIGNAL(satellitesInUseUpdated(QList<QGeoSatelliteInfo>)), this, SLOT(satellitesInUseUpdated(QList<QGeoSatelliteInfo>)));
        connect(this->sSource, SIGNAL(satellitesInViewUpdated(QList<QGeoSatelliteInfo>)), this, SLOT(satellitesInViewUpdated(QList<QGeoSatelliteInfo>)));
    } else {
        qDebug() << "cannot create default QGeoSatelliteInfoSource";
    }
    this->active = false;
}

void GPSDataSource::satellitesInUseUpdated(const QList<QGeoSatelliteInfo> &infos) {
    foreach (QGeoSatelliteInfo info, infos) {
        if (!this->satellites.contains(info.satelliteIdentifier())) {
            GPSSatellite* sat = new GPSSatellite(this);
            sat->setAzimuth(info.attribute(QGeoSatelliteInfo::Azimuth));
            sat->setElevation(info.attribute(QGeoSatelliteInfo::Elevation));
            sat->setIdentifier(info.satelliteIdentifier());
            sat->setInUse(true);
            sat->setSignalStrength(info.signalStrength());
            this->satellites[info.satelliteIdentifier()] = sat;
        } else {
            this->satellites[info.satelliteIdentifier()]->setInUse(true);
        }
    }
    emit this->satellitesChanged();
    this->setNumberOfUsedSatellites(infos.size());
}

void GPSDataSource::satellitesInViewUpdated(const QList<QGeoSatelliteInfo> &infos) {
    qDeleteAll(this->satellites);
    this->satellites.clear();
    foreach (QGeoSatelliteInfo info, infos) {
        GPSSatellite* sat = new GPSSatellite(this);
        sat->setAzimuth(info.attribute(QGeoSatelliteInfo::Azimuth));
        sat->setElevation(info.attribute(QGeoSatelliteInfo::Elevation));
        sat->setIdentifier(info.satelliteIdentifier());
        sat->setInUse(false);
        sat->setSignalStrength(info.signalStrength());
        this->satellites[info.satelliteIdentifier()] = sat;
    }
    emit this->satellitesChanged();
    this->setNumberOfVisibleSatellites(infos.size());
}

QVariantList GPSDataSource::getSatellites() {
    QList<GPSSatellite*> sats = this->satellites.values();
    QVariantList result;
    foreach (GPSSatellite* sat, sats) {
        result << QVariant::fromValue(sat);
    }
    return result;
}

void GPSDataSource::setActive(bool active) {
    if (!this->active && active) {
        if (this->sSource) {
            qDebug() << "activating source...";
            this->sSource->startUpdates();
            this->active = true;
            emit this->activeChanged(true);
        }
    } else if (this->active && !active) {
        if (this->sSource) {
            qDebug() << "deactivating source...";
            this->sSource->stopUpdates();
            this->active = false;
            qDeleteAll(this->satellites);
            this->satellites.clear();
            emit this->activeChanged(false);
            emit this->satellitesChanged();
        }
    }
}

void GPSDataSource::setUpdateInterval(int updateInterval) {
    if (this->sSource){
        this->sSource->setUpdateInterval(updateInterval);
        emit this->updateIntervalChanged(updateInterval);
    }
}
