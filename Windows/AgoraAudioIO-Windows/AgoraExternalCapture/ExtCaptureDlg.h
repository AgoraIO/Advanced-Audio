#pragma once
#include "AGComboBox.h"
#include "AGButton.h"

#include "ExtendAudioFrameObserver.h"
#include "StreamingVoiceContext.h"
#include "AGDShowAudioCapture.h"
#include "afxwin.h"

// CExtCaptureDlg �Ի���

typedef struct _PUSHAUDIO_THREAD_PARAM
{

	HANDLE		hExitEvent;

} PUSHAUDIODATA_THREAD_PARAM, *PPUSHAUDIODATA_THREAD_PARAM, *LPPUSHAUDIODATA_THREAD_PARAM;

typedef struct _PLAYOUT_THREAD_PARAM
{
	HANDLE		hExitEvent;

	IXAudio2VoiceCallback	*lpXAudioVoiceContext;
	IXAudio2SourceVoice		*lpXAudioSourceVoice;

} PLAYOUT_THREAD_PARAM, *PPLAYOUT_THREAD_PARAM, *LPPLAYOUT_THREAD_PARAM;


class CExtCaptureDlg : public CDialogEx
{
	DECLARE_DYNAMIC(CExtCaptureDlg)

public:
	CExtCaptureDlg(CWnd* pParent = NULL);   // ��׼���캯��
	virtual ~CExtCaptureDlg();

	// �Ի�������
	enum { IDD = IDD_EXTCAP_DIALOG };

	BOOL VideoCaptureControl(BOOL bStart);
	BOOL AudioCaptureControl(BOOL bStart);

	BOOL IsExtVideoCapEnabled() const { return m_ckExtVideoCapture.GetCheck(); };
	BOOL IsExtAudioCapEnabled() const { return m_ckExtAudioCapture.GetCheck(); };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV ֧��
	virtual BOOL OnInitDialog();

	afx_msg void OnPaint();

	afx_msg void OnBnClickedBtncancelExtcap();
	afx_msg void OnBnClickedBtnconfirmExtcap();
	afx_msg void OnBnClickedBtnapplyExtcap();

	afx_msg void OnCmbselCameraDevice();
	afx_msg void OnCmbselCameraCapability();

	afx_msg void OnCmbselMicroDevice();
	afx_msg void OnCmbselMicroCapability();

	afx_msg void OnCmbselPlayoutDevice();

	afx_msg void OnShowWindow(BOOL bShow, UINT nStatus);

	DECLARE_MESSAGE_MAP()

protected:
	void InitCtrls();
	void DrawClient(CDC *lpDC);

private:
	CAGComboBox     m_cmbCamera;
	CAGComboBox     m_cmbCamCap;

	CAGComboBox		m_cmbMicrophone;
	CAGComboBox		m_cmbMicCap;

	CAGComboBox		m_cmbPlayout;

	CAGButton		m_btnCancel;
	CAGButton		m_btnConfirm;
	CAGButton		m_btnApply;

	CButton			m_ckExtVideoCapture;
	CButton			m_ckExtAudioCapture;
	CButton			m_ckExtPushAudio;

	CFont			m_ftDes;
	CFont			m_ftHead;
	CPen            m_penFrame;

private:
	
	CAGDShowAudioCapture	m_agAudioCaptureDevice;
	
	//CXAudioPlayout			m_agXAudioPlayoutDevice;
	CExtendAudioFrameObserver	m_exCapAudioFrameObserver;
	StreamingVoiceContext		m_exCapVoiceContext;

	HANDLE						m_hExitPlayEvent;
	PLAYOUT_THREAD_PARAM		m_playThreadParam;

	HANDLE						m_hExitPushAudioEvent;
	PUSHAUDIODATA_THREAD_PARAM	m_pushAudioThreadParam;

private:
	static UINT PlayoutThread(LPVOID lParam);
	static UINT PushAudioDataThread(LPVOID lParam);
};
