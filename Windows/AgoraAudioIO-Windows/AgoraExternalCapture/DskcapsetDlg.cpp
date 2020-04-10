// DskcapsetDlg.cpp : ʵ���ļ�
//

#include "stdafx.h"
#include "AgoraExternalCapture.h"
#include "DskcapsetDlg.h"
#include "afxdialogex.h"


// CDskcapsetDlg �Ի���

IMPLEMENT_DYNAMIC(CDskcapsetDlg, CDialogEx)

CDskcapsetDlg::CDskcapsetDlg(CWnd* pParent /*=NULL*/)
	: CDialogEx(CDskcapsetDlg::IDD, pParent)
	, m_nBitrate(0)
{

}

CDskcapsetDlg::~CDskcapsetDlg()
{
}

void CDskcapsetDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_CMBFRMRATE_TB, m_cbxCaptureFPS);
}


BEGIN_MESSAGE_MAP(CDskcapsetDlg, CDialogEx)
	ON_WM_SHOWWINDOW()
END_MESSAGE_MAP()


// CDskcapsetDlg ��Ϣ�������

int CDskcapsetDlg::GetCaptureFPS()
{
	int nSel = m_cbxCaptureFPS.GetCurSel();

	if (nSel == -1)
		return 15;

	return nSel + 1;
}

void CDskcapsetDlg::SetCaptureRect(LPCRECT lpRect)
{
	ASSERT(lpRect->left != lpRect->right);
	ASSERT(lpRect->top != lpRect->bottom);

	if (lpRect->left == lpRect->right || lpRect->top == lpRect->bottom)
		return;

	m_rcRegion.CopyRect(lpRect);
}

void CDskcapsetDlg::GetCaptureRect(LPRECT lpRect)
{
	lpRect->left = m_rcRegion.left;
	lpRect->right = m_rcRegion.right;
	lpRect->top = m_rcRegion.top;
	lpRect->bottom = m_rcRegion.bottom;
}

BOOL CDskcapsetDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// TODO:  �ڴ���Ӷ���ĳ�ʼ��
	CString str;
	for (int nIndex = 0; nIndex < 15; nIndex++) {
		str.Format(_T("%d fps"), nIndex + 1);
		m_cbxCaptureFPS.InsertString(nIndex, str);
	}
	m_cbxCaptureFPS.SetCurSel(14);

	return TRUE;  // return TRUE unless you set the focus to a control
	// �쳣:  OCX ����ҳӦ���� FALSE
}


void CDskcapsetDlg::OnShowWindow(BOOL bShow, UINT nStatus)
{
	CDialogEx::OnShowWindow(bShow, nStatus);

	// TODO:  �ڴ˴������Ϣ����������

	if (!bShow) {
		m_nBitrate = GetDlgItemInt(IDC_EDBITRATE_TB, NULL, TRUE);
		m_rcRegion.left = GetDlgItemInt(IDC_EDX_TB, NULL, TRUE);
		m_rcRegion.top = GetDlgItemInt(IDC_EDY_TB, NULL, TRUE);
		m_rcRegion.right = m_rcRegion.left + GetDlgItemInt(IDC_EDW_TB, NULL, TRUE);
		m_rcRegion.bottom = m_rcRegion.top + GetDlgItemInt(IDC_EDH_TB, NULL, TRUE);
	}
	else {
		SetDlgItemInt(IDC_EDX_TB, m_rcRegion.left);
		SetDlgItemInt(IDC_EDY_TB, m_rcRegion.top);
		SetDlgItemInt(IDC_EDW_TB, m_rcRegion.Width());
		SetDlgItemInt(IDC_EDH_TB, m_rcRegion.Height());
	}
}