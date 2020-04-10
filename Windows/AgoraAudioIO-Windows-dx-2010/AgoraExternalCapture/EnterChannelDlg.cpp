// EnterChannelDlg.cpp : ʵ���ļ�
//

#include "stdafx.h"
#include "AgoraExternalCapture.h"
#include "EnterChannelDlg.h"


#include "afxdialogex.h"


// CEnterChannelDlg �Ի���

IMPLEMENT_DYNAMIC(CEnterChannelDlg, CDialogEx)

CEnterChannelDlg::CEnterChannelDlg(CWnd* pParent /*=NULL*/)
	: CDialogEx(CEnterChannelDlg::IDD, pParent)
{

}

CEnterChannelDlg::~CEnterChannelDlg()
{
}

void CEnterChannelDlg::DoDataExchange(CDataExchange* pDX)
{
    CDialogEx::DoDataExchange(pDX);
    DDX_Control(pDX, IDC_EDCHNAME_CHANNEL, m_ctrChannel);
    DDX_Control(pDX, IDC_EDENCKEY_CHANNEL, m_ctrEncKey);
    DDX_Control(pDX, IDC_BTNTEST_CHANNEL, m_btnTest);
    DDX_Control(pDX, IDC_BTNJOIN_CHANNEL, m_btnJoin);
    DDX_Control(pDX, IDC_BTNSET_CHANNEL, m_btnSetup);
	DDX_Control(pDX, IDC_BTNEXTCAP_CHANNEL, m_btnExtCapture);
}


BEGIN_MESSAGE_MAP(CEnterChannelDlg, CDialogEx)
	ON_WM_NCHITTEST()
	ON_WM_PAINT()
	ON_BN_CLICKED(IDC_BTNTEST_CHANNEL, &CEnterChannelDlg::OnBnClickedBtntestChannel)
	ON_BN_CLICKED(IDC_BTNJOIN_CHANNEL, &CEnterChannelDlg::OnBnClickedBtnjoinChannel)
	ON_BN_CLICKED(IDC_BTNSET_CHANNEL, &CEnterChannelDlg::OnBnClickedBtnsetChannel)
	ON_BN_CLICKED(IDC_BTNEXTCAP_CHANNEL, &CEnterChannelDlg::OnBnClickedBtnextcapChannel)
END_MESSAGE_MAP()


// CEnterChannelDlg ��Ϣ�������
BOOL CEnterChannelDlg::PreTranslateMessage(MSG* pMsg)
{
	if (pMsg->message == WM_KEYDOWN){
		switch (pMsg->wParam){
		case VK_ESCAPE:
			return FALSE;
		case VK_RETURN:
			OnBnClickedBtnjoinChannel();
			return FALSE;
		}
	}

	return CDialogEx::PreTranslateMessage(pMsg);
}

BOOL CEnterChannelDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// TODO:  �ڴ���Ӷ���ĳ�ʼ��
    m_ftEncy.CreateFont(17, 0, 0, 0, FW_BOLD, FALSE, FALSE, 0, ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH | FF_SWISS, _T("Arial"));
    m_ftHead.CreateFont(15, 0, 0, 0, FW_NORMAL, FALSE, FALSE, 0, ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH | FF_SWISS, _T("Arial"));
	m_ftDesc.CreateFont(15, 0, 0, 0, FW_NORMAL, FALSE, FALSE, 0, ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH | FF_SWISS, _T("Arial"));
    m_ftBtn.CreateFont(16, 0, 0, 0, FW_NORMAL, FALSE, FALSE, 0, ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH | FF_SWISS, _T("Arial"));
    m_penFrame.CreatePen(PS_SOLID, 1, RGB(0xD8, 0xD8, 0xD8));

	m_dlgExtCapture.Create(CExtCaptureDlg::IDD, this);
	m_dlgDevice.Create(CDeviceDlg::IDD, this);
	m_dlgDevice.EnableDeviceTest(TRUE);

	SetBackgroundColor(RGB(0xFF, 0xFF, 0xFF));
	InitCtrls();

	return TRUE;  // return TRUE unless you set the focus to a control
	// �쳣:  OCX ����ҳӦ���� FALSE
}

void CEnterChannelDlg::InitCtrls()
{
	CRect ClientRect;

//	MoveWindow(0, 0, 320, 450, 1);
	GetClientRect(&ClientRect);

	m_ctrChannel.MoveWindow(80, 128, 320, 22, TRUE);
	m_ctrChannel.SetFont(&m_ftHead);
	m_ctrChannel.SetCaretPos(CPoint(12, 148));
	m_ctrChannel.ShowCaret();
    m_ctrChannel.SetTip(LANG_STR("IDS_CHN_CHTIP"));

	m_ctrEncKey.MoveWindow(80, 176, 160, 22, TRUE);
    m_ctrEncKey.SetFont(&m_ftHead);
	m_ctrEncKey.SetCaretPos(CPoint(12, 148));
	m_ctrEncKey.ShowCaret();
    m_ctrEncKey.SetTip(LANG_STR("IDS_CHN_KEYTIP"));

	m_cmbEncType.Create(WS_CHILD | WS_VISIBLE | CBS_DROPDOWNLIST | CBS_OWNERDRAWVARIABLE, CRect(ClientRect.Width() / 2 + 1, 168, 180, 32), this, IDC_CMBENCTYPE_CHANNEL);
    m_cmbEncType.MoveWindow(290, 173, 120, 22, TRUE);
    m_cmbEncType.SetFont(&m_ftHead);

    m_cmbEncType.SetButtonImage(IDB_CMBBTN, 12, 12, RGB(0xFF, 0x00, 0xFF));
    m_cmbEncType.SetFaceColor(RGB(0xFF, 0xFF, 0xFF), RGB(0xFF, 0xFF, 0xFF));
    m_cmbEncType.InsertString(0, LANG_STR("IDS_CHN_AES128XTS"));
    m_cmbEncType.InsertString(1, LANG_STR("IDS_CHN_AES256XTS"));
    m_cmbEncType.SetCurSel(0);

	m_btnExtCapture.MoveWindow(80, 300, 100, 36, TRUE);
    m_btnJoin.MoveWindow(200, 300, 200, 36, TRUE);
    m_btnTest.MoveWindow(80, 345, 100, 36, TRUE);
	m_btnSetup.MoveWindow(200, 345, 200, 36, TRUE);
	
	m_btnExtCapture.SetBorderColor(RGB(0xD8, 0xD8, 0xD8), RGB(0x00, 0xA0, 0xE9), RGB(0x00, 0xA0, 0xE9), RGB(0xCC, 0xCC, 0xCC));
	m_btnExtCapture.SetBackColor(RGB(0xFF, 0xFF, 0xFF), RGB(0xFF, 0xFF, 0xFF), RGB(0xFF, 0xFF, 0xFF), RGB(0xFF, 0xFF, 0xFF));
	m_btnExtCapture.SetTextColor(RGB(0x55, 0x58, 0x5A), RGB(0x00, 0xA0, 0xE9), RGB(0x00, 0xA0, 0xE9), RGB(0xCC, 0xCC, 0xCC));
	m_btnExtCapture.SetWindowText(LANG_STR("IDS_CHN_BTEXTCAP"));

    m_btnJoin.SetBackColor(RGB(0x00, 0xA0, 0xE9), RGB(0x05, 0x78, 0xAA), RGB(0x05, 0x78, 0xAA), RGB(0xE6, 0xE6, 0xE6));
    m_btnJoin.SetFont(&m_ftBtn);
    m_btnJoin.SetTextColor(RGB(0xFF, 0xFF, 0xFF), RGB(0xFF, 0xFF, 0xFF), RGB(0xFF, 0xFF, 0xFF), RGB(0xCC, 0xCC, 0xCC));
    m_btnJoin.SetWindowText(LANG_STR("IDS_CHN_BTJOIN"));

    m_btnTest.SetBorderColor(RGB(0xD8, 0xD8, 0xD8), RGB(0x00, 0xA0, 0xE9), RGB(0x00, 0xA0, 0xE9), RGB(0xCC, 0xCC, 0xCC));
    m_btnTest.SetBackColor(RGB(0xFF, 0xFF, 0xFF), RGB(0xFF, 0xFF, 0xFF), RGB(0xFF, 0xFF, 0xFF), RGB(0xFF, 0xFF, 0xFF));
	m_btnTest.SetFont(&m_ftBtn);
    m_btnTest.SetTextColor(RGB(0x55, 0x58, 0x5A), RGB(0x00, 0xA0, 0xE9), RGB(0x00, 0xA0, 0xE9), RGB(0xCC, 0xCC, 0xCC));
	m_btnTest.SetWindowText(LANG_STR("IDS_CHN_BTTEST"));

    m_btnSetup.SetBorderColor(RGB(0xD8, 0xD8, 0xD8), RGB(0x00, 0xA0, 0xE9), RGB(0x00, 0xA0, 0xE9), RGB(0xCC, 0xCC, 0xCC));
    m_btnSetup.SetBackColor(RGB(0xFF, 0xFF, 0xFF), RGB(0xFF, 0xFF, 0xFF), RGB(0xFF, 0xFF, 0xFF), RGB(0xFF, 0xFF, 0xFF));
	m_btnSetup.SetFont(&m_ftBtn);
    m_btnSetup.SetTextColor(RGB(0x55, 0x58, 0x5A), RGB(0x00, 0xA0, 0xE9), RGB(0x00, 0xA0, 0xE9), RGB(0xCC, 0xCC, 0xCC));
	m_btnSetup.SetWindowText(_T("1920*1080,15fps, 3mbps"));

	CMFCButton::EnableWindowsTheming(FALSE);
}

void CEnterChannelDlg::OnPaint()
{
	CPaintDC dc(this); // device context for painting

	DrawClient(&dc);
}


void CEnterChannelDlg::DrawClient(CDC *lpDC)
{
	CRect	rcText;
    CRect	rcClient;
	LPCTSTR lpString = NULL;

	GetClientRect(&rcClient);

	CFont* defFont = lpDC->SelectObject(&m_ftHead);
	lpDC->SetBkColor(RGB(0xFF, 0xFF, 0xFF));
	lpDC->SetTextColor(RGB(0x44, 0x45, 0x46));
	lpString = LANG_STR("IDS_CHN_TITLE");
	lpDC->TextOut(12, 10, lpString, _tcslen(lpString));

    lpDC->SelectObject(&m_penFrame);
    rcText.SetRect(rcClient.Width() / 2 - 188, 120, rcClient.Width() / 2 + 172, 152);
    lpDC->RoundRect(&rcText, CPoint(32, 32));

    rcText.OffsetRect(0, 48);
    lpDC->RoundRect(&rcText, CPoint(32, 32));

	lpDC->SelectObject(&m_ftDesc);
	lpDC->SetTextColor(RGB(0x91, 0x96, 0xA0));
	lpString = LANG_STR("IDS_CHN_DSC1");
	lpDC->TextOut(12, 45, lpString, _tcslen(lpString));
	lpString = LANG_STR("IDS_CHN_DSC2");
	lpDC->TextOut(12, 65, lpString, _tcslen(lpString));

    lpDC->SetTextColor(RGB(0xD8, 0xD8, 0xD8));
    lpString = LANG_STR("IDS_CHN_ENCTYPE");
    lpDC->TextOut(240, 176, lpString, _tcslen(lpString));

	lpDC->SelectObject(defFont);

	// Done with the font.  Delete the font object.
	//	font.DeleteObject();
}

void CEnterChannelDlg::OnBnClickedBtntestChannel()
{
	// TODO:  �ڴ���ӿؼ�֪ͨ����������
	m_dlgDevice.ShowWindow(SW_SHOW);
	m_dlgDevice.CenterWindow();
}


void CEnterChannelDlg::OnBnClickedBtnjoinChannel()
{
	// TODO:  �ڴ���ӿؼ�֪ͨ����������
//	CString str = CAgoraObject::GetAgoraObject()->GetCallID();
	CString strKey;

	CAgoraObject *lpAgoraObject = CAgoraObject::GetAgoraObject();

	m_ctrEncKey.GetWindowText(strKey);
	if (strKey.GetLength() > 0)
		lpAgoraObject->SetEncryptionSecret(strKey, m_cmbEncType.GetCurSel());
	
	lpAgoraObject->EnableLastmileTest(FALSE);
	lpAgoraObject->EnableWebSdkInteroperability(TRUE);

	m_dlgExtCapture.VideoCaptureControl(TRUE);
	m_dlgExtCapture.AudioCaptureControl(TRUE);
	
	GetParent()->SendMessage(WM_JOINCHANNEL, 0, 0);
}


void CEnterChannelDlg::OnBnClickedBtnsetChannel()
{
	// TODO:  �ڴ���ӿؼ�֪ͨ����������
//	SHORT sKeyStat = ::GetAsyncKeyState(VK_CONTROL);

	GetParent()->SendMessage(WM_GONEXT, 0, 0);
}

CString CEnterChannelDlg::GetChannelName()
{
	CString strChannelName;

	m_ctrChannel.GetWindowText(strChannelName);

	return strChannelName;
}

void CEnterChannelDlg::SetVideoString(LPCTSTR lpVideoString)
{
	m_btnSetup.SetWindowText(lpVideoString);
}

void CEnterChannelDlg::CleanEncryptionSecret()
{
    m_ctrEncKey.SetWindowText(_T(""));
}

void CEnterChannelDlg::ExtCaptureControl(BOOL bEnable)
{
	m_dlgExtCapture.VideoCaptureControl(bEnable);
	m_dlgExtCapture.AudioCaptureControl(bEnable);
}

void CEnterChannelDlg::OnBnClickedBtnextcapChannel()
{
	// TODO:  �ڴ���ӿؼ�֪ͨ����������
	m_dlgExtCapture.MoveWindow(0, 0, 655, 534);
	m_dlgExtCapture.ShowWindow(SW_SHOW);
	m_dlgExtCapture.CenterWindow();
}
