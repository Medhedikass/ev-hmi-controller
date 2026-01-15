#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "gpiohandler.h"
#include "uarthandler.h"
#include "spihandler.h"
#include <QQuickView>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    GpioHandler gpioHandler;
    UartHandler uartHandler;
    SPIHandler spiHandler;

    //spiHandler.openDevice("/dev/spidev0.0");
    //QQuickView view;


    // Expose the GpioHandler instance to QML
    engine.rootContext()->setContextProperty("gpioHandler", &gpioHandler);
    engine.rootContext()->setContextProperty("uartHandler", &uartHandler);
    engine.rootContext()->setContextProperty("spiHandler", &spiHandler);

    const QUrl url(QStringLiteral(u"qrc:/main.qml"));
    engine.load(url);

    // view.show();
    return app.exec();
}
