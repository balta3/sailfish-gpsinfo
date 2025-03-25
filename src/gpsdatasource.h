#ifndef GPSDATASOURCE_H
#define GPSDATASOURCE_H

#include <QObject>
#include <QVariant>
#include <QMap>
#include <QGeoSatelliteInfoSource>
#include <QGeoPositionInfoSource>

class GPSSatellite : public QObject {
    Q_OBJECT
    Q_PROPERTY(qreal azimuth READ getAzimuth WRITE setAzimuth NOTIFY azimuthChanged)
    Q_PROPERTY(qreal elevation READ getElevation WRITE setElevation NOTIFY elevationChanged)
    Q_PROPERTY(int identifier READ getIdentifier WRITE setIdentifier NOTIFY identifierChanged)
    Q_PROPERTY(bool inUse READ isInUse WRITE setInUse NOTIFY inUseChanged)
    Q_PROPERTY(int signalStrength READ getSignalStrength WRITE setSignalStrength NOTIFY signalStrengthChanged)
    Q_PROPERTY(SatelliteSystem system READ getSystem WRITE setSystem NOTIFY systemChanged)
public:
    explicit GPSSatellite(QObject *parent = 0);
    enum class SatelliteSystem {
        UNKNOWN, GPS, GLONASS, QZSS, BEIDOU, GALILEO
    };
    Q_ENUM(SatelliteSystem)
private:
    qreal azimuth;
    qreal elevation;
    int identifier;
    bool inUse;
    int signalStrength;
    SatelliteSystem system;
public slots:
    qreal getAzimuth() {return this->azimuth;}
    qreal getElevation() {return this->elevation;}
    int getIdentifier() {return this->identifier;}
    int getSignalStrength() {return this->signalStrength;}
    SatelliteSystem getSystem() {return this->system;}
    bool isInUse() {return this->inUse;}
    void setAzimuth(qreal azimuth) {this->azimuth = azimuth; emit this->azimuthChanged(this->azimuth);}
    void setElevation(qreal elevation) {this->elevation = elevation; emit this->elevationChanged(this->elevation);}
    void setIdentifier(int identifier) {this->identifier = identifier; emit this->identifierChanged(this->identifier);}
    void setInUse(bool inUse) {this->inUse = inUse; emit this->inUseChanged(this->inUse);}
    void setSignalStrength(int signalStrength) {this->signalStrength = signalStrength; emit this->signalStrengthChanged(this->signalStrength);}
    void setSystem(SatelliteSystem system) {this->system = system;}
signals:
    void azimuthChanged(qreal azimuth);
    void elevationChanged(qreal elevation);
    void identifierChanged(int identifier);
    void inUseChanged(bool inUse);
    void signalStrengthChanged(int signalStrength);
    void systemChanged(SatelliteSystem system);
};

typedef QMap<GPSSatellite::SatelliteSystem, int> SatelliteNumberMap;

class GPSDataSource : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList satellites READ getSatellites NOTIFY satellitesChanged)
    Q_PROPERTY(bool active READ isActive WRITE setActive NOTIFY activeChanged)
    Q_PROPERTY(int updateInterval READ getUpdateInterval WRITE setUpdateInterval NOTIFY updateIntervalChanged)
    Q_PROPERTY(qreal movementDirection READ getMovementDirection WRITE setMovementDirection NOTIFY movementDirectionChanged)
    Q_PROPERTY(int numberOfUsedSatellites READ getNumberOfUsedSatellites WRITE setNumberOfUsedSatellites NOTIFY numberOfUsedSatellitesChanged)
    Q_PROPERTY(int numberOfVisibleSatellites READ getNumberOfVisibleSatellites WRITE setNumberOfVisibleSatellites NOTIFY numberOfVisibleSatellitesChanged)
public:
    explicit GPSDataSource(QObject *parent = 0);
private:
    QGeoSatelliteInfoSource* sSource;
    QGeoPositionInfoSource* pSource;
    QMap<int, GPSSatellite*> satellites;
    bool active;
    qreal movementDirection;
    int numberOfUsedSatellites;
    int numberOfVisibleSatellites;
    QMap<GPSSatellite::SatelliteSystem, int> numberOfUsedSatellitesBySystem;
    QMap<GPSSatellite::SatelliteSystem, int> numberOfVisibleSatellitesBySystem;
public slots:
    qreal getMovementDirection() {return this->movementDirection;}
    int getNumberOfUsedSatellites() {return this->numberOfUsedSatellites;}
    int getNumberOfUsedSatellitesBySystem(GPSSatellite::SatelliteSystem system) {return this->numberOfUsedSatellitesBySystem[system];}
    int getNumberOfVisibleSatellites() {return this->numberOfVisibleSatellites;}
    int getNumberOfVisibleSatellitesBySystem(GPSSatellite::SatelliteSystem system) {return this->numberOfVisibleSatellitesBySystem[system];}
    QVariantList getSatellites();
    int getUpdateInterval() {if (this->sSource) return this->sSource->updateInterval(); return -1;}
    bool isActive() {return this->active;}
    void positionUpdated(QGeoPositionInfo info);
    void satellitesInUseUpdated(const QList<QGeoSatelliteInfo> &infos);
    void satellitesInViewUpdated(const QList<QGeoSatelliteInfo> &infos);
    void setActive(bool active);
    void setMovementDirection(qreal movingDirection) {this->movementDirection = movingDirection; emit this->movementDirectionChanged(movingDirection);}
    void setNumberOfUsedSatellites(int numberOfUsedSatellites) {this->numberOfUsedSatellites = numberOfUsedSatellites; emit this->numberOfUsedSatellitesChanged(numberOfUsedSatellites);}
    void setNumberOfVisibleSatellites(int numberOfVisibleSatellites) {this->numberOfVisibleSatellites = numberOfVisibleSatellites; emit this->numberOfVisibleSatellitesChanged(numberOfVisibleSatellites);}
    void setUpdateInterval(int updateInterval);
signals:
    void activeChanged(bool);
    void movementDirectionChanged(qreal);
    void numberOfUsedSatellitesChanged(int);
    void numberOfUsedSatellitesBySystemChanged();
    void numberOfVisibleSatellitesChanged(int);
    void numberOfVisibleSatellitesBySystemChanged();
    void satellitesChanged();
    void updateIntervalChanged(int);
};

#endif // GPSDATASOURCE_H
