#include "stdafx.h"
#include "ExtendAudioFrameObserver.h"


CExtendAudioFrameObserver::CExtendAudioFrameObserver()
{
}


CExtendAudioFrameObserver::~CExtendAudioFrameObserver()
{
}

bool CExtendAudioFrameObserver::onRecordAudioFrame(AudioFrame& audioFrame)
{
    SIZE_T nSize = audioFrame.channels*audioFrame.samples * 2;
    unsigned int readByte = 0;
    int timestamp = GetTickCount();
    CircleBuffer::GetInstance()->readBuffer(audioFrame.buffer, nSize, &readByte, timestamp);
	/*CAudioCapturePackageQueue::GetInstance()->PopAudioPackage(audioFrame.buffer, &nSize);*/
    audioFrame.renderTimeMs = timestamp;
	return true;
}

bool CExtendAudioFrameObserver::onPlaybackAudioFrame(AudioFrame& audioFrame)
{
	/*SIZE_T nSize = audioFrame.channels*audioFrame.samples * 2;
	CAudioPlayPackageQueue::GetInstance()->PushAudioPackage(audioFrame.buffer, nSize);*/
	
	return true;
}

bool CExtendAudioFrameObserver::onMixedAudioFrame(AudioFrame& audioFrame)
{
	return true;
}

bool CExtendAudioFrameObserver::onPlaybackAudioFrameBeforeMixing(unsigned int uid, AudioFrame& audioFrame)
{
	return true;
}
