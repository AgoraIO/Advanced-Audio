package io.agora.audioio.gather;


public interface IAudioController {
    AudioStatus init(IAudioCallback callback);
    AudioStatus start();
    AudioStatus stop();
    void destroy();
}
