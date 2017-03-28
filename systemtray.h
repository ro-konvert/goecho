#ifndef SYSTEMTRAY_H
#define SYSTEMTRAY_H

#include <QObject>
#include <QMenu>
#include <QSystemTrayIcon>

class SystemTray : public QObject
{
    Q_OBJECT
public:
    explicit SystemTray(QObject *parent = 0);

private:
    QSystemTrayIcon *trayIcon;

signals:
    void signalIconActivated();
    void signalShow();
    void signalQuit();

    void signalAbout();
    void signalHelp();
    void signalConfig();

private slots:
    void iconActivated(QSystemTrayIcon::ActivationReason reason);

public slots:
    void showMessage(QString title, QString message);
    void hideIconTray();

public slots:
};

#endif // SYSTEMTRAY_H
