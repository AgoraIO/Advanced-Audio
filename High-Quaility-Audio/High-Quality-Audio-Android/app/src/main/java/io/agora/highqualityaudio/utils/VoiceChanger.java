package io.agora.highqualityaudio.utils;

import java.util.Locale;

import io.agora.highqualityaudio.AgoraApplication;
import io.agora.rtc.RtcEngine;

public class VoiceChanger {
    public static final int VOICE_KTV = 0;
    public static final int VOICE_LIVE = 1;
    public static final int VOICE_UNCLE = 2;
    public static final int VOICE_LADY = 3;
    public static final int VOICE_STUDIO = 4;
    public static final int VOICE_R_R = 5;
    public static final int VOICE_POP = 6;
    public static final int VOICE_R_B = 7;
    public static final int VOICE_PHONOGRAGH = 8;
    public static final int VOICE_DEFAULT = 9;

    private static final String PARAM_FORMAT = "{\"che.audio.morph.reverb_preset\":%d}";

    public static void changeVoice(AgoraApplication application, int voiceType) {
        changeVoice(application.engine(), voiceType);
    }

    private static void changeVoice(RtcEngine engine, int voiceType) {
        engine.setParameters(String.format(Locale.getDefault(), PARAM_FORMAT, voiceType));
    }
}
