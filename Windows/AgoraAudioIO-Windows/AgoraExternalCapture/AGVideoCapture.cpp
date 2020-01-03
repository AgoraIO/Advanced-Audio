#include "stdafx.h"
#include "AGVideoCapture.h"
#include "VideoPackageQueue.h"

#include "libYUV/libyuv.h"

#ifdef DEBUG
#pragma comment(lib, "libYUV/debug/yuv.lib")
#pragma comment(lib, "libYUV/debug/jpeg-static.lib")
#else
#pragma comment(lib, "libYUV/release/yuv.lib")
#pragma comment(lib, "libYUV/release/jpeg-static.lib")
#endif

using namespace libyuv;

CAGVideoCapture::CAGVideoCapture()
	: m_nTimeStamp(0)
	, m_nRef(0)
{
	m_lpYUVBuffer = new BYTE[0x800000];
}


CAGVideoCapture::~CAGVideoCapture()
{
	delete[] m_lpYUVBuffer;
}

STDMETHODIMP_(ULONG) CAGVideoCapture::AddRef()
{
	m_nRef++;

	return m_nRef;
}

STDMETHODIMP_(ULONG) CAGVideoCapture::Release()
{
	m_nRef--;

	return m_nRef;
}

STDMETHODIMP CAGVideoCapture::QueryInterface(REFIID riid, void ** ppv)
{
	if (riid == IID_ISampleGrabberCB || riid == IID_IUnknown)
	{
		*ppv = (void *) static_cast<ISampleGrabberCB*> (this);
		return NOERROR;
	}

	return E_NOINTERFACE;
}

STDMETHODIMP CAGVideoCapture::SampleCB(double SampleTime, IMediaSample* pSample)
{
	return S_OK;
}

STDMETHODIMP CAGVideoCapture::BufferCB(double dblSampleTime, BYTE *pBuffer, long lBufferSize)
{
	CVideoPackageQueue *lpPackageQueue = CVideoPackageQueue::GetInstance();
	BITMAPINFOHEADER bmiHeader;

	if (lpPackageQueue->GetBufferSize() < static_cast<SIZE_T>(lBufferSize))
		return E_OUTOFMEMORY;

	lpPackageQueue->GetVideoFormat(&bmiHeader);

	m_lpY = m_lpYUVBuffer;
	m_lpU = m_lpY + bmiHeader.biWidth*bmiHeader.biHeight;
	m_lpV = m_lpU + bmiHeader.biWidth*bmiHeader.biHeight / 4;
	SIZE_T nYUVSize = bmiHeader.biWidth*bmiHeader.biHeight * 3 / 2;

#ifdef DEBUG
	HANDLE hFile = INVALID_HANDLE_VALUE;
	DWORD  dwBytesWritten = 0;

	switch (bmiHeader.biCompression)
	{
	case 0x00000000:	// RGB24
		hFile = ::CreateFile(_T("d:\\pictest\\test.rgb24"), GENERIC_WRITE, FILE_SHARE_READ, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
		break;
	case MAKEFOURCC('I', '4', '2', '0'):	// I420
		hFile = ::CreateFile(_T("d:\\pictest\\test.i420"), GENERIC_WRITE, FILE_SHARE_READ, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
		break;
	case MAKEFOURCC('Y', 'U', 'Y', '2'):	// YUY2
		hFile = ::CreateFile(_T("d:\\pictest\\test.yuy2"), GENERIC_WRITE, FILE_SHARE_READ, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
		break;
	case MAKEFOURCC('M', 'J', 'P', 'G'):	// MJPEG
		hFile = ::CreateFile(_T("d:\\pictest\\test.jpeg"), GENERIC_WRITE, FILE_SHARE_READ, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
		break;
	case MAKEFOURCC('U', 'Y', 'V', 'Y'):	// UYVY
		hFile = ::CreateFile(_T("d:\\pictest\\test.uyvy"), GENERIC_WRITE, FILE_SHARE_READ, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
		break;
	default:
		break;
	}

		if (hFile != INVALID_HANDLE_VALUE) {
			::WriteFile(hFile, pBuffer, lBufferSize, &dwBytesWritten, NULL);
			::CloseHandle(hFile);
		}
#endif

	switch (bmiHeader.biCompression)
	{
	case 0x00000000:	// RGB24
		RGB24ToI420(pBuffer, bmiHeader.biWidth*3, 
			m_lpY, bmiHeader.biWidth,
			m_lpU, bmiHeader.biWidth / 2,
			m_lpV, bmiHeader.biWidth / 2,
			bmiHeader.biWidth, -bmiHeader.biHeight);
		break;
	case MAKEFOURCC('I', '4', '2', '0'):	// I420
		memcpy_s(m_lpYUVBuffer, 0x800000, pBuffer, lBufferSize);
		break;
	case MAKEFOURCC('Y', 'U', 'Y', '2'):	// YUY2
		YUY2ToI420(pBuffer, bmiHeader.biWidth*2,
			m_lpY, bmiHeader.biWidth,
			m_lpU, bmiHeader.biWidth/2,
			m_lpV, bmiHeader.biWidth/2,
			bmiHeader.biWidth, bmiHeader.biHeight);
		break;
	case MAKEFOURCC('M', 'J', 'P', 'G'):	// MJPEG
		MJPGToI420(pBuffer, lBufferSize, 
			m_lpY, bmiHeader.biWidth,
			m_lpU, bmiHeader.biWidth / 2,
			m_lpV, bmiHeader.biWidth / 2,
			bmiHeader.biWidth, bmiHeader.biHeight,
			bmiHeader.biWidth, bmiHeader.biHeight);
		break;
	case MAKEFOURCC('U', 'Y', 'V', 'Y'):	// UYVY
		UYVYToI420(pBuffer, bmiHeader.biWidth,
			m_lpY, bmiHeader.biWidth,
			m_lpU, bmiHeader.biWidth / 2,
			m_lpV, bmiHeader.biWidth / 2,
			bmiHeader.biWidth, bmiHeader.biHeight);
		break;
	default:
		ATLASSERT(FALSE);
		break;
	}

	lpPackageQueue->PushVideoPackage(m_lpYUVBuffer, nYUVSize);

#ifdef DEBUG
	hFile = ::CreateFile(_T("d:\\pictest\\trans.i420"), GENERIC_WRITE, FILE_SHARE_READ, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
	
	if (hFile != INVALID_HANDLE_VALUE) {
		::WriteFile(hFile, m_lpYUVBuffer, nYUVSize, &dwBytesWritten, NULL);
		::CloseHandle(hFile);
	}

#endif

	return S_OK;
}