package io.agora.advancedaudio;

import android.app.Application;

import io.agora.advancedaudio.component.R;
import io.agora.advancedaudio.component.rtc.AgoraEventHandler;
import io.agora.advancedaudio.component.rtc.EventHandler;
import io.agora.advancedaudio.component.utils.FileUtil;
import io.agora.rtc.RtcEngine;

public class AgoraApplication extends Application {
    private RtcEngine mRtcEngine;
    private AgoraEventHandler mHandler = new AgoraEventHandler();

    @Override
    public void onCreate() {
        super.onCreate();
        try {
            mRtcEngine = RtcEngine.create(getApplicationContext(), getString(R.string.agora_app_id), mHandler);
            mRtcEngine.setChannelProfile(io.agora.rtc.Constants.CHANNEL_PROFILE_LIVE_BROADCASTING);
            mRtcEngine.setLogFile(FileUtil.initializeLogFile(this));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public RtcEngine rtcEngine() { return mRtcEngine; }

    public void registerEventHandler(EventHandler handler) { mHandler.addHandler(handler); }

    public void removeEventHandler(EventHandler handler) { mHandler.removeHandler(handler); }

    @Override
    public void onTerminate() {
        super.onTerminate();
        RtcEngine.destroy();
    }
}
