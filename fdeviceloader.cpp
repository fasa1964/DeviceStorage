#include "fdeviceloader.h"

#include <QFile>
#include <QIODevice>
#include <QDataStream>
#include <QImage>
#include <QPdfWriter>
#include <QScreen>


#include <QDebug>

FDeviceLoader::FDeviceLoader(QObject *parent)
    : QObject{parent}
{
    setDeviceCount(0);
}

void FDeviceLoader::loadDeviceMap()
{
    loadDevice();
}

void FDeviceLoader::addDevice(const QVariantMap &map, bool change)
{
    QString deviceName = map.value("name").toString();

    if(deviceName.isEmpty())
        return;

    if( !change && deviceMap.contains( deviceName) )
        return;

    // Create new device
    FDevice device;
    device.setDate( map.value("date").toDate() );
    device.setName( map.value("name").toString() );
    device.setDescription( map.value("description").toString() );
    device.setUrl( map.value("url").toUrl() );
    device.setPdf(  map.value("pdf").toString() );
    device.setCount(  map.value("count").toInt() );
    device.setCosts(  map.value("price").toDouble() );
    device.setImagePath( map.value("imagepath").toString() );


    // Create image for device
    // -------------------------------------------------
    QImage image;
    if(!map.value("image").toString().isEmpty()){

        QString imagefile = map.value("image").toString().split("///").last();

        //device.setImagePath( imagefile ); // Path of image

        if(image.load(imagefile)){
            device.setImage(image);
        }else{
            emit errorOccurred(tr("Could not create Image!"));
            return;
        }
    }
    //!------------------------------------------------


    deviceMap.insert(deviceName, device);
    saveDevice();

    setDeviceCount( deviceMap.size() );

    emit deviceAdded(true);

}

bool FDeviceLoader::deleteDevice(const QString &key)
{
    bool status = false;
    if(!deviceMap.contains(key))
        return status;

    if(deviceMap.remove(key) == 1){
        status = true;
        emit info("Item: " + key + " has been deleted!");
    }

    setDeviceCount( deviceMap.size() );
    saveDevice();
    return status;
}

QColor FDeviceLoader::colorLighter(const QColor &color, int factor)
{
    setOriginalColor(color);
    return color.lighter(factor);
}

QColor FDeviceLoader::getOriginalColor()
{
    return originalColor();
}


QList<QVariantMap> FDeviceLoader::getModelMap()
{
    QList<QVariantMap> vamp;

    QMapIterator<QString, FDevice> it(deviceMap);
    while (it.hasNext()) {
        it.next();

        FDevice device = it.value();
        QVariantMap map = toVariantMap(device);

        vamp.append(map);
    }

    return vamp;
}


// QML Properties
int FDeviceLoader::deviceCount() const
{
    return m_deviceCount;
}

void FDeviceLoader::setDeviceCount(int newDeviceCount)
{
    if (m_deviceCount == newDeviceCount)
        return;
    m_deviceCount = newDeviceCount;
    emit deviceCountChanged();
}

QImage FDeviceLoader::deviceImage() const
{
    return m_deviceImage;
}

void FDeviceLoader::setDeviceImage(const QImage &newDeviceImage)
{
    if (m_deviceImage == newDeviceImage)
        return;
    m_deviceImage = newDeviceImage;
    emit deviceImageChanged();
}

QColor FDeviceLoader::originalColor() const
{
    return m_originalColor;
}

void FDeviceLoader::setOriginalColor(const QColor &newOriginalColor)
{
    m_originalColor = newOriginalColor;
}

QVariantMap FDeviceLoader::toVariantMap(const FDevice &device)
{
    QVariantMap map;

    map.insert("name", device.name());
    map.insert("date", device.date());
    map.insert("description", device.description());
    map.insert("image", device.image());
    map.insert("pdf", device.pdf().isEmpty() ? "X" : device.pdf() );
    map.insert("url", device.url().isEmpty() ? QUrl("X") : device.url() );
    map.insert("count", device.count());
    map.insert("price", device.costs());
    map.insert("imagepath", device.imagePath());

    // Test for diplay image in qml
    setDeviceImage(device.image());

    return map;
}
//!-------------------------------------------


void FDeviceLoader::loadDevice()
{
    QFile file("device.dat");
    if(!file.exists())
        return;

    if(!file.open(QIODevice::ReadOnly)){
        return;
    }

    QDataStream in(&file);

    while (!file.atEnd()) {

        FDevice device;
        in >> device;

        deviceMap.insert( device.name(), device);

    }

    file.close();

    setDeviceCount(deviceMap.size());
}

void FDeviceLoader::saveDevice()
{
    QFile file("device.dat");


    if(!file.open(QIODevice::WriteOnly)){
        return;
    }

    QDataStream out(&file);

    QMapIterator<QString, FDevice> it(deviceMap);
    while (it.hasNext()) {
        it.next();

        FDevice device = it.value();
        out << device;

    }

    file.close();

}
