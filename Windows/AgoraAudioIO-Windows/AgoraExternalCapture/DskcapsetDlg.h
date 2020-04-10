#pragma once
#include "afxwin.h"


// CDskcapsetDlg �Ի���

class CDskcapsetDlg : public CDialogEx
{
	DECLARE_DYNAMIC(CDskcapsetDlg)

public:
	CDskcapsetDlg(CWnd* pParent = NULL);   // ��׼���캯��
	virtual ~CDskcapsetDlg();

// �Ի�������
	enum { IDD = IDD_DSKCAPTB_DIALOG };

	int GetCaptureFPS();
	void SetCaptureRect(LPCRECT lpRect);
	void GetCaptureRect(LPRECT lpRect);

	int GetBitrate() { return m_nBitrate; };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV ֧��
	virtual BOOL OnInitDialog();

	afx_msg void OnShowWindow(BOOL bShow, UINT nStatus);


	DECLARE_MESSAGE_MAP()

// data
private:
	CRect		m_rcRegion;
	int			m_nBitrate;

// controls
private:
	CComboBox m_cbxCaptureFPS;
};
