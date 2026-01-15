#include "uarthandler.h"
#include <QDebug>

UartHandler::UartHandler(QObject *parent) : QObject(parent)
{
    serial.setPortName("/dev/ttyACM0");
    serial.setBaudRate(QSerialPort::Baud115200);
    serial.setDataBits(QSerialPort::Data8);
    serial.setParity(QSerialPort::NoParity);
    serial.setStopBits(QSerialPort::OneStop);
    serial.setFlowControl(QSerialPort::NoFlowControl);

    if (serial.open(QIODevice::WriteOnly))
    {
        qDebug() << "UART connection opened successfully";
    }
    else
    {
        qDebug() << "UART connection failed: " << serial.errorString();
    }
}

void UartHandler::sendData(int value)
{
    if (serial.isOpen())
    {
        if (value < 0) value = 0;
        if (value > 100) value = 100;

        QByteArray data = QByteArray::number(value) + '\n';

        qint64 bytesWritten = serial.write(data);
        //serial.write(data);
        if (bytesWritten == -1)
        {
            qDebug() << "Write error:" << serial.errorString();
        }
        else
        {
            //serial.flush();
            qDebug() << "Sending data:" << static_cast<int>(value);
        }
    }
    else
    {
        qDebug() << "Serial port not open!";
    }
}
