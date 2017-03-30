TEMPLATE = app

QT += qml quick widgets quickwidgets multimedia svg xml network

android {
    QT += androidextras
}

CONFIG += c++11

SOURCES += main.cpp \
    goechoapp.cpp \
    systemtray.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    goechoapp.h \
    systemtray.h

win32:RC_ICONS += favicons/favicon.ico

DISTFILES += \
    android/AndroidManifest.xml \
    android/res/values/libs.xml \
    android/build.gradle

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

contains(ANDROID_TARGET_ARCH, armeabi-v7a) {
    ANDROID_EXTRA_LIBS = \
        $$PWD/android/libs/openssl/armeabi-v7a/libcrypto.so \
        $$PWD/android/libs/openssl/armeabi-v7a/libssl.so
}

contains(ANDROID_TARGET_ARCH, x86) {
    ANDROID_EXTRA_LIBS = \
        $$PWD/android/libs/openssl/x86/libcrypto.so \
        $$PWD/android/libs/openssl/x86/libssl.so
}
