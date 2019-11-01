// ExtCaptureDlg.cpp : ʵ���ļ�
//

#include "stdafx.h"
#include "AgoraExternalCapture.h"
#include "ExtCaptureDlg.h"
#include "afxdialogex.h"


// CExtCaptureDlg �Ի���

IMPLEMENT_DYNAMIC(CExtCaptureDlg, CDialogEx)

CExtCaptureDlg::CExtCaptureDlg(CWnd* pParent /*=NULL*/)
: CDialogEx(CExtCaptureDlg::IDD, pParent)
{
	m_hExitPlayEvent = ::CreateEvent(NULL, NULL, FALSE, NULL);

	m_hExitPushAudioEvent = ::CreateEvent(NULL, NULL, FALSE, NULL);
}

CExtCaptureDlg::~CExtCaptureDlg()
{
	::CloseHandle(m_hExitPlayEvent);

	::CloseHandle(m_hExitPushAudioEvent);
}

void CExtCaptureDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);

	DDX_Control(pDX, IDC_BTNCANCEL_EXTCAP, m_btnCancel);
	DDX_Control(pDX, IDC_BTNCONFIRM_EXTCAP, m_btnConfirm);
	DDX_Control(pDX, IDC_BTNAPPLY_EXTCAP, m_btnApply);
	DDX_Control(pDX, IDC_CKVIDEOCAP_EXTCAP, m_ckExtVideoCapture);
	DDX_Control(pDX, IDC_CKAUDIOCAP_EXTCAP, m_ckExtAudioCapture);

	DDX_Control(pDX, IDC_CKAUDIOPUSH_EXTCAP, m_ckExtPushAudio);
}


BEGIN_MESSAGE_MAP(CExtCaptureDlg, CDialogEx)
	ON_BN_CLICKED(IDC_BTNCANCEL_EXTCAP, &CExtCaptureDlg::OnBnClickedBtncancelExtcap)
	ON_BN_CLICKED(IDC_BTNCONFIRM_EXTCAP, &CExtCaptureDlg::OnBnClickedBtnconfirmExtcap)
	ON_BN_CLICKED(IDC_BTNAPPLY_EXTCAP, &CExtCaptureDlg::OnBnClickedBtnapplyExtcap)

	ON_CBN_SELCHANGE(IDC_CMBCAM_EXTCAP, &CExtCaptureDlg::OnCmbselCameraDevice)
	ON_CBN_SELCHANGE(IDC_CMBCAMCAP_EXTCAP, &CExtCaptureDlg::OnCmbselCameraCapability)

	ON_CBN_SELCHANGE(IDC_CMBMICR_EXTCAP, &CExtCaptureDlg::OnCmbselMicroDevice)
	ON_CBN_SELCHANGE(IDC_CMBMICRCAP_EXTCAP, &CExtCaptureDlg::OnCmbselMicroCapability)

	ON_CBN_SELCHANGE(IDC_CMBPLAYOUT_EXTCAP, &CExtCaptureDlg::OnCmbselPlayoutDevice)
	ON_WM_PAINT()
	ON_WM_SHOWWINDOW()
END_MESSAGE_MAP()


// CExtCaptureDlg ��Ϣ�������
void CExtCaptureDlg::OnPaint()
{
	CPaintDC dc(this);

	DrawClient(&dc);
}

BOOL CExtCaptureDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// TODO:  �ڴ���Ӷ���ĳ�ʼ��
	m_ftDes.CreateFont(15, 0, 0, 0, FW_NORMAL, FALSE, FALSE, 0, ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH | FF_SWISS, _T("Arial"));
	m_ftHead.CreateFont(15, 0, 0, 0, FW_NORMAL, FALSE, FALSE, 0, ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH | FF_SWISS, _T("Arial"));

	m_cmbCamera.Create(WS_CHILD | WS_VISIBLE, CRect(0, 0, 300, 40), this, IDC_CMBCAM_EXTCAP);
	m_cmbCamCap.Create(WS_CHILD | WS_VISIBLE, CRect(0, 0, 300, 40), this, IDC_CMBCAMCAP_EXTCAP);

	m_cmbMicrophone.Create(WS_CHILD | WS_VISIBLE, CRect(0, 0, 300, 40), this, IDC_CMBMICR_EXTCAP);
	m_cmbMicCap.Create(WS_CHILD | WS_VISIBLE, CRect(0, 0, 300, 40), this, IDC_CMBMICRCAP_EXTCAP);

	m_cmbPlayout.Create(WS_CHILD | WS_VISIBLE, CRect(0, 0, 300, 40), this, IDC_CMBPLAYOUT_EXTCAP);

	m_penFrame.CreatePen(PS_SOLID, 1, RGB(0xD8, 0xD8, 0xD8));

	m_agAudioCaptureDevice.Create();
	m_agVideoCaptureDevice.Create();
	m_agXAudioPlayoutDevice.Create();

	SetBackgroundColor(RGB(0xFE, 0xFE, 0xFE));

	InitCtrls();

	return TRUE;  // return TRUE unless you set the focus to a control
	// �쳣:  OCX ����ҳӦ���� FALSE
}

void CExtCaptureDlg::InitCtrls()
{
	CRect ClientRect;

	GetClientRect(&ClientRect);

	m_cmbCamera.MoveWindow(70, 60, 170, 22, TRUE);
	m_cmbCamera.SetFont(&m_ftHead);
	m_cmbCamera.SetButtonImage(IDB_CMBBTN, 12, 12, RGB(0xFF, 0x00, 0xFF));
	m_cmbCamera.SetFaceColor(RGB(0xFF, 0xFF, 0xFF), RGB(0xFF, 0xFF, 0xFF));

	m_cmbCamCap.MoveWindow(240, 60, 170, 22, TRUE);
	m_cmbCamCap.SetFont(&m_ftHead);
	m_cmbCamCap.SetButtonImage(IDB_CMBBTN, 12, 12, RGB(0xFF, 0x00, 0xFF));
	m_cmbCamCap.SetFaceColor(RGB(0xFF, 0xFF, 0xFF), RGB(0xFF, 0xFF, 0xFF));

	m_ckExtVideoCapture.MoveWindow(100, 105, 200, 24);

	m_cmbMicrophone.MoveWindow(70, 180, 170, 22, TRUE);
	m_cmbMicrophone.SetFont(&m_ftHead);
	m_cmbMicrophone.SetButtonImage(IDB_CMBBTN, 12, 12, RGB(0xFF, 0x00, 0xFF));
	m_cmbMicrophone.SetFaceColor(RGB(0xFF, 0xFF, 0xFF), RGB(0xFF, 0xFF, 0xFF));

	m_cmbMicCap.MoveWindow(240, 180, 170, 22, TRUE);
	m_cmbMicCap.SetFont(&m_ftHead);
	m_cmbMicCap.SetButtonImage(IDB_CMBBTN, 12, 12, RGB(0xFF, 0x00, 0xFF));
	m_cmbMicCap.SetFaceColor(RGB(0xFF, 0xFF, 0xFF), RGB(0xFF, 0xFF, 0xFF));

	m_cmbPlayout.MoveWindow(70, 250, 300, 22, TRUE);
	m_cmbPlayout.SetFont(&m_ftHead);
	m_cmbPlayout.SetButtonImage(IDB_CMBBTN, 12, 12, RGB(0xFF, 0x00, 0xFF));
	m_cmbPlayout.SetFaceColor(RGB(0xFF, 0xFF, 0xFF), RGB(0xFF, 0xFF, 0xFF));

	m_ckExtAudioCapture.MoveWindow(100, 295, 200, 24);
	m_ckExtPushAudio.MoveWindow(100, 327, 200, 24);

	m_btnCancel.MoveWindow(46, 350, 120, 36, TRUE);
	m_btnCancel.EnableRoundCorner(TRUE);

	m_btnConfirm.MoveWindow(199, 350, 120, 36, TRUE);
	m_btnConfirm.EnableRoundCorner(TRUE);

	m_btnApply.MoveWindow(346, 350, 120, 36, TRUE);
	m_btnApply.EnableRoundCorner(TRUE);
}

void CExtCaptureDlg::DrawClient(CDC *lpDC)
{
	CRect	rcText;
	CRect	rcClient;

	GetClientRect(&rcClient);

	lpDC->SelectObject(&m_penFrame);
	rcText.SetRect(54, 55, 426, 87);
	lpDC->RoundRect(&rcText, CPoint(32, 32));

	rcText.OffsetRect(0, 120);
	lpDC->RoundRect(&rcText, CPoint(32, 32));

	rcText.OffsetRect(0, 70);
	lpDC->RoundRect(&rcText, CPoint(32, 32));
}

void CExtCaptureDlg::OnBnClickedBtncancelExtcap()
{
	// TODO:  �ڴ���ӿؼ�֪ͨ����������

	CDialogEx::OnCancel();
}


void CExtCaptureDlg::OnBnClickedBtnconfirmExtcap()
{
	// TODO:  �ڴ���ӿؼ�֪ͨ����������
	VIDEOINFOHEADER videoInfo;
	WAVEFORMATEX	waveFormat;
	SIZE_T			nBufferSize = 0;

	CAgoraObject	*lpAgoraObject = CAgoraObject::GetAgoraObject();

	int nCamCapSel = m_cmbCamCap.GetCurSel();
	if (nCamCapSel == -1) {
		m_cmbCamCap.SetCurSel(0);
		nCamCapSel = 0;
	}

	int nMicCapSel = m_cmbMicCap.GetCurSel();
	if (nMicCapSel == -1) {
		m_cmbMicCap.SetCurSel(0);
		nMicCapSel = 0;
	}

	if (m_ckExtVideoCapture.GetCheck()) {
		m_agVideoCaptureDevice.SelectMediaCap(nCamCapSel);
		m_agVideoCaptureDevice.GetCurrentVideoCap(&videoInfo);
		m_agVideoCaptureDevice.SetCaptureBuffer(videoInfo.bmiHeader.biSizeImage, 30, 4);
		m_agVideoCaptureDevice.SetGrabberCallback(&m_agVideoCapture, 1);
		CVideoPackageQueue::GetInstance()->SetVideoFormat(&videoInfo.bmiHeader);

		lpAgoraObject->SetVideoProfileEx(videoInfo.bmiHeader.biWidth, videoInfo.bmiHeader.biHeight, static_cast<int>(10000000 / videoInfo.AvgTimePerFrame), 1000);
	}

	if (m_ckExtAudioCapture.GetCheck()) {
		m_agAudioCaptureDevice.SelectMediaCap(nMicCapSel);
		m_agAudioCaptureDevice.GetCurrentAudioCap(&waveFormat);
		nBufferSize = waveFormat.nAvgBytesPerSec / 100;

		m_agAudioCaptureDevice.SetCaptureBuffer(nBufferSize, 16, waveFormat.nBlockAlign);
		m_agAudioCaptureDevice.SetGrabberCallback(&m_agAudioCapture, 1);
		CAudioCapturePackageQueue::GetInstance()->SetAudioFormat(&waveFormat);
		CAudioCapturePackageQueue::GetInstance()->SetAudioPackageSize(nBufferSize);

		CAudioPlayPackageQueue::GetInstance()->SetAudioFormat(&waveFormat);
		CAudioPlayPackageQueue::GetInstance()->SetAudioPackageSize(nBufferSize);

		lpAgoraObject->SetAudioProfileEx(waveFormat.nSamplesPerSec, waveFormat.nChannels, waveFormat.nSamplesPerSec*waveFormat.nChannels / 100);
		m_agXAudioPlayoutDevice.SetAudioFormat(&waveFormat, &m_exCapVoiceContext);

		if (!m_ckExtPushAudio.GetCheck())
			lpAgoraObject->EnableExtendAudioCapture(TRUE, &m_exCapAudioFrameObserver);
	}

	CDialogEx::OnOK();
}


void CExtCaptureDlg::OnBnClickedBtnapplyExtcap()
{
	// TODO:  �ڴ���ӿؼ�֪ͨ����������
	VIDEOINFOHEADER videoInfo;
	WAVEFORMATEX	waveFormat;
	SIZE_T			nBufferSize = 0;

	CAgoraObject	*lpAgoraObject = CAgoraObject::GetAgoraObject();

	int nCamCapSel = m_cmbCamCap.GetCurSel();
	if (nCamCapSel == -1) {
		m_cmbCamCap.SetCurSel(0);
		nCamCapSel = 0;
	}

	int nMicCapSel = m_cmbMicCap.GetCurSel();
	if (nMicCapSel == -1) {
		m_cmbMicCap.SetCurSel(0);
		nMicCapSel = 0;
	}

	if (m_ckExtVideoCapture.GetCheck()) {
		m_agVideoCaptureDevice.SelectMediaCap(nCamCapSel);
		m_agVideoCaptureDevice.GetCurrentVideoCap(&videoInfo);
		//		nBufferSize = 3 * videoInfo.bmiHeader.biHeight*videoInfo.bmiHeader.biWidth;
		m_agVideoCaptureDevice.SetCaptureBuffer(videoInfo.bmiHeader.biSizeImage, 30, 4);
		m_agVideoCaptureDevice.SetGrabberCallback(&m_agVideoCapture, 1);
		CVideoPackageQueue::GetInstance()->SetVideoFormat(&videoInfo.bmiHeader);

		lpAgoraObject->SetVideoProfileEx(videoInfo.bmiHeader.biWidth, videoInfo.bmiHeader.biHeight, static_cast<int>(10000000 / videoInfo.AvgTimePerFrame), 1000);

	}

	if (m_ckExtAudioCapture.GetCheck()) {
		m_agAudioCaptureDevice.SelectMediaCap(nMicCapSel);
		m_agAudioCaptureDevice.GetCurrentAudioCap(&waveFormat);
		nBufferSize = waveFormat.nAvgBytesPerSec / 100;
		m_agAudioCaptureDevice.SetCaptureBuffer(nBufferSize, 16, waveFormat.nBlockAlign);
		m_agAudioCaptureDevice.SetGrabberCallback(&m_agAudioCapture, 1);
		CAudioCapturePackageQueue::GetInstance()->SetAudioFormat(&waveFormat);
		CAudioCapturePackageQueue::GetInstance()->SetAudioPackageSize(nBufferSize);

		CAudioPlayPackageQueue::GetInstance()->SetAudioFormat(&waveFormat);
		CAudioPlayPackageQueue::GetInstance()->SetAudioPackageSize(nBufferSize);
		lpAgoraObject->SetAudioProfileEx(waveFormat.nSamplesPerSec, waveFormat.nChannels, waveFormat.nSamplesPerSec*waveFormat.nChannels / 100);

		m_agXAudioPlayoutDevice.SetAudioFormat(&waveFormat, &m_exCapVoiceContext);

		if (!m_ckExtPushAudio.GetCheck())
			lpAgoraObject->EnableExtendAudioCapture(TRUE, &m_exCapAudioFrameObserver);
	}

}

void CExtCaptureDlg::OnCmbselCameraDevice()
{
	TCHAR	szDevicePath[MAX_PATH];
	SIZE_T	nPathLen = MAX_PATH;
	int		nSel = m_cmbCamera.GetCurSel();

	VIDEOINFOHEADER		vidInfoHeader;
	CString				strInfo;
	CString				strCompress;

	BOOL bSuccess = m_agVideoCaptureDevice.GetCurrentDevice(szDevicePath, &nPathLen);
	if (bSuccess)
		m_agVideoCaptureDevice.CloseDevice();

	if (nSel != -1) {
		m_agVideoCaptureDevice.OpenDevice(nSel);
		m_agVideoCaptureDevice.SetCaptureBuffer(0x1950000, 30, 4);
	}

	m_cmbCamCap.ResetContent();
	for (int nIndex = 0; nIndex < m_agVideoCaptureDevice.GetMediaCapCount(); nIndex++) {
		m_agVideoCaptureDevice.GetVideoCap(nIndex, &vidInfoHeader);

		switch (vidInfoHeader.bmiHeader.biCompression)
		{
		case 0x00000000:
			strInfo.Format(_T("%d*%d %dfps(RGB24)"), vidInfoHeader.bmiHeader.biWidth, vidInfoHeader.bmiHeader.biHeight, 10000000 / vidInfoHeader.AvgTimePerFrame);
			break;
		case MAKEFOURCC('I', '4', '2', '0'):
			strInfo.Format(_T("%d*%d %dfps(YUV420)"), vidInfoHeader.bmiHeader.biWidth, vidInfoHeader.bmiHeader.biHeight, 10000000 / vidInfoHeader.AvgTimePerFrame);
			break;
		case MAKEFOURCC('Y', 'U', 'Y', '2'):
			strInfo.Format(_T("%d*%d %dfps(YUY2)"), vidInfoHeader.bmiHeader.biWidth, vidInfoHeader.bmiHeader.biHeight, 10000000 / vidInfoHeader.AvgTimePerFrame);
			break;
		case MAKEFOURCC('M', 'J', 'P', 'G'):
			strInfo.Format(_T("%d*%d %dfps(MJPEG)"), vidInfoHeader.bmiHeader.biWidth, vidInfoHeader.bmiHeader.biHeight, 10000000 / vidInfoHeader.AvgTimePerFrame);
			break;
		case MAKEFOURCC('U', 'Y', 'V', 'Y'):
			strInfo.Format(_T("%d*%d %dfps(UYVY)"), vidInfoHeader.bmiHeader.biWidth, vidInfoHeader.bmiHeader.biHeight, 10000000 / vidInfoHeader.AvgTimePerFrame);
			break;
		}

		m_cmbCamCap.InsertString(nIndex, strInfo);
	}
}

void CExtCaptureDlg::OnCmbselCameraCapability()
{
	int nCurSel = m_cmbCamCap.GetCurSel();
	if (nCurSel == -1)
		return;

	m_agVideoCaptureDevice.SelectMediaCap(nCurSel);
}

void CExtCaptureDlg::OnCmbselMicroDevice()
{
	TCHAR	szDevicePath[MAX_PATH];
	SIZE_T	nPathLen = MAX_PATH;
	int		nSel = m_cmbMicrophone.GetCurSel();

	WAVEFORMATEX		wavFormatEx;
	CString				strInfo;

	BOOL bSuccess = m_agAudioCaptureDevice.GetCurrentDevice(szDevicePath, &nPathLen);
	if (bSuccess)
		m_agAudioCaptureDevice.CloseDevice();

	if (nSel != -1)
		m_agAudioCaptureDevice.OpenDevice(nSel);

	m_cmbMicCap.ResetContent();
	for (int nIndex = 0; nIndex < m_agAudioCaptureDevice.GetMediaCapCount(); nIndex++) {
		m_agAudioCaptureDevice.GetAudioCap(nIndex, &wavFormatEx);
		strInfo.Format(_T("%.1fkHz %dbits %dCh"), wavFormatEx.nSamplesPerSec / 1000.0, wavFormatEx.wBitsPerSample, wavFormatEx.nChannels);
		m_cmbMicCap.InsertString(nIndex, strInfo);
	}
}

void CExtCaptureDlg::OnCmbselMicroCapability()
{
	int nCurSel = m_cmbMicCap.GetCurSel();
	if (nCurSel == -1)
		return;

	m_agAudioCaptureDevice.SelectMediaCap(nCurSel);
}

void CExtCaptureDlg::OnCmbselPlayoutDevice()
{
	SIZE_T	nPathLen = MAX_PATH;
	int		nSel = m_cmbPlayout.GetCurSel();

	CString				strInfo;
	CString				strCompress;

	m_agXAudioPlayoutDevice.CloseDevice();

	if (nSel != -1)
		m_agXAudioPlayoutDevice.OpenDevice(nSel);

}

void CExtCaptureDlg::OnShowWindow(BOOL bShow, UINT nStatus)
{
	CDialogEx::OnShowWindow(bShow, nStatus);

	// TODO:  �ڴ˴������Ϣ����������
	if (!bShow)
		return;

	TCHAR				szDevicePath[MAX_PATH];
	SIZE_T				nPathLen = MAX_PATH;
	CString				strInfo;
	AGORA_DEVICE_INFO	agDeviceInfo;

	nPathLen = MAX_PATH;
	m_cmbCamera.ResetContent();
	if (m_agVideoCaptureDevice.EnumDeviceList())
	{
		m_agVideoCaptureDevice.GetCurrentDevice(szDevicePath, &nPathLen);
		for (int nIndex = 0; nIndex < m_agVideoCaptureDevice.GetDeviceCount(); nIndex++) {
			m_agVideoCaptureDevice.GetDeviceInfo(nIndex, &agDeviceInfo);
			m_cmbCamera.InsertString(nIndex, agDeviceInfo.szDeviceName);

			if (_tcscmp(szDevicePath, agDeviceInfo.szDevicePath) == 0)
				m_cmbCamera.SetCurSel(nIndex);
		}
	}


	nPathLen = MAX_PATH;
	m_cmbMicrophone.ResetContent();

	if (m_agAudioCaptureDevice.EnumDeviceList())
	{
		m_agAudioCaptureDevice.GetCurrentDevice(szDevicePath, &nPathLen);
		for (int nIndex = 0; nIndex < m_agAudioCaptureDevice.GetDeviceCount(); nIndex++) {
			m_agAudioCaptureDevice.GetDeviceInfo(nIndex, &agDeviceInfo);
			m_cmbMicrophone.InsertString(nIndex, agDeviceInfo.szDeviceName);

			if (_tcscmp(szDevicePath, agDeviceInfo.szDevicePath) == 0)
				m_cmbMicrophone.SetCurSel(nIndex);
		}
	}

	nPathLen = MAX_PATH;
	m_cmbPlayout.ResetContent();

	if (m_agXAudioPlayoutDevice.EnumDeviceList())
	{
		m_agXAudioPlayoutDevice.GetCurrentDevice(szDevicePath, &nPathLen);
		for (int nIndex = 0; nIndex < m_agXAudioPlayoutDevice.GetDeviceCount(); nIndex++) {
			m_agXAudioPlayoutDevice.GetDeviceInfo(nIndex, &agDeviceInfo);
			m_cmbPlayout.InsertString(nIndex, agDeviceInfo.szDeviceName);

			if (_tcscmp(szDevicePath, agDeviceInfo.szDevicePath) == 0)
				m_cmbPlayout.SetCurSel(nIndex);
		}
	
	}
}

BOOL CExtCaptureDlg::VideoCaptureControl(BOOL bStart)
{
	if (!m_ckExtVideoCapture.GetCheck())
		return TRUE;

	if (bStart) {
		CAgoraObject::GetAgoraObject()->EnableExtendVideoCapture(TRUE, &m_exCapVideoFrameObserver);
		return m_agVideoCaptureDevice.CaptureControl(DEVICE_START);
	}
	else {
		CAgoraObject::GetAgoraObject()->EnableExtendVideoCapture(FALSE, NULL);
		return m_agVideoCaptureDevice.CaptureControl(DEVICE_STOP);
	}
}

BOOL CExtCaptureDlg::AudioCaptureControl(BOOL bStart)
{
	if (!m_ckExtAudioCapture.GetCheck())
		return TRUE;

	BOOL bPushMode = m_ckExtPushAudio.GetCheck();
	CAgoraObject *lpAgoraObject = CAgoraObject::GetAgoraObject();
	WAVEFORMATEX waveFormatEx;

	m_agAudioCaptureDevice.GetCurrentAudioCap(&waveFormatEx);


	if (bStart) {
		
		if (!bPushMode) {	
			
			m_playThreadParam.lpXAudioSourceVoice = m_agXAudioPlayoutDevice.GetSourceVoicePtr();
			m_playThreadParam.lpXAudioVoiceContext = &m_exCapVoiceContext;

			AfxBeginThread(&CExtCaptureDlg::PlayoutThread, &m_playThreadParam);
		}
		else {
			lpAgoraObject->SetExternalAudioSource(TRUE, waveFormatEx.nSamplesPerSec, waveFormatEx.nChannels);
			m_pushAudioThreadParam.hExitEvent = m_hExitPushAudioEvent;
			AfxBeginThread(&CExtCaptureDlg::PushAudioDataThread, &m_pushAudioThreadParam);
		}

		return m_agAudioCaptureDevice.CaptureControl(DEVICE_START);
	}
	else {
		if (!bPushMode) {
			lpAgoraObject->EnableExtendAudioCapture(FALSE, NULL);
			::SetEvent(m_hExitPlayEvent);
		}
		else {
			lpAgoraObject->SetExternalAudioSource(FALSE, waveFormatEx.nSamplesPerSec, waveFormatEx.nChannels);
			::SetEvent(m_hExitPushAudioEvent);
		}

		return m_agAudioCaptureDevice.CaptureControl(DEVICE_STOP);
	}
}

UINT CExtCaptureDlg::PlayoutThread(LPVOID lParam)
{
	LPPLAYOUT_THREAD_PARAM lpParam = reinterpret_cast<LPPLAYOUT_THREAD_PARAM>(lParam);

	StreamingVoiceContext	*lpXAudioVoiceContext = reinterpret_cast<StreamingVoiceContext *>(lpParam->lpXAudioVoiceContext);
	IXAudio2SourceVoice		*lpXAudioSoruceVoice = reinterpret_cast<IXAudio2SourceVoice *>(lpParam->lpXAudioSourceVoice);

	CAudioPlayPackageQueue	*lpBufferQueue = CAudioPlayPackageQueue::GetInstance();

	XAUDIO2_BUFFER	xAudioBuffer;
	LPBYTE			lpAudioData = new BYTE[8192];
	SIZE_T			nAudioBufferSize = 8192;

	do {
		if (::WaitForSingleObject(lpParam->hExitEvent, 0) == WAIT_OBJECT_0)
			break;

		nAudioBufferSize = 8192;

		if (!lpBufferQueue->PopAudioPackage(lpAudioData, &nAudioBufferSize))
			continue;

		memset(&xAudioBuffer, 0, sizeof(XAUDIO2_BUFFER));
		xAudioBuffer.AudioBytes = nAudioBufferSize;
		xAudioBuffer.pAudioData = lpAudioData;
		lpXAudioSoruceVoice->SubmitSourceBuffer(&xAudioBuffer);
		::WaitForSingleObject(lpXAudioVoiceContext->hBufferEndEvent, INFINITE);

	} while (TRUE);

	delete[] lpAudioData;

	return 0;
}

UINT CExtCaptureDlg::PushAudioDataThread(LPVOID lParam)
{
	LPBYTE			lpAudioData = new BYTE[8192];
	SIZE_T			nAudioBufferSize = 8192;
	WAVEFORMATEX	waveFormatEx;

	LPPUSHAUDIODATA_THREAD_PARAM lpParam = reinterpret_cast<LPPUSHAUDIODATA_THREAD_PARAM>(lParam);
	CAudioCapturePackageQueue *lpBufferQueue = CAudioCapturePackageQueue::GetInstance();

	agora::util::AutoPtr<agora::media::IMediaEngine> mediaEngine;
	mediaEngine.queryInterface(CAgoraObject::GetEngine(), agora::AGORA_IID_MEDIA_ENGINE);
	IAudioFrameObserver::AudioFrame frame;

	lpBufferQueue->GetAudioFormat(&waveFormatEx);
	frame.bytesPerSample = waveFormatEx.wBitsPerSample / 8;
	frame.channels = waveFormatEx.nChannels;
	frame.renderTimeMs = 10;
	frame.samples = waveFormatEx.nSamplesPerSec / 100;
	frame.samplesPerSec = waveFormatEx.nSamplesPerSec;
	frame.type = IAudioFrameObserver::AUDIO_FRAME_TYPE::FRAME_TYPE_PCM16;

	do {
		if (::WaitForSingleObject(lpParam->hExitEvent, 0) == WAIT_OBJECT_0)
			break;

		nAudioBufferSize = 8192;

		if (!lpBufferQueue->PopAudioPackage(lpAudioData, &nAudioBufferSize))
			continue;

		frame.buffer = lpAudioData;

		mediaEngine->pushAudioFrame(MEDIA_SOURCE_TYPE::AUDIO_RECORDING_SOURCE, &frame, true);

	} while (TRUE);

	delete[] lpAudioData;

	return 0;
}
