package io.agora.advancedaudio.customrecorder;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

import io.agora.advancedaudio.Constants;
import io.agora.advancedaudio.R;
import io.agora.advancedaudio.component.activities.BaseActivity;

public class CustomRecorderActivity extends BaseActivity {
    private static final String TAG = CustomRecorderActivity.class.getSimpleName();

    private Intent mServiceIntent;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initUI();
        registerRtcEventHandler(this);
        joinChannel();
    }

    private void initUI() {
        setContentView(R.layout.activity_audio_room);
        findViewById(R.id.live_btn_mute_audio).setActivated(true);
    }

    private void joinChannel() {
        String channelName = getIntent().
                getStringExtra(Constants.KEY_CHANNEL_NAME);
        rtcEngine().setClientRole(io.agora.rtc.Constants.CLIENT_ROLE_BROADCASTER);
        rtcEngine().setExternalAudioSource(true,
                CustomRecorderConfig.DEFAULT_SAMPLE_RATE, 1);
        rtcEngine().joinChannel(null, channelName, null, 0);
    }

    private void leaveChannel() {
        rtcEngine().leaveChannel();
    }

    @Override
    public void onJoinChannelSuccess(String channel, int uid, int elapsed) {
        Log.i(TAG, "onJoinChannelSuccess " + (uid & 0xFFFFFFFFL));
        startRecordService();
    }

    private void startRecordService() {
        mServiceIntent = new Intent(this, CustomRecorderService.class);
        startService(mServiceIntent);
    }

    private void stopRecordService() {
        if (mServiceIntent != null) {
            stopService(mServiceIntent);
        }
    }

    @Override
    public void finish() {
        stopRecordService();
        removeRtcEventHandler(this);
        leaveChannel();
        super.finish();
    }

    public void onLeaveClicked(View view) {
        finish();
    }

    public void onMuteAudioClicked(View view) {
        boolean activated = view.isActivated();
        rtcEngine().muteLocalAudioStream(activated);
        view.setActivated(!activated);
    }
}
