package io.agora.audioio.gather;

public interface IAudioCallback {
    void onAudioDataAvailable(long timeStamp, byte[] audioData);
}
