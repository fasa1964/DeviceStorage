#ifndef FDEVICE_H
#define FDEVICE_H

#include <QString>
#include <QUrl>
#include <QImage>
#include <QDate>
#include <QMetaType>



#include <QDebug>

class FDevice
{
public:
    FDevice() = default;
    FDevice(const FDevice &) = default;
    ~FDevice() = default;

    friend QDebug operator<<(QDebug dbg, FDevice t){
        QDebugStateSaver saver(dbg);
        return dbg;
    }

    friend QDataStream & operator << (QDataStream &out, const FDevice &dat){

        out << dat.name();
        out << dat.description();
        out << dat.count();
        out << dat.costs();
        out << dat.url();
        out << dat.image();
        out << dat.pdf();
        out << dat.date();
        out << dat.imagePath();


        return out;
    }

    friend QDataStream & operator >> (QDataStream &in, FDevice &dat){

        in >> dat.m_name;
        in >> dat.m_description;
        in >> dat.m_count;
        in >> dat.m_costs;
        in >> dat.m_url;
        in >> dat.m_image;
        in >> dat.m_pdf;
        in >> dat.m_date;
        in >> dat.m_imagePath;

        return in;
    }



    QString name() const;
    void setName(const QString &newName);

    QString description() const;
    void setDescription(const QString &newDescription);

    int count() const;
    void setCount(int newCount);

    double costs() const;
    void setCosts(double newCosts);

    QUrl url() const;
    void setUrl(const QUrl &newUrl);

    QImage image() const;
    void setImage(const QImage &newImage);

    QString pdf() const;
    void setPdf(const QString &newPdf);

    QDate date() const;
    void setDate(const QDate &newDate);

    QString imagePath() const;
    void setImagePath(const QString &newImagePath);

private:

    QString m_name;             // Name of device
    QString m_description;      // Short description
    int m_count;                // Count in storage
    double m_costs;             // in €
    QUrl m_url;                 // Url of device
    QImage m_image;             // Image of device
    QString m_imagePath;        // Path of Image
    QString m_pdf;              // Path of pdf
    QDate m_date;               // Date of constructed


};

Q_DECLARE_METATYPE(FDevice);

#endif // FDEVICE_H
