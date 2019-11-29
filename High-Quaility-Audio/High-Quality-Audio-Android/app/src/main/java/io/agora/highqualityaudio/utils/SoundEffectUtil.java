package io.agora.highqualityaudio.utils;

import java.util.Locale;

import io.agora.rtc.RtcEngine;

public class SoundEffectUtil {
    public static final int EFFECT_NONE = 0;

    public static final int VOICE_THICK = 7;
    public static final int VOICE_LOW = 8;
    public static final int VOICE_ROUND = 9;
    public static final int VOICE_FALSETTO = 10;
    public static final int VOICE_FULL = 11;
    public static final int VOICE_CLEAR = 12;
    public static final int VOICE_RESOUNDING = 13;
    public static final int VOICE_LOUD = 14;
    public static final int VOICE_OPEN_AIR = 15;

    public static final int PRESET_KTV = 1;
    public static final int PRESET_LIVE = 2;
    public static final int PRESET_UNCLE = 3;
    public static final int PRESET_GIRL = 4;
    public static final int PRESET_STUDIO = 5;
    public static final int PRESET_POP = 7;
    public static final int PRESET_RNB = 8;
    public static final int PRESET_PHONOGRAPH = 9;

    public static void changeVoice(RtcEngine engine, int type) {
        if ((type < VOICE_THICK || type > VOICE_OPEN_AIR) &&
                type != EFFECT_NONE) {
            return;
        }

        engine.setParameters(String.format(Locale.getDefault(),
                "{\"che.audio.morph.voice_changer\": %d}", type));
    }

    public static void changePreset(RtcEngine engine, int type) {
        if ((type < EFFECT_NONE || type > PRESET_PHONOGRAPH) || type == 6) {
            return;
        }

        engine.setParameters(String.format(Locale.getDefault(),
                "{\"che.audio.morph.reverb_preset\": %d}", type));
    }
}
