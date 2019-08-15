package io.agora.highqualityaudio.activities;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

import io.agora.highqualityaudio.R;
import io.agora.highqualityaudio.adapters.SeatListAdapter;
import io.agora.highqualityaudio.data.UserAccountManager;
import io.agora.highqualityaudio.rtc.EventHandler;
import io.agora.highqualityaudio.ui.MessageRecyclerView;
import io.agora.highqualityaudio.ui.ScreenHeightDialog;
import io.agora.highqualityaudio.ui.SeatListRecyclerView;
import io.agora.highqualityaudio.ui.VoiceChangeRecyclerView;
import io.agora.highqualityaudio.utils.Constants;
import io.agora.highqualityaudio.utils.SoundEffectUtil;
import io.agora.rtc.IRtcEngineEventHandler;

public class ChatActivity extends BaseActivity implements EventHandler  {
    private static final String TAG = ChatActivity.class.getSimpleName();

    // channel and current user info passed through bundle
    private String mRoomName;
    private int mBackgroundRes;
    private int mPortraitRes;
    private int mMyUid;

    private int mLastSelectedVoice = -1;

    private SeatListRecyclerView mSeatRecyclerView;

    private HashSet<Integer> mWindowsUsers = new HashSet<>();

    private MessageRecyclerView mMessageView;
    private EditText mMessageEdit;
    private ImageView mSpeakerBtn;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_chat_room);
        initUI();
    }

    private void getIntentData() {
        Intent intent = getIntent();
        mRoomName = intent.getStringExtra(Constants.BUNDLE_KEY_CHANNEL_NAME);
        mBackgroundRes = intent.getIntExtra(Constants.BUNDLE_KEY_BG_RES, 0);
        mPortraitRes = intent.getIntExtra(Constants.BUNDLE_KEY_PORTRAIT_RES, 0);
        mMyUid = intent.getIntExtra(Constants.BUNDLE_KEY_UID, 0);
    }

    private void initUI() {
        TextView title = findViewById(R.id.chat_room_name);
        title.setText(mRoomName);

        RelativeLayout roomLayout = findViewById(R.id.chat_room_layout);
        roomLayout.setBackgroundResource(mBackgroundRes);

        final ImageView portrait = findViewById(R.id.chat_room_portrait);
        portrait.setImageResource(mPortraitRes);

        TextView userName = findViewById(R.id.chat_room_user_name);
        String nameString = getResources().getString(R.string.room_user_hint) + mMyUid;
        userName.setText(nameString);

        mSeatRecyclerView = findViewById(R.id.chat_room_recycler_participants);
        mSeatRecyclerView.setOnSeatClickListener(new SeatListAdapter.OnSeatClickListener() {
            @Override
            public void onSeatAvailable(int position, View seat, UserAccountManager.UserAccount account) {
                // When successfully take a seat, check if there exists my windows client
                int winUid = UserAccountManager.UserAccount.toWindowsUid(myAccount().getUid());
                if (mWindowsUsers.contains(winUid)) mSeatRecyclerView.updateWindowsClientJoin(winUid);
                startBroadcasting();
            }

            @Override
            public void onSeatTakenByAnother(int position, View seat, UserAccountManager.UserAccount account) {
                mMessageView.addMessage(String.format(getString(R.string.seat_taken), position));
            }

            @Override
            public void onSeatTakenByMyself(int position, View seat, UserAccountManager.UserAccount account) {
                endBroadcasting();
            }

            @Override
            public void onUserAlreadyHasSeat(int askedPosition, int takenPosition, View seat, UserAccountManager.UserAccount account) {
                mMessageView.addMessage(String.format(getString(R.string.warn_user_has_taken_a_seat), takenPosition));
            }
        });

        mMessageView = findViewById(R.id.chat_room_recycler_msg_list);

        // Note that we only accept messages from the current
        // user because this demo has no server for receiving
        // the other users' messages
        mMessageView.setUser(myAccount());

        mMessageEdit = findViewById(R.id.chat_room_message_edit);

        mSpeakerBtn = findViewById(R.id.chat_room_speaker);

        // Mute button will be disabled for audience
        mSpeakerBtn.setEnabled(false);
        mSpeakerBtn.setActivated(false);

        ImageView muteBtn = findViewById(R.id.chat_room_sound);
        muteBtn.setActivated(true);
    }

    private void startBroadcasting() {
        mSpeakerBtn.setEnabled(true);
        mSpeakerBtn.setActivated(true);
        rtcEngine().setClientRole(io.agora.rtc.Constants.CLIENT_ROLE_BROADCASTER);
    }

    private void endBroadcasting() {
        mSpeakerBtn.setActivated(false);
        mSpeakerBtn.setEnabled(false);
        rtcEngine().setClientRole(io.agora.rtc.Constants.CLIENT_ROLE_AUDIENCE);
    }

    public void onSettingClicked(View view) {
        ScreenHeightDialog dialog = new ScreenHeightDialog(this);
        dialog.show(R.layout.dialog_room_config, ScreenHeightDialog.DIALOG_WIDE,
                Gravity.END, new ScreenHeightDialog.OnDialogListener() {
                @Override
                public void onDialogShow(final AlertDialog dialog) {
                    if (dialog.getWindow() == null) return;

                    View.OnClickListener listener = new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            dialog.dismiss();

                            switch (view.getId()) {
                                case R.id.config_room_change_voice_point:
                                    openVoiceChangeDialog();
                                    break;
                                case R.id.config_room_btn_quit:
                                    finish();
                                    break;
                            }
                        }
                    };

                    RelativeLayout changeVoice = dialog.findViewById(
                            R.id.config_room_change_voice_point);
                    changeVoice.setOnClickListener(listener);

                    Button btnQuit = dialog.findViewById(R.id.config_room_btn_quit);
                    btnQuit.setOnClickListener(listener);
                 }
            });
    }

    private void openVoiceChangeDialog() {
        ScreenHeightDialog dialog = new ScreenHeightDialog(this);
        dialog.show(R.layout.dialog_change_voice, ScreenHeightDialog.DIALOG_FULL_WIDTH,
                Gravity.END, new ScreenHeightDialog.OnDialogListener() {
                    @Override
                    public void onDialogShow(final AlertDialog dialog) {
                        final VoiceChangeRecyclerView options =
                                dialog.findViewById(R.id.change_voice_recycler_options);

                        if (mLastSelectedVoice > 0) options.setSelectedPosition(mLastSelectedVoice);

                        View.OnClickListener listener = new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                                switch (view.getId()) {
                                    case R.id.change_voice_back:
                                    case R.id.change_voice_btn_cancel:
                                        dialog.dismiss();
                                        break;
                                    case R.id.change_voice_btn_confirm:
                                        mLastSelectedVoice = options.getSelectedPosition();

                                        // Sound effect indices start from 1, and
                                        // index 0 refers to the original voice.
                                        int position = mLastSelectedVoice + 1;
                                        SoundEffectUtil.changeEffect(application(), position);
                                        dialog.dismiss();
                                        break;
                                }
                            }
                        };

                        ImageView imgBack = dialog.findViewById(R.id.change_voice_back);
                        imgBack.setOnClickListener(listener);
                        Button btnConfirm = dialog.findViewById(R.id.change_voice_btn_confirm);
                        btnConfirm.setOnClickListener(listener);
                        Button btnCancel = dialog.findViewById(R.id.change_voice_btn_cancel);
                        btnCancel.setOnClickListener(listener);
                    }
                });
    }

    public void onBackClicked(View view) {
        finish();
    }

    public void onMicClicked(View view) {
        boolean activated = view.isActivated();
        view.setActivated(!activated);
        rtcEngine().muteLocalAudioStream(activated);
        mSeatRecyclerView.changeMuteStateByUid(mMyUid, activated);
    }

    public void onSpeakerClicked(View view) {
        boolean activated = view.isActivated();
        view.setActivated(!activated);
        rtcEngine().muteAllRemoteAudioStreams(activated);
    }

    public void onSendMessageClicked(View view) {
        if (view.getId() == R.id.chat_room_send_msg) {
            String message = mMessageEdit.getText().toString();
            mMessageView.addMessage(message);
            mMessageEdit.setText("");
        }
    }

    @Override
    protected void onAllPermissionGranted() {
        getIntentData();
        addHandler(this);
        joinChannel();
    }

    private void joinChannel() {
        rtcEngine().setClientRole(io.agora.rtc.Constants.CLIENT_ROLE_AUDIENCE);
        rtcEngine().joinChannel("", mRoomName, "", mMyUid);
    }

    @Override
    public void finish() {
        super.finish();
        removeHandler(this);
        mSeatRecyclerView.stopIndicateSpeaking();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        rtcEngine().leaveChannel();
    }

    @Override
    public void onJoinChannelSuccess(String channel, final int uid, int elapsed) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mMessageView.addMessage(getString(R.string.user_joined_hint));
            }
        });
    }

    @Override
    public void onLeaveChannel(IRtcEngineEventHandler.RtcStats stats) {

    }

    @Override
    public void onUserJoined(final int uid, int elapsed) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                handlePlatformUserJoined(uid);
            }
        });
    }

    private void handlePlatformUserJoined(int uid) {
        Log.i(TAG, "User joined:" + uid);
        if (UserAccountManager.UserAccount.isAndroidUser(uid) ||
                UserAccountManager.UserAccount.isIOSUser(uid)) {
            // A mobile user joins and checks if his windows
            // client is in the channel and update his icon
            mMessageView.addMessage(String.format(
                    getString(R.string.other_joined), uid));
            mSeatRecyclerView.addUser(uid);

            int winUid = UserAccountManager.UserAccount.toWindowsUid(uid);
            if (mWindowsUsers.contains(winUid)) {
                Log.i(TAG, "update windows client state");
                mSeatRecyclerView.updateWindowsClientJoin(winUid);
            }
        } else if (UserAccountManager.UserAccount.isWindowsUser(uid) &&
                !mWindowsUsers.contains(uid)) {
            Log.i(TAG, "Window client");
            mSeatRecyclerView.updateWindowsClientJoin(uid);
            mWindowsUsers.add(uid);
            if (myAccount().getUid() ==
                    UserAccountManager.UserAccount.toAndroidUid(uid)) {
                // If the new user is current window client,
                // don't subscribe it in case of noise interruption
                Log.i(TAG, "mute my windows client");
                rtcEngine().muteRemoteAudioStream(uid, true);
            }
        }
    }

    @Override
    public void onUserOffline(final int uid, int reason) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                handlePlatformUserOffline(uid);
            }
        });
    }

    private void handlePlatformUserOffline(int uid) {
        Log.i(TAG, "User left:" + uid);
        if (UserAccountManager.UserAccount.isAndroidUser(uid) ||
                UserAccountManager.UserAccount.isIOSUser(uid)) {
            mMessageView.addMessage(String.format(
                    getString(R.string.other_left_seat), uid));
            mSeatRecyclerView.removeUserByUid(uid);
        } else if (UserAccountManager.UserAccount.isWindowsUser(uid) &&
            mWindowsUsers.contains(uid)) {
            Log.i(TAG, "update window client state");
            mSeatRecyclerView.updateWindowsClientLeave(uid);
            mWindowsUsers.remove(uid);
        }

    }

    @Override
    public void onAudioVolumeIndication(IRtcEngineEventHandler.AudioVolumeInfo[] speakers, int totalVolume) {
        List<Integer> uidList = new ArrayList<>();
        for (IRtcEngineEventHandler.AudioVolumeInfo info : speakers) {
            if (info.volume <= 0) return;
            if (info.uid == 0) uidList.add(mMyUid);
            else uidList.add(info.uid);
        }
        mSeatRecyclerView.indicateSpeaking(uidList);
    }

    @Override
    public void onUserMuteAudio(final int uid, final boolean muted) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mSeatRecyclerView.changeMuteStateByUid(uid, muted);
            }
        });
    }

    @Override
    public void onRemoteAudioStats(IRtcEngineEventHandler.RemoteAudioStats stats) {

    }

    @Override
    public void onFirstRemoteAudioDecoded(int uid, int elapsed) {

    }

    @Override
    public void onClientRoleChanged(int oldRole, final int newRole) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                int res = -1;
                if (newRole == io.agora.rtc.Constants.CLIENT_ROLE_AUDIENCE) {
                    res = R.string.i_left_seat;
                } else if (newRole == io.agora.rtc.Constants.CLIENT_ROLE_BROADCASTER) {
                    res = R.string.i_can_speak;
                }

                if (res != -1) mMessageView.addMessage(getString(res));
            }
        });
    }
}
