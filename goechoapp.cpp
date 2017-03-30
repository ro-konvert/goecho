#include "goechoapp.h"

GoEchoApp::GoEchoApp(QObject *parent) : QObject(parent)
{
}

void GoEchoApp::appminimized()
{
#ifdef Q_OS_ANDROID
    QAndroidJniObject qtActivity;
    qtActivity = QtAndroid::androidActivity();
    qtActivity.callMethod<jboolean>("moveTaskToBack", "(Z)Z", jboolean(true));
#endif
}

void GoEchoApp::notifset(QString title, QString msg)
{
#ifdef Q_OS_ANDROID
    QAndroidJniObject javaNotificationTitle = QAndroidJniObject::fromString(title);
    QAndroidJniObject javaNotificationMsg = QAndroidJniObject::fromString(msg);
    QAndroidJniObject::callStaticMethod<void>("domain/goecho/GoEchoJava",
                                              "notifyset",
                                              "(Ljava/lang/String;Ljava/lang/String;)V",
                                              javaNotificationTitle.object<jstring>(),
                                              javaNotificationMsg.object<jstring>());
#endif
}

void GoEchoApp::notifremove()
{
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>("domain/goecho/GoEchoJava",
                                              "notifyremove");
#endif
}

void GoEchoApp::powerwakelock()
{
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>("domain/goecho/GoEchoJava",
                                              "powerwakelock");
#endif
}

void GoEchoApp::screenwakeup()
{
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>("domain/goecho/GoEchoJava",
                                              "screenwakeup");
#endif
}
