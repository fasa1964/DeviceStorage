
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>

#include "fdeviceloader.h"
#include "fdevicenetwork.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setApplicationName("Device Storage");
    app.setApplicationVersion("1.0");
    app.setOrganizationName("qt-example@devicestorage");
    app.setOrganizationDomain("qt-example@devicestorage.com");
    app.setWindowIcon(QIcon(":/icon/storage.ico"));

    qmlRegisterType<FDeviceLoader>("FDeviceLoader", 1, 0, "FDevice");
    qmlRegisterType<FDeviceNetwork>("FDeviceNetwork", 1, 0, "FNetwork");

    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("DeviceStorage", "Main");

    return app.exec();
}
