package io.agora.voice.changer.ui;

import android.content.Intent;
import android.graphics.PorterDuff;
import android.media.AudioManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.WindowManager;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import io.agora.rtc.Constants;
import io.agora.rtc.IRtcEngineEventHandler;
import io.agora.rtc.RtcEngine;
import io.agora.voice.changer.R;
import io.agora.voice.changer.model.AGEventHandler;
import io.agora.voice.changer.model.ConstantApp;

public class LiveRoomActivity extends BaseActivity implements AGEventHandler {

    private final static Logger log = LoggerFactory.getLogger(LiveRoomActivity.class);

    private volatile boolean mAudioMuted = false;

    private volatile int mAudioRouting = -1; // Default

    private SoundEffectsDialog mSoundEffectsDialog;

    private CheckBox mCbUncle;
    private CheckBox mCbBoy;
    private CheckBox mCbBajie;
    private CheckBox mCbVacant;
    private CheckBox mCbGiant;
    private CheckBox mCbLolita;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_live_room);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        return false;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        return false;
    }

    @Override
    protected void initUIandEvent() {
        event().addEventHandler(this);

        Intent i = getIntent();

        int cRole = i.getIntExtra(ConstantApp.ACTION_KEY_CROLE, 0);

        if (cRole == 0) {
            throw new RuntimeException("Should not reach here");
        }

        String roomName = i.getStringExtra(ConstantApp.ACTION_KEY_ROOM_NAME);

        doConfigEngine(cRole);

        ImageView button1 = (ImageView) findViewById(R.id.switch_broadcasting_id);
        ImageView button2 = (ImageView) findViewById(R.id.mute_local_speaker_id);

        if (isBroadcaster(cRole)) {
            broadcasterUI(button1, button2);
        } else {
            audienceUI(button1, button2);
        }

        worker().joinChannel(roomName, config().mUid);

        TextView textRoomName = (TextView) findViewById(R.id.room_name);
        textRoomName.setText(roomName);

        optional();

        LinearLayout bottomContainer = (LinearLayout) findViewById(R.id.bottom_container);
        FrameLayout.MarginLayoutParams fmp = (FrameLayout.MarginLayoutParams) bottomContainer.getLayoutParams();
        fmp.bottomMargin = virtualKeyHeight() + 16;


    }

    private Handler mMainHandler;

    private static final int UPDATE_UI_MESSAGE = 0x1024;

    EditText mMessageList;

    StringBuffer mMessageCache = new StringBuffer();

    private void notifyMessageChanged(String msg) {
        if (mMessageCache.length() > 10000) { // drop messages
            mMessageCache = new StringBuffer(mMessageCache.substring(10000 - 40));
        }

        mMessageCache.append(System.currentTimeMillis()).append(": ").append(msg).append("\n"); // append timestamp for messages

        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (isFinishing()) {
                    return;
                }

                if (mMainHandler == null) {
                    mMainHandler = new Handler(getMainLooper()) {
                        @Override
                        public void handleMessage(Message msg) {
                            super.handleMessage(msg);

                            if (isFinishing()) {
                                return;
                            }

                            switch (msg.what) {
                                case UPDATE_UI_MESSAGE:
                                    String content = (String) (msg.obj);
                                    mMessageList.setText(content);
                                    mMessageList.setSelection(content.length());
                                    break;

                                default:
                                    break;
                            }

                        }
                    };

                    mMessageList = (EditText) findViewById(R.id.msg_list);
                }

                mMainHandler.removeMessages(UPDATE_UI_MESSAGE);
                Message envelop = new Message();
                envelop.what = UPDATE_UI_MESSAGE;
                envelop.obj = mMessageCache.toString();
                mMainHandler.sendMessageDelayed(envelop, 1000l);
            }
        });
    }

    private void optional() {
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS);

        setVolumeControlStream(AudioManager.STREAM_VOICE_CALL);
    }

    private void optionalDestroy() {
    }

    public void onSwitchSpeakerClicked(View view) {
        log.info("onSwitchSpeakerClicked " + view + " " + mAudioMuted + " " + mAudioRouting);

        RtcEngine rtcEngine = rtcEngine();
        rtcEngine.setEnableSpeakerphone(mAudioRouting != 3);
    }

    private void doConfigEngine(int cRole) {
        worker().configEngine(cRole);
    }

    private boolean isBroadcaster(int cRole) {
        return cRole == Constants.CLIENT_ROLE_BROADCASTER;
    }

    private boolean isBroadcaster() {
        return isBroadcaster(config().mClientRole);
    }

    @Override
    protected void deInitUIandEvent() {
        optionalDestroy();

        doLeaveChannel();
        event().removeEventHandler(this);
    }

    private void doLeaveChannel() {
        worker().leaveChannel(config().mChannel);
    }

    public void onEndCallClicked(View view) {
        log.info("onEndCallClicked " + view);

        quitCall();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();

        log.info("onBackPressed");

        quitCall();
    }

    private void quitCall() {
        Intent intent = new Intent(this, MainActivity.class);
        startActivity(intent);

        finish();
    }

    private void doSwitchToBroadcaster(boolean broadcaster) {
        final int uid = config().mUid;
        log.debug("doSwitchToBroadcaster " + (uid & 0XFFFFFFFFL) + " " + broadcaster);

        if (broadcaster) {
            doConfigEngine(Constants.CLIENT_ROLE_BROADCASTER);

            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {

                    ImageView button1 = (ImageView) findViewById(R.id.switch_broadcasting_id);
                    ImageView button2 = (ImageView) findViewById(R.id.mute_local_speaker_id);
                    broadcasterUI(button1, button2);
                }
            }, 1000); // wait for reconfig engine
        } else {
            stopInteraction(uid);
        }
    }

    private void stopInteraction(final int uid) {
        doConfigEngine(Constants.CLIENT_ROLE_AUDIENCE);

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                ImageView button1 = (ImageView) findViewById(R.id.switch_broadcasting_id);
                ImageView button2 = (ImageView) findViewById(R.id.mute_local_speaker_id);
                audienceUI(button1, button2);
            }
        }, 1000); // wait for reconfig engine
    }

    private void audienceUI(ImageView button1, ImageView button2) {
        button1.setTag(null);
        button1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Object tag = v.getTag();
                if (tag != null && (boolean) tag) {
                    doSwitchToBroadcaster(false);
                } else {
                    doSwitchToBroadcaster(true);
                }
            }
        });
        button1.clearColorFilter();
        button2.setTag(null);
        button2.setVisibility(View.GONE);
        button2.clearColorFilter();
    }

    private void broadcasterUI(ImageView button1, ImageView button2) {
        button1.setTag(true);
        button1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Object tag = v.getTag();
                if (tag != null && (boolean) tag) {
                    doSwitchToBroadcaster(false);
                } else {
                    doSwitchToBroadcaster(true);
                }
            }
        });
        button1.setColorFilter(getResources().getColor(R.color.agora_blue), PorterDuff.Mode.MULTIPLY);

        button2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Object tag = v.getTag();
                boolean flag = true;
                if (tag != null && (boolean) tag) {
                    flag = false;
                }
                worker().getRtcEngine().muteLocalAudioStream(flag);
                ImageView button = (ImageView) v;
                button.setTag(flag);
                if (flag) {
                    button.setColorFilter(getResources().getColor(R.color.agora_blue), PorterDuff.Mode.MULTIPLY);
                } else {
                    button.clearColorFilter();
                }
            }
        });

        button2.setVisibility(View.VISIBLE);

        initCheckBox();
    }

    public void onVoiceMuteClicked(View view) {
        log.info("onVoiceMuteClicked " + view + " audio_status: " + mAudioMuted);

        RtcEngine rtcEngine = rtcEngine();
        rtcEngine.muteLocalAudioStream(mAudioMuted = !mAudioMuted);

        ImageView iv = (ImageView) view;

        if (mAudioMuted) {
            iv.setColorFilter(getResources().getColor(R.color.agora_blue), PorterDuff.Mode.MULTIPLY);
        } else {
            iv.clearColorFilter();
        }
    }

    @Override
    public void onJoinChannelSuccess(String channel, final int uid, int elapsed) {
        String msg = "onJoinChannelSuccess " + channel + " " + (uid & 0xFFFFFFFFL) + " " + elapsed;
        log.debug(msg);

        notifyMessageChanged(msg);
    }

    @Override
    public void onUserOffline(int uid, int reason) {
        String msg = "onUserOffline " + (uid & 0xFFFFFFFFL) + " " + reason;
        log.debug(msg);

        notifyMessageChanged(msg);

    }

    @Override
    public void onExtraCallback(final int type, final Object... data) {

        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (isFinishing()) {
                    return;
                }

                doHandleExtraCallback(type, data);
            }
        });
    }

    private void doHandleExtraCallback(int type, Object... data) {
        int peerUid;
        boolean muted;

        switch (type) {
            case AGEventHandler.EVENT_TYPE_ON_USER_AUDIO_MUTED: {
                peerUid = (Integer) data[0];
                muted = (boolean) data[1];

                notifyMessageChanged("mute: " + (peerUid & 0xFFFFFFFFL) + " " + muted);
                break;
            }

            case AGEventHandler.EVENT_TYPE_ON_AUDIO_QUALITY: {
                peerUid = (Integer) data[0];
                int quality = (int) data[1];
                short delay = (short) data[2];
                short lost = (short) data[3];

                notifyMessageChanged("quality: " + (peerUid & 0xFFFFFFFFL) + " " + quality + " " + delay + " " + lost);
                break;
            }

            case AGEventHandler.EVENT_TYPE_ON_SPEAKER_STATS: {
                IRtcEngineEventHandler.AudioVolumeInfo[] infos = (IRtcEngineEventHandler.AudioVolumeInfo[]) data[0];

                if (infos.length == 1 && infos[0].uid == 0) { // local guy, ignore it
                    break;
                }

                StringBuilder volumeCache = new StringBuilder();
                for (IRtcEngineEventHandler.AudioVolumeInfo each : infos) {
                    peerUid = each.uid;
                    int peerVolume = each.volume;

                    if (peerUid == 0) {
                        continue;
                    }

                    volumeCache.append("volume: ").append(peerUid & 0xFFFFFFFFL).append(" ").append(peerVolume).append("\n");
                }

                if (volumeCache.length() > 0) {
                    String volumeMsg = volumeCache.substring(0, volumeCache.length() - 1);
                    notifyMessageChanged(volumeMsg);

                    if ((System.currentTimeMillis() / 1000) % 10 == 0) {
                        log.debug(volumeMsg);
                    }
                }
                break;
            }

            case AGEventHandler.EVENT_TYPE_ON_APP_ERROR: {
                int subType = (int) data[0];

                if (subType == ConstantApp.AppError.NO_NETWORK_CONNECTION) {
                    showLongToast(getString(R.string.msg_no_network_connection));
                }

                break;
            }

            case AGEventHandler.EVENT_TYPE_ON_AGORA_MEDIA_ERROR: {
                int error = (int) data[0];
                String description = (String) data[1];

                notifyMessageChanged(error + " " + description);

                break;
            }

            case AGEventHandler.EVENT_TYPE_ON_AUDIO_ROUTE_CHANGED: {
                notifyHeadsetPlugged((int) data[0]);

                break;
            }
        }
    }

    public void notifyHeadsetPlugged(final int routing) {
        log.info("notifyHeadsetPlugged " + routing);

        mAudioRouting = routing;

        ImageView iv = (ImageView) findViewById(R.id.switch_speaker_id);
        if (mAudioRouting == 3) { // Speakerphone
            iv.setColorFilter(getResources().getColor(R.color.agora_blue), PorterDuff.Mode.MULTIPLY);
        } else {
            iv.clearColorFilter();
        }
    }

    public void onSoundEffectsClicked(View view) {
        if (mSoundEffectsDialog == null)
            mSoundEffectsDialog = new SoundEffectsDialog(this);

        mSoundEffectsDialog.show(new SoundEffectsPanelClickHandler() {
            @Override
            public void onTargetPitchChanged(double pitch) {
                log.error("wbs->pitch " + pitch);
                rtcEngine().setLocalVoicePitch(pitch); // 0.5, 2
            }

            @Override
            public void onEqualizationBandChanged(int bandIndex, int bandGain) {
                log.error("wbs->onEqualizationBandChanged: band index=" + bandIndex + ", band gain="
                        + bandGain);
                rtcEngine().setLocalVoiceEqualization(bandIndex, bandGain);
            }

            @Override
            public void onReverbParamChanged(int reverbKey, int value) {
                log.error("wbs-> onReverbParamChanged: reverb param key=" + reverbKey + ", reverb value="
                        + value);
                rtcEngine().setLocalVoiceReverb(reverbKey, value);
            }
        });
    }

    private void initCheckBox() {
        mCbUncle = (CheckBox) findViewById(R.id.cb_effect_feature_uncle);
        mCbBoy = (CheckBox) findViewById(R.id.cb_effect_feature_boy);
        mCbBajie = (CheckBox) findViewById(R.id.cb_effect_feature_bajie);
        mCbVacant = (CheckBox) findViewById(R.id.cb_effect_feature_vacant);
        mCbGiant = (CheckBox) findViewById(R.id.cb_effect_feature_giant);
        mCbLolita = (CheckBox) findViewById(R.id.cb_effect_feature_lolita);

        mCbUncle.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                resetAllCheckBox();
                if (isChecked) {
                    mCbUncle.setChecked(true);
                    setCheckedValue(80, -15, 0, 6, 1, -4, 1, -10, -5, 3, 3, 0, 90, 43, -12, -12);
                }
            }
        });

        mCbBoy.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                resetAllCheckBox();
                if (isChecked) {
                    mCbBoy.setChecked(true);
                    setCheckedValue(123, 15, 11, -3, -5, -7, -7, -9, -15, -15, -15, 0, 91, 44, 4, 2);
                }
            }
        });

        mCbBajie.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                resetAllCheckBox();
                if (isChecked) {
                    mCbBajie.setChecked(true);
                    setCheckedValue(60, 12, -9, -9, 3, -3, 11, 1, -8, -8, -9, 34, 0, 39, -14, -8);
                }
            }
        });

        mCbVacant.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                resetAllCheckBox();
                if (isChecked) {
                    mCbVacant.setChecked(true);
                    setCheckedValue(100, -8, -8, 5, 13, 2, 12, -3, 7, -2, -10, 72, 9, 69, -17, -13);
                }
            }
        });

        mCbGiant.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                resetAllCheckBox();
                if (isChecked) {
                    mCbGiant.setChecked(true);
                    setCheckedValue(50, -15, 3, -9, -8, -6, -4, -3, -2, -1, 1, 76, 124, 78, 10, -9);
                }
            }
        });

        mCbLolita.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                resetAllCheckBox();
                if (isChecked) {
                    mCbLolita.setChecked(true);
                    setCheckedValue(145, 10, 6, 1, 1, -6, 13, 7, -14, 13, -13, 0, 31, 44, -11, -7);
                }
            }
        });


        findViewById(R.id.ll_feature_bottom).setVisibility(View.VISIBLE);
        findViewById(R.id.ll_feature_top).setVisibility(View.VISIBLE);
    }

    private void resetAllCheckBox() {
        mCbUncle.setChecked(false);
        mCbBoy.setChecked(false);
        mCbBajie.setChecked(false);
        mCbVacant.setChecked(false);
        mCbGiant.setChecked(false);
        mCbLolita.setChecked(false);

        setCheckedValue(100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    }

    private void setCheckedValue(int pitch,
                                 int e31,
                                 int e62,
                                 int e125,
                                 int e250,
                                 int e500,
                                 int e1k,
                                 int e2k,
                                 int e4k,
                                 int e8k,
                                 int e16k,
                                 int room,
                                 int delay,
                                 int strength,
                                 int dry,
                                 int wet) {
        rtcEngine().setLocalVoicePitch((pitch * 1.f / 100.f) > 0.5f ? (pitch * 1.f / 100.f) : 0.5f);

        rtcEngine().setLocalVoiceEqualization(Constants.AUDIO_EQUALIZATION_BAND_31, e31);
        rtcEngine().setLocalVoiceEqualization(Constants.AUDIO_EQUALIZATION_BAND_62, e62);
        rtcEngine().setLocalVoiceEqualization(Constants.AUDIO_EQUALIZATION_BAND_125, e125);
        rtcEngine().setLocalVoiceEqualization(Constants.AUDIO_EQUALIZATION_BAND_250, e250);
        rtcEngine().setLocalVoiceEqualization(Constants.AUDIO_EQUALIZATION_BAND_500, e500);
        rtcEngine().setLocalVoiceEqualization(Constants.AUDIO_EQUALIZATION_BAND_1K, e1k);
        rtcEngine().setLocalVoiceEqualization(Constants.AUDIO_EQUALIZATION_BAND_2K, e2k);
        rtcEngine().setLocalVoiceEqualization(Constants.AUDIO_EQUALIZATION_BAND_4K, e4k);
        rtcEngine().setLocalVoiceEqualization(Constants.AUDIO_EQUALIZATION_BAND_8K, e8k);
        rtcEngine().setLocalVoiceEqualization(Constants.AUDIO_EQUALIZATION_BAND_16K, e16k);

        rtcEngine().setLocalVoiceReverb(Constants.AUDIO_REVERB_ROOM_SIZE, room);
        rtcEngine().setLocalVoiceReverb(Constants.AUDIO_REVERB_WET_DELAY, delay);
        rtcEngine().setLocalVoiceReverb(Constants.AUDIO_REVERB_STRENGTH, strength);
        rtcEngine().setLocalVoiceReverb(Constants.AUDIO_REVERB_DRY_LEVEL, dry);
        rtcEngine().setLocalVoiceReverb(Constants.AUDIO_REVERB_WET_LEVEL, wet);
    }
}
