package io.agora.advancedaudio.customrecorder;

import android.media.AudioRecord;
import android.media.MediaRecorder;

class CustomRecorder {
    private AudioRecord mAudioRecord;
    private CustomRecorderConfig mConfig;

    CustomRecorder() {
        mConfig = CustomRecorderConfig.getDefaultConfig();
        mAudioRecord = new AudioRecord(
                MediaRecorder.AudioSource.MIC,
                mConfig.getSampleRate(),
                mConfig.getChannelCount(),
                mConfig.getAudioFormat(),
                mConfig.getBufferSize());
    }

    void start() {
        if (mAudioRecord != null) {
            try {
                mAudioRecord.startRecording();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    void stop() {
        if (mAudioRecord != null) {
            mAudioRecord.stop();
            mAudioRecord.release();
            mAudioRecord = null;
        }
    }

    CustomRecorderConfig getConfig() {
        return mConfig;
    }

    int read(byte[] buffer, int offset, int size) {
        return mAudioRecord.read(buffer, offset, size);
    }
}
