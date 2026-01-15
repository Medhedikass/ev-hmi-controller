#ifndef CANHANDLER_H
#define CANHANDLER_H

#include <QObject>
#include <QCanBusDevice>
#include <QCanBusFrame>

class CanHandler : public QObject {
    Q_OBJECT
public:
    explicit CanHandler(QObject *parent = nullptr);
    ~CanHandler();
signals:
    void temperatureUpdate(float temperature1);
    void rpmUpdate(float rpm1);

private slots:
    void receiveMessages();

private:
    QCanBusDevice *canDevice;
};

#endif
