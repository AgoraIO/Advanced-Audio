package io.agora.highqualityaudio.utils;

import io.agora.highqualityaudio.R;

public class Constants {
    public static final int BAND_31 = 0;
    public static final int BAND_62 = 1;
    public static final int BAND_125 = 2;
    public static final int BAND_250 = 3;
    public static final int BAND_500 = 4;
    public static final int BAND_1K = 5;
    public static final int BAND_2K = 6;
    public static final int BAND_4K = 7;
    public static final int BAND_8K = 8;
    public static final int BAND_16K = 9;

    public static final int REVERB_DRY_LEVEL = 0;
    public static final int REVERB_WET_LEVEL = 1;
    public static final int REVERB_ROOM_SIZE = 2;
    public static final int REVERB_WET_DELAY = 3;
    public static final int REVERB_STRENGTH = 4;

    public static String BUNDLE_KEY_UID = "key_uid";
    public static String BUNDLE_KEY_CHANNEL_NAME = "key_channel_name";
    public static String BUNDLE_KEY_BG_RES = "key_background_res";
    public static String BUNDLE_KEY_PORTRAIT_RES = "key_portrait_res";

    public static final int AVATAR_COUNT = 8;

    public static final int[] AVATAR_RES = {
            R.drawable.portrait_0,
            R.drawable.portrait_1,
            R.drawable.portrait_2,
            R.drawable.portrait_3,
            R.drawable.portrait_4,
            R.drawable.portrait_5,
            R.drawable.portrait_6,
            R.drawable.portrait_7,
    };

    public static final int VOLUME_INDICATE_INTERVAL = 600;
    public static final int VOLUME_INDICATE_SMOOTH = 3;
}
