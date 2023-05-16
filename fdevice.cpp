#include "fdevice.h"



QString FDevice::name() const
{
    return m_name;
}

void FDevice::setName(const QString &newName)
{
    m_name = newName;
}

QString FDevice::description() const
{
    return m_description;
}

void FDevice::setDescription(const QString &newDescription)
{
    m_description = newDescription;
}

int FDevice::count() const
{
    return m_count;
}

void FDevice::setCount(int newCount)
{
    m_count = newCount;
}

double FDevice::costs() const
{
    return m_costs;
}

void FDevice::setCosts(double newCosts)
{
    m_costs = newCosts;
}

QUrl FDevice::url() const
{
    return m_url;
}

void FDevice::setUrl(const QUrl &newUrl)
{
    m_url = newUrl;
}

QImage FDevice::image() const
{
    return m_image;
}

void FDevice::setImage(const QImage &newImage)
{
    m_image = newImage;
}

QString FDevice::pdf() const
{
    return m_pdf;
}

void FDevice::setPdf(const QString &newPdf)
{
    m_pdf = newPdf;
}

QDate FDevice::date() const
{
    return m_date;
}

void FDevice::setDate(const QDate &newDate)
{
    m_date = newDate;
}

QString FDevice::imagePath() const
{
    return m_imagePath;
}

void FDevice::setImagePath(const QString &newImagePath)
{
    m_imagePath = newImagePath;
}
