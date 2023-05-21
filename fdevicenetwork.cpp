#include "fdevicenetwork.h"

#include <QSslSocket>

#include <QDebug>

FDeviceNetwork::FDeviceNetwork(QObject *parent)
    : QObject{parent}
{

}

void FDeviceNetwork::tryNetwork()
{
    QNetworkAccessManager *manager = new QNetworkAccessManager(this);



    QNetworkRequest request;
    //request.setUrl(QUrl("http://qt-project.org"));
    request.setUrl(QUrl("https://testfiledownload.com/test-file-generator/"));

    QNetworkReply *reply = manager->get(request);


    connect(manager, &QNetworkAccessManager::finished, this, &FDeviceNetwork::replayFinished);

    connect(reply, &QIODevice::readyRead, this, &FDeviceNetwork::readyRead);
    connect(reply, &QNetworkReply::errorOccurred, this, &FDeviceNetwork::networkErrorOccured);
    connect(reply, &QNetworkReply::sslErrors, this, &FDeviceNetwork::sslErrorOccured);

    // Connetct with authenticator
    //connect(manager, &QNetworkAccessManager::authenticationRequired, this, &FDeviceNetwork::networkAuthentification);

}

bool FDeviceNetwork::sslSupport()
{
    return QSslSocket::supportsSsl();
}

void FDeviceNetwork::replayFinished(QNetworkReply *reply)
{
    if(reply->isFinished())
        emit networkFinished("Network finished reply");


}

void FDeviceNetwork::readyRead()
{
    emit networkFinished("Network ready to read");
}

void FDeviceNetwork::networkErrorOccured()
{
    emit networkError("Network Error");
}

void FDeviceNetwork::sslErrorOccured()
{
    emit networkError("SSL Error");
}

//void FDeviceNetwork::networkAuthentification(QNetworkReply *reply, QAuthenticator *authenticator)
//{
//    qDebug() << reply->header(QNetworkRequest::ServerHeader);


//}
