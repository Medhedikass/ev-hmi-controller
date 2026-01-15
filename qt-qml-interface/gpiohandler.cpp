#include "gpiohandler.h"
#include <wiringPi.h>

GpioHandler::GpioHandler(QObject *parent) : QObject(parent)
{
    wiringPiSetup();
    pinMode(reversePin, OUTPUT);
    pinMode(brakePin, OUTPUT);
    pinMode(startPin, OUTPUT);
}

void GpioHandler::enableReverse()
{
    digitalWrite(reversePin, LOW);
}

void GpioHandler::disableReverse()
{
    digitalWrite(reversePin, HIGH);
}

void GpioHandler::enableBrake()
{
    digitalWrite(brakePin, LOW);
}

void GpioHandler::disableBrake()
{
    digitalWrite(brakePin, HIGH);
}

void GpioHandler::enableStart()
{
    digitalWrite(startPin, LOW);
}

void GpioHandler::disableStart()
{
    digitalWrite(startPin, HIGH);
}
