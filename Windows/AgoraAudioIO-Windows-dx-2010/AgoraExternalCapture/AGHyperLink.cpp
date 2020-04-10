// AGHyperLink.cpp : ʵ���ļ�
//

#include "stdafx.h"
#include "AGHyperLink.h"


// CAGHyperLink

IMPLEMENT_DYNAMIC(CAGHyperLink, CStatic)

CAGHyperLink::CAGHyperLink()
{      
	m_crLink = RGB(0x00, 0x9E, 0xEB);   
	m_crVisited = RGB(85, 26, 139);
	m_crHover = RGB(255, 0, 0);
	m_crBack = RGB(255, 255, 255);
	m_bVisited = FALSE;                // Hasn't been visited yet.
	m_bOverControl = FALSE;
	m_bTrackMouseEvent = FALSE;
	m_strURL.Empty();
}

CAGHyperLink::~CAGHyperLink()
{
}


BEGIN_MESSAGE_MAP(CAGHyperLink, CStatic)
	ON_WM_MOUSEMOVE()
	ON_WM_SETCURSOR()
	ON_CONTROL_REFLECT(STN_CLICKED, &CAGHyperLink::OnStnClicked)
	ON_WM_PAINT()
	ON_WM_MOUSELEAVE()
END_MESSAGE_MAP()

// CAGHyperLink ��Ϣ�������
void CAGHyperLink::PreSubclassWindow()
{
	// We want to get mouse clicks via STN_CLICKED
	DWORD dwStyle = GetStyle();
	ModifyStyle(0, SS_NOTIFY, 0);

	// Set the URL as the window text
	if (m_strURL.IsEmpty())
		GetWindowText(m_strURL);

	// Check that the window text isn't empty. If it is, set it as the URL.
	CString strWndText;
	GetWindowText(strWndText);
	if (strWndText.IsEmpty())
	{
		ASSERT(!m_strURL.IsEmpty());    // Window and URL both NULL. DUH!
		SetWindowText(m_strURL);
	}

	CStatic::PreSubclassWindow();
}

void CAGHyperLink::OnMouseMove(UINT nFlags, CPoint point)
{
	// TODO:  �ڴ������Ϣ�����������/�����Ĭ��ֵ
	if (!m_bOverControl){
		m_bOverControl = TRUE;
		Invalidate(FALSE);
	}

	if (!m_bTrackMouseEvent) {
		TRACKMOUSEEVENT TrackMouseEvent;
		TrackMouseEvent.cbSize = sizeof(TRACKMOUSEEVENT);
		TrackMouseEvent.hwndTrack = GetSafeHwnd();
		TrackMouseEvent.dwFlags = TME_LEAVE;
		TrackMouseEvent.dwHoverTime = 1;

		m_bTrackMouseEvent = ::TrackMouseEvent(&TrackMouseEvent);
	}

	CStatic::OnMouseMove(nFlags, point);
}

BOOL CAGHyperLink::OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message)
{
	// TODO:  �ڴ������Ϣ�����������/�����Ĭ��ֵ
    HCURSOR hLinkCursor = ::LoadCursor(NULL, IDC_HAND);
    if (hLinkCursor != NULL) {
        ::SetCursor(hLinkCursor);
		return TRUE;
	}

	return CStatic::OnSetCursor(pWnd, nHitTest, message);
}


void CAGHyperLink::OnStnClicked()
{
	// TODO:  �ڴ���ӿؼ�֪ͨ����������
	m_bOverControl = FALSE;

	HINSTANCE hInstance = ::ShellExecute(GetParent()->GetSafeHwnd(), _T("open"), m_strURL, NULL, NULL, SW_MAXIMIZE);
	if (hInstance > 0) 
		m_bVisited = TRUE;
}

void CAGHyperLink::SetURL(CString strURL)
{
	m_strURL = strURL;
}

CString CAGHyperLink::GetURL() const
{
	return m_strURL;
}

void CAGHyperLink::SetTextColor(COLORREF crLink, COLORREF crVisited, COLORREF crHover)
{
	m_crLink = crLink;
	m_crVisited = crVisited;
	m_crHover = crHover;

	if(GetSafeHwnd() != NULL)
		Invalidate();
}

void CAGHyperLink::SetBackColor(COLORREF crBack)
{
	m_crBack = crBack;
}

COLORREF CAGHyperLink::GetLinkColor() const
{
	return m_crLink;
}

COLORREF CAGHyperLink::GetVisitedColor() const
{
	return m_crVisited;
}

COLORREF CAGHyperLink::GetHoverColor() const
{
	return m_crHover;
}


void CAGHyperLink::OnPaint()
{
	CPaintDC dc(this); // device context for painting
	// TODO:  �ڴ˴������Ϣ����������
	// ��Ϊ��ͼ��Ϣ���� CStatic::OnPaint()

	CString strWindowText;
	CRect	rcClient;

	GetClientRect(&rcClient);

	CFont *lpDefaultFont = dc.SelectObject(GetFont());
	dc.SetTextColor(m_crLink);
	dc.SetBkColor(m_crBack);
	if (m_bOverControl)
		dc.SetTextColor(m_crHover);
	else if (m_bVisited)
		dc.SetTextColor(m_crVisited);

	GetWindowText(strWindowText);
	dc.DrawText(strWindowText, &rcClient, DT_LEFT);
	dc.SelectObject(lpDefaultFont);
}

void CAGHyperLink::OnMouseLeave()
{
	// TODO:  �ڴ������Ϣ�����������/�����Ĭ��ֵ
	m_bTrackMouseEvent = FALSE;
	m_bOverControl = FALSE;
	Invalidate(FALSE);

	CStatic::OnMouseLeave();
}
