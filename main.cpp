#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSystemTrayIcon>
#include "goechoapp.h"
#include "systemtray.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setOrganizationName("GoEcho");
    app.setOrganizationDomain("goecho.domain");
    app.setApplicationName("GoEcho");

    app.setWindowIcon(QIcon(":/favicons/favicon.ico"));

    QQmlApplicationEngine engine;
    GoEchoApp goeApp;
    SystemTray *systemTray = new SystemTray();
    engine.rootContext()->setContextProperty("goeApp", &goeApp);
    engine.rootContext()->setContextProperty("systemTray", systemTray);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
