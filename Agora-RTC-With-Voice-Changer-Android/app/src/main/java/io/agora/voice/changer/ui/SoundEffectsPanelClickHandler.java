package io.agora.voice.changer.ui;

public interface SoundEffectsPanelClickHandler {
    void onTargetPitchChanged(double pitch);

    void onEqualizationBandChanged(int bandIndex, int bandGain);

    void onReverbParamChanged(int reverbKey, int value);
}
