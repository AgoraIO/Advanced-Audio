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

        // Notify the Rtc Engine that we want to use external
        // audio sources, instead of creating a recorder inside
        // the engine.
        // This must be called before joining a channel. So
        // there must be a way to obtain the recording
        // parameters globally.
        // Here we take the default recording configuration
        // as an example. Developers should implement the
        // mechanism of their own.
        CustomRecorderConfig config =
                CustomRecorderConfig.createDefaultConfig();
        rtcEngine().setExternalAudioSource(true,
                config.getSampleRate(),
                config.getChannelCount());
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
