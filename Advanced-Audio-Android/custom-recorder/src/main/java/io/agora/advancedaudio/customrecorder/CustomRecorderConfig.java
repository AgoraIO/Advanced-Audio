package io.agora.advancedaudio.customrecorder;

import android.media.AudioFormat;
import android.media.AudioRecord;

class CustomRecorderConfig {
    public static final int DEFAULT_SAMPLE_RATE = 16000;

    private int mSampleRate;
    private int mChannelCount;
    private int mAudioFormat;
    private int mBufferSize;

    int getSampleRate() {
        return mSampleRate;
    }

    void setSampleRate(int mSampleRate) {
        this.mSampleRate = mSampleRate;
    }

    int getChannelCount() {
        return mChannelCount;
    }

    void setChannelCount(int mChannelCount) {
        this.mChannelCount = mChannelCount;
    }

    int getAudioFormat() {
        return mAudioFormat;
    }

    void setAudioFormat(int mAudioFormat) {
        this.mAudioFormat = mAudioFormat;
    }

    int getBufferSize() {
        return mBufferSize;
    }

    void setBufferSize(int mBufferSize) {
        this.mBufferSize = mBufferSize;
    }

    /**
     * Get a default audio recording configuration with:
     * 1) Sample rate: 16KHz
     * 2) Channel count: mono (1)
     * 3) Audio format: AudioFormat.ENCODING_PCM_16BIT
     * 4) Buffer size: twice the minimum buffer size
     * @return
     */
     static CustomRecorderConfig createDefaultConfig() {
        CustomRecorderConfig config = new CustomRecorderConfig();
        config.setSampleRate(DEFAULT_SAMPLE_RATE);
        config.setChannelCount(AudioFormat.CHANNEL_IN_MONO);
        config.setAudioFormat(AudioFormat.ENCODING_PCM_16BIT);
        int bufSize = AudioRecord.getMinBufferSize(
                config.getSampleRate(),
                config.getChannelCount(),
                config.getAudioFormat());
        config.setBufferSize(bufSize * 2);
        return config;
    }
}
