#include "systemtray.h"

SystemTray::SystemTray(QObject *parent) : QObject(parent)
{
#ifdef Q_OS_WIN
    QMenu *trayIconMenu = new QMenu();

    QAction * configAction = new QAction(trUtf8("Настройки"), this);
    configAction->setIcon(QIcon(":/images/config.svg"));
    QAction * helpAction = new QAction(trUtf8("Справка"), this);
    helpAction->setIcon(QIcon(":/images/help.svg"));
    QAction * aboutAction = new QAction(trUtf8("О приложении"), this);
    aboutAction->setIcon(QIcon(":/images/about.svg"));
    QAction * viewWindow = new QAction(trUtf8("Показать"), this);
    QAction * quitAction = new QAction(trUtf8("Выход"), this);

    connect(configAction, &QAction::triggered, this, &SystemTray::signalConfig);
    connect(helpAction, &QAction::triggered, this, &SystemTray::signalHelp);
    connect(aboutAction, &QAction::triggered, this, &SystemTray::signalAbout);
    connect(viewWindow, &QAction::triggered, this, &SystemTray::signalShow);
    connect(quitAction, &QAction::triggered, this, &SystemTray::signalQuit);

    trayIconMenu->addAction(viewWindow);
    trayIconMenu->addSeparator();
    trayIconMenu->addAction(configAction);
    trayIconMenu->addSeparator();
    trayIconMenu->addAction(helpAction);
    trayIconMenu->addAction(aboutAction);
    trayIconMenu->addSeparator();
    trayIconMenu->addAction(quitAction);

    trayIcon = new QSystemTrayIcon();
    trayIcon->setContextMenu(trayIconMenu);
    trayIcon->setIcon(QIcon(":/favicons/favicon.ico"));
    trayIcon->show();
    trayIcon->setToolTip("- ОПОВЕЩЕНИЕ -");

    connect(trayIcon, trayIcon->messageClicked, this, &SystemTray::signalShow);
    connect(trayIcon, SIGNAL(activated(QSystemTrayIcon::ActivationReason)),
            this, SLOT(iconActivated(QSystemTrayIcon::ActivationReason)));
#endif
}

void SystemTray::iconActivated(QSystemTrayIcon::ActivationReason reason)
{
#ifdef Q_OS_WIN
    switch (reason){
    case QSystemTrayIcon::Trigger:
        emit signalIconActivated();
        break;
    default:
        break;
    }
#endif
}

void SystemTray::showMessage(QString title, QString message)
{
#ifdef Q_OS_WIN
    trayIcon->showMessage(title, message);
#endif
}

void SystemTray::hideIconTray()
{
#ifdef Q_OS_WIN
    trayIcon->hide();
#endif
}
