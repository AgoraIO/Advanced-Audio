package io.agora.pronunciation;

import android.app.Application;
import android.util.Log;

import com.chivox.AIEngineHelper;

import io.agora.rtc.RtcEngine;

public class AgoraApplication extends Application {
    private static final String TAG = AgoraApplication.class.getSimpleName();

    private RtcEngine mRtcEngine;
    private RtcEngineEventHandler mHandler;
    private AIEngineHelper mAIEngineHelper;
    private long mAIEngineHandle;

    @Override
    public void onCreate() {
        super.onCreate();

        try {
            mHandler = new RtcEngineEventHandler();
            mRtcEngine = RtcEngine.create(this, getString(R.string.AGORA_APP_ID), mHandler);
            //mRtcEngine.setParameters("{\"rtc.log_filter\":65535}");

            createAIEngine();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public RtcEngine rtcEngine() {
        return mRtcEngine;
    }

    public void registerEventHandler(IEventHandler handler) {
        mHandler.registerEventHandler(handler);
    }

    public void removeEventHandler(IEventHandler handler) {
        mHandler.removeEventHandler(handler);
    }

    public AIEngineHelper aiEngineHelper() {
        return mAIEngineHelper;
    }

    private void createAIEngine() {
        mAIEngineHelper = new AIEngineHelper(getApplicationContext());
        mAIEngineHandle = mAIEngineHelper.createEngine();
        Log.i(TAG, "ai engine handle:" + mAIEngineHandle);
    }

    public long aiEngineHandle() {
        return mAIEngineHandle;
    }

    public void destroyAIEngine() {
        mAIEngineHelper.deleteEngine(mAIEngineHandle);
    }

    @Override
    public void onTerminate() {
        super.onTerminate();
        RtcEngine.destroy();
        destroyAIEngine();
    }
}
