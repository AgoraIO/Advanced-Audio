#include "mainwindow.h"
#include "agorartcengine.h"
#include <QtQuickWidgets/QQuickWidget>
#include <QQmlContext>
#include <QVBoxLayout>
#include <QApplication>
#include <QDesktopWidget>

MainWindow::MainWindow(QWidget *parent)
    :QWidget(parent)
    ,m_engine(new AgoraRtcEngine(this))
{
    setWindowFlags(Qt::Window | Qt::FramelessWindowHint);
    resize(800, 600);

    AgoraRtcEngine* engine = m_engine.get();
    connect(engine, SIGNAL(joiningChannel()), this, SLOT(joiningChannel()));
    connect(engine, SIGNAL(leavingChannel()), this, SLOT(leavingChannel()));

    m_contentView = new QQuickWidget(this);
    m_contentView->rootContext()->setContextProperty("agoraRtcEngine", engine);
    m_contentView->rootContext()->setContextProperty("containerWindow", this);
    m_contentView->setResizeMode(QQuickWidget::SizeRootObjectToView);
    m_contentView->setSource(QUrl("qrc:///main.qml"));

    QVBoxLayout *layout = new QVBoxLayout;
    layout->setContentsMargins(0, 0, 0, 0);
    layout->setSpacing(0);
    layout->addWidget(m_contentView);

    setLayout(layout);
}

MainWindow::~MainWindow()
{
	if (m_contentView)
	{
		delete m_contentView;
		m_contentView = NULL;
	}
	
}

void MainWindow::joiningChannel()
{
    QRect rec = QApplication::desktop()->screenGeometry();
    int w = rec.width();
    int h = rec.height();
    resize(800, 600);
}

void MainWindow::leavingChannel()
{
    resize(800, 600);
}

void MainWindow::openDeviceSettings()
{
    QQuickWidget* form = new QQuickWidget(this);
    form->setAttribute(Qt::WA_DeleteOnClose);
    form->setWindowFlags(Qt::Window | Qt::FramelessWindowHint);
    form->setFixedSize(512, 640);
    form->rootContext()->setContextProperty("agoraRtcEngine", m_engine.get());
    form->rootContext()->setContextProperty("mainWindow", form);
    form->setResizeMode(QQuickWidget::SizeRootObjectToView);
    form->setSource(QUrl("qrc:///DeviceSettings.qml"));

    form->show();
}
