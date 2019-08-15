#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <memory>

class AgoraRtcEngine;
class QQuickWidget;

class MainWindow : public QWidget
{
    Q_OBJECT
public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
    Q_INVOKABLE void openDeviceSettings();
public slots:
    void joiningChannel();
    void leavingChannel();
private:
    QQuickWidget* m_contentView;
    std::unique_ptr<AgoraRtcEngine> m_engine;
};

#endif // MAINWINDOW_H
