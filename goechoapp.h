#ifndef GOECHOAPP_H
#define GOECHOAPP_H

#include <QObject>
#ifdef Q_OS_ANDROID
#include <QtAndroidExtras/QtAndroid>
#include <QtAndroidExtras/QAndroidJniObject>
#endif

class GoEchoApp : public QObject
{
    Q_OBJECT
public:
    explicit GoEchoApp(QObject *parent = 0);
    Q_INVOKABLE void appminimized();
    Q_INVOKABLE void notifset(QString title, QString msg);
    Q_INVOKABLE void notifremove();
    Q_INVOKABLE void powerwakelock();
    Q_INVOKABLE void screenwakeup();
signals:

public slots:
};

#endif // GOECHOAPP_H
