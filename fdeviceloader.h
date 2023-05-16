#ifndef FDEVICELOADER_H
#define FDEVICELOADER_H

#include <QObject>
#include <QQmlEngine>
#include <QColor>

#include <QMap>
#include <QVariant>


#include "fdevice.h"

class FDeviceLoader : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int deviceCount READ deviceCount WRITE setDeviceCount NOTIFY deviceCountChanged)
    Q_PROPERTY(QImage deviceImage READ deviceImage WRITE setDeviceImage NOTIFY deviceImageChanged)


public:
    explicit FDeviceLoader(QObject *parent = nullptr);
    Q_INVOKABLE void loadDeviceMap();
    Q_INVOKABLE void addDevice(const QVariantMap &map, bool change);
    Q_INVOKABLE bool deleteDevice(const QString &key);

    Q_INVOKABLE QColor colorLighter(const QColor &color, int factor);
    Q_INVOKABLE QColor getOriginalColor();

    // Test with QStringList for Model in qml
    Q_INVOKABLE QList<QVariantMap> getModelMap();


    int deviceCount() const;
    void setDeviceCount(int newDeviceCount);

    QImage deviceImage() const;
    void setDeviceImage(const QImage &newDeviceImage);

    QColor originalColor() const;
    void setOriginalColor(const QColor &newOriginalColor);

signals:

    void errorOccurred(const QString &errorText);
    void info(const QString &infoText);
    void deviceAdded(bool status);

    void deviceCountChanged();
    void deviceImageChanged();

private:
    QMap<QString, FDevice> deviceMap;

    QColor m_originalColor;


    int m_deviceCount;
    QImage m_deviceImage;

    QVariantMap toVariantMap(const FDevice &device);

    void loadDevice();
    void saveDevice();


};

#endif // FDEVICELOADER_H
