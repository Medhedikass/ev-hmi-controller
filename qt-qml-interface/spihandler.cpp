#include "spihandler.h"
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/spi/spidev.h>
#include <unistd.h>

SPIHandler::SPIHandler(QObject *parent) : QObject(parent), fd(-1) {}

SPIHandler::~SPIHandler()
{
    closeDevice();
}
bool SPIHandler::openDevice(const QString &device)
{
    fd = ::open(device.toStdString().c_str(), O_RDWR);
    if (fd < 0)
    {
        qDebug()<< "failed to open SPI device: "<< device;
        return false;
    }
    uint8_t mode = SPI_MODE_0;
    uint32_t speed = 500000;
    if (ioctl(fd, SPI_IOC_WR_MODE, &mode) < 0 || ioctl(fd, SPI_IOC_WR_MAX_SPEED_HZ, &speed) < 0)
    {
        qDebug() << "failed to set SPI parameters";
        closeDevice();
        return false;
    }
    return true;
}

void SPIHandler::closeDevice()
{
    if (fd >= 0)
    {
        ::close(fd);
        fd = -1;
    }
}

bool SPIHandler::sendValue(int value)
{
    if (fd < 0)
    {
        qDebug() << "SPI device not opened!";
        return false;
    }

    return writeSPI(value);
}

bool SPIHandler::writeSPI(int value)
{
    uint8_t txBuffer[1];
    txBuffer[0] = static_cast<uint8_t>(value);

    struct spi_ioc_transfer spi;
    memset(&spi, 0, sizeof(spi));
    spi.tx_buf = (unsigned long)txBuffer;
    spi.len = 1;
    spi.speed_hz = 500000;
    spi.bits_per_word = 8;

    if (ioctl(fd, SPI_IOC_MESSAGE(1), &spi) < 0)
    {
        qDebug() << "Failed to write to SPI";
        return false;
    }

    return true;
}
