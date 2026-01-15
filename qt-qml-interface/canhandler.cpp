#include "canhandler.h"
#include <QDebug>
#include <QCanBus>
#include <QVariant>

CanHandler::CanHandler(QObject *parent) : QObject(parent)
{
    canDevice = QCanBus::instance()->createDevice("socketcan", "can0");
    if (!canDevice)
    {
        qWarning() << "Failed to create CAN device";
        return;
    }

    QVariant baudRateVariant = QVariant::fromValue<int>(250000);
    canDevice->setConfigurationParameter(QCanBusDevice::BitRateKey, baudRateVariant);

    if (!canDevice->connectDevice())
    {
        qWarning() << "Failed to connect CAN device";
        delete canDevice;
        canDevice = nullptr;
        return;
    }

    connect(canDevice, &QCanBusDevice::framesReceived, this, &CanHandler::receiveMessages);
}

CanHandler::~CanHandler()
{
    if (canDevice)
    {
        canDevice->disconnectDevice();
        delete canDevice;
    }
}

void CanHandler::receiveMessages()
{
    while (canDevice->framesAvailable())
    {
        QCanBusFrame frame = canDevice->readFrame();
        qDebug() << "Received frame ID:" << frame.frameId() << "data:" << frame.payload().toHex();

        if (frame.frameId() == 0x13F80708)
        {
            QByteArray payload = frame.payload();

            if (payload.size() >= 8)
            {
                int byteIndex = 48 / 8;

                unsigned char temperatureByte = payload[byteIndex];

                emit temperatureUpdate(static_cast<float>(temperatureByte));
            }
        }
        else if (frame.frameId() == 0x13F90708)
        {
            QByteArray payload = frame.payload();
            if (payload.size() >= 8)
            {
                int rpm = (static_cast<int>(payload[6] & 0xFF) << 8) | (static_cast<int>(payload[7] & 0xFF));
                emit rpmUpdate(rpm);
            }
        }
    }
}
