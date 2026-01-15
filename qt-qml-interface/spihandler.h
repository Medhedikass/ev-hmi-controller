#ifndef SPIHANDLER_H
#define SPIHANDLER_H

#include <QObject>
#include <QString>
#include <QFile>
#include <QDebug>

class SPIHandler : public QObject
{
    Q_OBJECT
public:
    explicit SPIHandler(QObject *parent = nullptr);
    ~SPIHandler();

    Q_INVOKABLE bool openDevice(const QString &device);
    Q_INVOKABLE void closeDevice();
    Q_INVOKABLE bool sendValue(int value); // Make this function Q_INVOKABLE

private:
    int fd;  // File descriptor for SPI device

    bool writeSPI(int value);
};

#endif // SPIHANDLER_H
