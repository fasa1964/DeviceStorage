
#include <QGuiApplication>
#include <QQmlApplicationEngine>


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setApplicationName("Device Storage");
    app.setApplicationVersion("1.0");
    app.setOrganizationName("qt-example@devicestorage");
    app.setOrganizationDomain("qt-example@devicestorage.com");



    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("DeviceStorage", "Main");

    return app.exec();
}
