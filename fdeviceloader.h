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
    Q_PROPERTY(double totalCost READ totalCost WRITE setTotalCost NOTIFY totalCostChanged)
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


    // For loading file
    Q_INVOKABLE bool loadDeviceDatas(const QUrl &url);



    int deviceCount() const;
    void setDeviceCount(int newDeviceCount);

    QImage deviceImage() const;
    void setDeviceImage(const QImage &newDeviceImage);

    QColor originalColor() const;
    void setOriginalColor(const QColor &newOriginalColor);

    double totalCost() const;
    void setTotalCost(double newTotalCost);

    QString currentFilename() const;
    void setCurrentFilename(const QString &newCurrentFilename);

    QString currentPath() const;
    void setCurrentPath(const QString &newCurrentPath);

signals:

    void errorOccurred(const QString &errorText);
    void info(const QString &infoText);
    void deviceAdded(bool status);

    void deviceCountChanged();
    void totalCostChanged();
    void deviceImageChanged();

private:
    QMap<QString, FDevice> deviceMap;

    QColor m_originalColor;
    double calculate();

    // For loading device data's
    QString m_currentFilename;
    QString m_currentPath;


    int m_deviceCount;
    double m_totalCost;
    QImage m_deviceImage;

    QVariantMap toVariantMap(const FDevice &device);

    bool loadDevice(const QString &filename);
    void saveDevice();


};

#endif // FDEVICELOADER_H
