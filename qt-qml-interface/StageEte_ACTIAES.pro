QT += quick
QT += core
QT += serialport
QT += serialbus
# Include the WiringPi library
LIBS += -lwiringPi -lrt
INCLUDEPATH += /usr/local/include
LIBS += -L/usr/local/lib

SOURCES += \
    canhandler.cpp \
    main.cpp \
    gpiohandler.cpp \
    spihandler.cpp \
    uarthandler.cpp

HEADERS += \
    canhandler.h \
    gpiohandler.h \
    spihandler.h \
    uarthandler.h

RESOURCES += qml.qrc
