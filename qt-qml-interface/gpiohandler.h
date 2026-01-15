#ifndef GPIOHANDLER_H
#define GPIOHANDLER_H

#include <QObject>

class GpioHandler : public QObject
{
    Q_OBJECT
public:
    explicit GpioHandler(QObject *parent = nullptr);

    Q_INVOKABLE void enableReverse();
    Q_INVOKABLE void disableReverse();
    Q_INVOKABLE void enableBrake();
    Q_INVOKABLE void disableBrake();
    Q_INVOKABLE void enableStart();
    Q_INVOKABLE void disableStart();

private:
    int reversePin = 0;
    int brakePin = 3;
    int startPin = 4;
};

#endif // GPIOHANDLER_H
