#include "gpsdatasource.h"
#include <QDebug>

GPSSatellite::SatelliteSystem getSystemByIdentifier(int identifier) {
    if (identifier < 33)
        return GPSSatellite::SatelliteSystem::GPS;
    else if (identifier > 64 && identifier < 97)
        return GPSSatellite::SatelliteSystem::GLONASS;
    else if (identifier > 192 && identifier < 201)
        return GPSSatellite::SatelliteSystem::QZSS;
    else if (identifier > 200 && identifier < 246)
        return GPSSatellite::SatelliteSystem::BEIDOU;
    else if (identifier > 300 && identifier < 337)
        return GPSSatellite::SatelliteSystem::GALILEO;
    else
        return GPSSatellite::SatelliteSystem::UNKNOWN;
}

GPSSatellite::GPSSatellite(QObject *parent) :
    QObject(parent) {
}

GPSDataSource::GPSDataSource(QObject *parent) :
    QObject(parent),
    numberOfUsedSatellites(0),
    numberOfVisibleSatellites(0)
{
    this->sSource = QGeoSatelliteInfoSource::createDefaultSource(this);
    if (this->sSource) {
        qDebug() << "created QGeoSatelliteInfoSource" << this->sSource->sourceName();
        connect(this->sSource, SIGNAL(satellitesInUseUpdated(QList<QGeoSatelliteInfo>)), this, SLOT(satellitesInUseUpdated(QList<QGeoSatelliteInfo>)));
        connect(this->sSource, SIGNAL(satellitesInViewUpdated(QList<QGeoSatelliteInfo>)), this, SLOT(satellitesInViewUpdated(QList<QGeoSatelliteInfo>)));
    } else {
        qDebug() << "cannot create default QGeoSatelliteInfoSource";
    }
    this->pSource = QGeoPositionInfoSource::createDefaultSource(this);
    if (this->pSource) {
        qDebug() << "created QGeoPositionInfoSource" << this->pSource->sourceName();
        connect(this->pSource, SIGNAL(positionUpdated(QGeoPositionInfo)), this, SLOT(positionUpdated(QGeoPositionInfo)));
    } else {
        qDebug() << "cannot create default QGeoPositionInfoSource";
    }
    this->active = false;
}

void GPSDataSource::satellitesInUseUpdated(const QList<QGeoSatelliteInfo> &infos) {
    this->numberOfUsedSatellitesBySystem[GPSSatellite::SatelliteSystem::GPS] = 0;
    this->numberOfUsedSatellitesBySystem[GPSSatellite::SatelliteSystem::GLONASS] = 0;
    this->numberOfUsedSatellitesBySystem[GPSSatellite::SatelliteSystem::QZSS] = 0;
    this->numberOfUsedSatellitesBySystem[GPSSatellite::SatelliteSystem::BEIDOU] = 0;
    this->numberOfUsedSatellitesBySystem[GPSSatellite::SatelliteSystem::GALILEO] = 0;
    this->numberOfUsedSatellitesBySystem[GPSSatellite::SatelliteSystem::UNKNOWN] = 0;
    foreach (QGeoSatelliteInfo info, infos) {
        if (!this->satellites.contains(info.satelliteIdentifier())) {
            GPSSatellite* sat = new GPSSatellite(this);
            sat->setAzimuth(info.attribute(QGeoSatelliteInfo::Azimuth));
            sat->setElevation(info.attribute(QGeoSatelliteInfo::Elevation));
            sat->setIdentifier(info.satelliteIdentifier());
            sat->setInUse(true);
            sat->setSignalStrength(info.signalStrength());
            sat->setSystem(getSystemByIdentifier(info.satelliteIdentifier()));
            this->satellites[info.satelliteIdentifier()] = sat;
        } else {
            this->satellites[info.satelliteIdentifier()]->setInUse(true);
        }
        this->numberOfUsedSatellitesBySystem[this->satellites[info.satelliteIdentifier()]->getSystem()]++;
    }
    emit this->satellitesChanged();
    emit this->numberOfUsedSatellitesBySystemChanged();
    this->setNumberOfUsedSatellites(infos.size());
}

void GPSDataSource::satellitesInViewUpdated(const QList<QGeoSatelliteInfo> &infos) {
    this->numberOfVisibleSatellitesBySystem[GPSSatellite::SatelliteSystem::GPS] = 0;
    this->numberOfVisibleSatellitesBySystem[GPSSatellite::SatelliteSystem::GLONASS] = 0;
    this->numberOfVisibleSatellitesBySystem[GPSSatellite::SatelliteSystem::QZSS] = 0;
    this->numberOfVisibleSatellitesBySystem[GPSSatellite::SatelliteSystem::BEIDOU] = 0;
    this->numberOfVisibleSatellitesBySystem[GPSSatellite::SatelliteSystem::GALILEO] = 0;
    this->numberOfVisibleSatellitesBySystem[GPSSatellite::SatelliteSystem::UNKNOWN] = 0;
    qDeleteAll(this->satellites);
    this->satellites.clear();
    foreach (QGeoSatelliteInfo info, infos) {
        GPSSatellite* sat = new GPSSatellite(this);
        sat->setAzimuth(info.attribute(QGeoSatelliteInfo::Azimuth));
        sat->setElevation(info.attribute(QGeoSatelliteInfo::Elevation));
        sat->setIdentifier(info.satelliteIdentifier());
        sat->setInUse(false);
        sat->setSignalStrength(info.signalStrength());
        sat->setSystem(getSystemByIdentifier(info.satelliteIdentifier()));
        this->numberOfVisibleSatellitesBySystem[sat->getSystem()]++;
        if (sat->getSystem() == GPSSatellite::SatelliteSystem::UNKNOWN) {
            qDebug() << "Unknown system:" << sat->getIdentifier();
        }
        this->satellites[info.satelliteIdentifier()] = sat;
    }
    emit this->satellitesChanged();
    this->setNumberOfVisibleSatellites(infos.size());
    emit this->numberOfVisibleSatellitesBySystemChanged();
}

void GPSDataSource::positionUpdated(QGeoPositionInfo info) {
    this->setMovementDirection(info.attribute(QGeoPositionInfo::Direction));
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
            this->pSource->startUpdates();
            this->active = true;
            emit this->activeChanged(true);
        }
    } else if (this->active && !active) {
        if (this->sSource) {
            qDebug() << "deactivating source...";
            this->sSource->stopUpdates();
            this->pSource->stopUpdates();
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
        this->pSource->setUpdateInterval(updateInterval);
        emit this->updateIntervalChanged(updateInterval);
    }
}
