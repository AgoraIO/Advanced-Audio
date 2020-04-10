
// OpenVideoCall.h : main header file for the PROJECT_NAME application
//

#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"		// main symbols

// CAgoraVideoCallApp:
// See AgoraVideoCall.cpp for the implementation of this class
//
class CAgoraExternalCaptureDlg;
class CAgoraExternalCaptureApp : public CWinApp
{
public:
	CAgoraExternalCaptureApp();
    ~CAgoraExternalCaptureApp();
// Overrides
public:
	virtual BOOL InitInstance();
    virtual int ExitInstance();
// Implementation

	DECLARE_MESSAGE_MAP()
private:
    CAgoraExternalCaptureDlg* avcDlg;
};

extern CAgoraExternalCaptureApp theApp;