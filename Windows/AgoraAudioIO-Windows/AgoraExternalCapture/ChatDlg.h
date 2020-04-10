#pragma once
#include "afxwin.h"
#include <afxcoll.h>

// CChatDlg �Ի���

class CChatDlg : public CDialogEx
{
	DECLARE_DYNAMIC(CChatDlg)

public:
	CChatDlg(CWnd* pParent = NULL);   // ��׼���캯��
	virtual ~CChatDlg();

// �Ի�������
	enum { IDD = IDD_MESSAGE_DIALOG };

    void AddChatMessage(UINT nUID, LPCTSTR lpMessage);
    void ClearHistory();

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV ֧��
    virtual BOOL OnInitDialog();
    virtual BOOL PreTranslateMessage(MSG* pMsg);

    afx_msg void OnPaint();
    afx_msg void OnSize(UINT nType, int cx, int cy);

	DECLARE_MESSAGE_MAP()


private:
    CEdit m_edtChatBox;

    CStringList m_strMsgList;
    int     m_nStreamID;
};
