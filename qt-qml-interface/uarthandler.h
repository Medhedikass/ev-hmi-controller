#ifndef UARTHANDLER_H
#define UARTHANDLER_H

#include <QObject>
#include <QSerialPort>
#include <QQuickView>
class UartHandler : public QObject
{
    Q_OBJECT
public:
    explicit UartHandler(QObject *parent = nullptr);
    Q_INVOKABLE void sendData(int value);
private:
    QSerialPort serial;
};

#endif // UARTHANDLER_H
