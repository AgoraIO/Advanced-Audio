TEMPLATE = app

QT += core quickwidgets
CONFIG += c++11

SOURCES += main.cpp \
    agorartcengine.cpp \
    mainwindow.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    agorartcengine.h \
    mainwindow.h


win32: {
INCLUDEPATH += $$PWD/sdk/include
LIBS += -L$$PWD/sdk/lib/ -lagora_rtc_sdk
}

macx:{
QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.11

INCLUDEPATH += $$PWD/lib/AgoraRtcEngineKit.framework/Headers

QMAKE_LFLAGS += -F/System/Library/Frameworks
QMAKE_LFLAGS += -F$$PWD/lib/

LIBS += -framework AgoraRtcEngineKit
LIBS += -framework Foundation \
        -framework CoreAudio \
        -framework CoreVideo \
        -framework CoreServices \
        -framework AppKit \
        -framework AudioToolbox \
        -framework VideoToolbox \
        -framework Accelerate \
        -framework SystemConfiguration \
        -framework AVFoundation \
        -framework CoreMedia \
        -framework CoreWLAN \
        -framework QTKit \
        -framework CoreGraphics

LIBS += -lresolv
}

DISTFILES += \
    helveticaneue/Helvetica Neu Bold.ttf
