package io.agora.highqualityaudio;

import android.app.Application;
import android.util.Log;

import io.agora.highqualityaudio.data.UserAccountManager;
import io.agora.highqualityaudio.rtc.AgoraEventHandler;
import io.agora.highqualityaudio.utils.FileUtil;
import io.agora.rtc.Constants;
import io.agora.rtc.RtcEngine;

public class AgoraApplication extends Application {

    private UserAccountManager mAccountManager = UserAccountManager.INSTANCE;
    private RtcEngine mRtcEngine;
    private AgoraEventHandler mHandler = new AgoraEventHandler();

    @Override
    public void onCreate() {
        super.onCreate();
        try {
            mRtcEngine = RtcEngine.create(getApplicationContext(), getString(R.string.app_id), mHandler);
            mRtcEngine.enableAudioVolumeIndication(
                    io.agora.highqualityaudio.utils.Constants.VOLUME_INDICATE_INTERVAL,
                    io.agora.highqualityaudio.utils.Constants.VOLUME_INDICATE_SMOOTH);
            mRtcEngine.setChannelProfile(Constants.CHANNEL_PROFILE_LIVE_BROADCASTING);

            // High quality audio parameters
            mRtcEngine.setParameters("{\"che.audio.bypass.apm\":true}");
            mRtcEngine.setParameters("{\"che.audio.specify.codec\":\"HEAAC_2ch\"}");
            mRtcEngine.setAudioProfile(Constants.AUDIO_PROFILE_DEFAULT,
                    Constants.AUDIO_SCENARIO_GAME_STREAMING);

            mRtcEngine.setLogFile(FileUtil.initializeLogFile(this));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onTerminate() {
        super.onTerminate();
        RtcEngine.destroy();
    }

    public UserAccountManager.UserAccount myAccount() {
        return mAccountManager.account();
    }

    public RtcEngine engine() { return mRtcEngine; }

    public AgoraEventHandler handler() { return mHandler; }
}
