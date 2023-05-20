#ifndef FDEVICENETWORK_H
#define FDEVICENETWORK_H

#include <QObject>
#include <QQmlEngine>

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QAuthenticator>

class FDeviceNetwork : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit FDeviceNetwork(QObject *parent = nullptr);
    Q_INVOKABLE void tryNetwork();

signals:
    void networkError(const QString &errorText);
    void networkFinished(const QString &infoText);


private slots:
    void replayFinished(QNetworkReply *reply);
    void readyRead();
    void networkErrorOccured();
    void sslErrorOccured();
    //void networkAuthentification(QNetworkReply *reply,  QAuthenticator *authenticator);

};

#endif // FDEVICENETWORK_H
