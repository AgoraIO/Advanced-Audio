package io.agora.highqualityaudio.utils;

import io.agora.rtc.RtcEngine;

public class VoiceEffectUtil {
    public static final int VOICE_CHANGER_OFF = 0x00000000;

    public static final int VOICE_BEAUTY_VIGOROUS = 0x00100001;
    public static final int VOICE_BEAUTY_DEEP = 0x00100002;
    public static final int VOICE_BEAUTY_MELLOW = 0x00100003;
    public static final int VOICE_BEAUTY_FALSETTO = 0x00100004;
    public static final int VOICE_BEAUTY_FULL = 0x00100005;
    public static final int VOICE_BEAUTY_CLEAR = 0x00100006;
    public static final int VOICE_BEAUTY_RESOUNDING = 0x00100007;
    public static final int VOICE_BEAUTY_RINGING = 0x00100008;
    public static final int VOICE_BEAUTY_SPACIAL = 0x00100009;

    public static final int GENERAL_BEAUTY_VOICE_MALE_MAGNETIC = 0x00200001;
    public static final int GENERAL_BEAUTY_VOICE_FEMALE_FRESH = 0x00200002;
    public static final int GENERAL_BEAUTY_VOICE_FEMALE_VITALITY = 0x00200003;

    public static final int AUDIO_REVERB_FX_KTV = 0x00100001;
    public static final int AUDIO_REVERB_FX_VOCAL_CONCERT = 0x00100002;
    public static final int AUDIO_REVERB_FX_UNCLE = 0x00100003;
    public static final int AUDIO_REVERB_FX_SISTER = 0x00100004;
    public static final int AUDIO_REVERB_FX_STUDIO = 0x00100005;
    public static final int AUDIO_REVERB_FX_POPULAR = 0x00100006;
    public static final int AUDIO_REVERB_FX_RNB = 0x00100007;
    public static final int AUDIO_REVERB_FX_PHONOGRAPH = 0x00100008;

    public static final int AUDIO_VIRTUAL_STEREO = 0x00200001;

    public static final int[] VOICE_CHANGE_PRESET = {
            VOICE_CHANGER_OFF,
            VOICE_BEAUTY_VIGOROUS,
            VOICE_BEAUTY_DEEP,
            VOICE_BEAUTY_MELLOW,
            VOICE_BEAUTY_FALSETTO,
            VOICE_BEAUTY_FULL,
            VOICE_BEAUTY_CLEAR,
            VOICE_BEAUTY_RESOUNDING,
            VOICE_BEAUTY_RINGING,
            VOICE_BEAUTY_SPACIAL
    };

    public static final int[] VOICE_BEAUTY_PRESET = {
            VOICE_CHANGER_OFF,
            GENERAL_BEAUTY_VOICE_MALE_MAGNETIC,
            GENERAL_BEAUTY_VOICE_FEMALE_FRESH,
            GENERAL_BEAUTY_VOICE_FEMALE_VITALITY
    };

    public static final int[] SOUND_EFFECT_PRESET = {
            VOICE_CHANGER_OFF,
            AUDIO_REVERB_FX_KTV,
            AUDIO_REVERB_FX_VOCAL_CONCERT,
            AUDIO_REVERB_FX_UNCLE,
            AUDIO_REVERB_FX_SISTER,
            AUDIO_REVERB_FX_STUDIO,
            AUDIO_REVERB_FX_POPULAR,
            AUDIO_REVERB_FX_RNB,
            AUDIO_REVERB_FX_PHONOGRAPH
    };

    public static final int[] STEREO_PRESET = {
            VOICE_CHANGER_OFF,
            AUDIO_VIRTUAL_STEREO
    };

    public static void changeVoice(RtcEngine engine, int index) {
        if (index < 0 || index >= VOICE_CHANGE_PRESET.length) return;
        engine.setLocalVoiceChanger(VOICE_CHANGE_PRESET[index]);
    }

    public static void beautifyVoice(RtcEngine engine, int index) {
        if (index < 0 || index >= VOICE_BEAUTY_PRESET.length) return;
        engine.setLocalVoiceChanger(VOICE_BEAUTY_PRESET[index]);
    }

    public static void changeSoundEffect(RtcEngine engine, int index) {
        if (index < 0 || index >= SOUND_EFFECT_PRESET.length) return;
        engine.setLocalVoiceReverbPreset(SOUND_EFFECT_PRESET[index]);
    }

    public static void changeSoundStereo(RtcEngine engine, int index) {
        if (index < 0 || index >= STEREO_PRESET.length) return;
        engine.setLocalVoiceReverbPreset(STEREO_PRESET[index]);
    }
}
