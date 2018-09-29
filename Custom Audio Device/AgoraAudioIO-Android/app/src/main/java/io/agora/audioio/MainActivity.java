package io.agora.audioio;

import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RadioGroup;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {
    private final static String TAG = MainActivity.class.getSimpleName();

    private ImageView mIvSetting;

    private RadioGroup mRgItems;
    private AudioEnum mAE = AudioEnum.SDK2SDK;
    private AudioProfile mAP = AudioProfile.AUDIO_PROFILE_44100;
    private int mAudioProfileId = R.id.rb_441000;

    private RadioGroup mRgAudioProfile;
    private RadioGroup mRgChannelProfile;

    private EditText mEtChannelName;
    private String mStrChannelName;

    private int mChannelProfileId = R.id.rb_channel_communication;
    private ChannelProfile mCP = ChannelProfile.CHANNEL_PROFILE_LIVE;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        checkSelfPermission(new String[]{
                Manifest.permission.RECORD_AUDIO,
                Manifest.permission.WRITE_EXTERNAL_STORAGE
        }, 200);
    }

    private void initWidget() {
        mIvSetting = findViewById(R.id.iv_setting);
        mRgItems = findViewById(R.id.rg_audio_items);
        mEtChannelName = findViewById(R.id.et_channel_name);
    }

    private void registerListener() {
        mIvSetting.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AlertDialog.Builder mDB = new AlertDialog.Builder(MainActivity.this);
                View layout = LayoutInflater.from(MainActivity.this).inflate(R.layout.setting_pop, null, false);

                mRgAudioProfile = layout.findViewById(R.id.rg_audio_profile);
                mRgAudioProfile.check(mAudioProfileId);
                mRgAudioProfile.setOnCheckedChangeListener(null);
                mRgAudioProfile.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
                    @Override
                    public void onCheckedChanged(RadioGroup group, int checkedId) {
                        mAudioProfileId = group.getCheckedRadioButtonId();
                        switch (mAudioProfileId) {
                            case R.id.rb_8000:
                                mAP = AudioProfile.AUDIO_PROFILE_8000;
                                break;
                            case R.id.rb_16000:
                                mAP = AudioProfile.AUDIO_PROFILE_16000;
                                break;
                            case R.id.rb_32000:
                                mAP = AudioProfile.AUDIO_PROFILE_32000;
                                break;
                            case R.id.rb_441000:
                                mAP = AudioProfile.AUDIO_PROFILE_44100;
                                break;
                            default:
                                Log.e(TAG, "Audio Profile error");
                        }
                    }
                });

                mRgChannelProfile = layout.findViewById(R.id.rg_channel_profile);
                mRgChannelProfile.check(mChannelProfileId);
                mRgChannelProfile.setOnCheckedChangeListener(null);
                mRgChannelProfile.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
                    @Override
                    public void onCheckedChanged(RadioGroup group, int checkedId) {
                        mChannelProfileId = group.getCheckedRadioButtonId();
                        switch (mChannelProfileId) {
                            case R.id.rb_channel_communication:
                                mCP = ChannelProfile.CHANNEL_PROFILE_COMM;
                                break;
                            case R.id.rb_channel_live:
                                mCP = ChannelProfile.CHANNEL_PROFILE_LIVE;
                                break;
                            default:
                                break;
                        }
                    }
                });

                mDB.setView(layout);
                mDB.create().show();
            }
        });

        mRgItems.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                switch (group.getCheckedRadioButtonId()) {
                    case R.id.rb_a2a:
                        mAE = AudioEnum.App2App;
                        break;
                    case R.id.rb_a2s:
                        mAE = AudioEnum.App2SDK;
                        break;
                    case R.id.rb_s2a:
                        mAE = AudioEnum.SDK2App;
                        break;
                    case R.id.rb_s2s:
                        mAE = AudioEnum.SDK2SDK;
                        break;
                    default:
                        Log.e(TAG, "error on registerListener");
                }
                ToastUtils.show(new WeakReference<Context>(MainActivity.this), "chose:" + mAE.toString());
            }
        });

        mEtChannelName.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (TextUtils.isEmpty(s)) {
                    ToastUtils.show(new WeakReference<Context>(MainActivity.this), "Channel name cannot be null!");
                    return;
                }

                mStrChannelName = s.toString();
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
    }

    public void joinChannel(View v) {
        if (mStrChannelName == null || TextUtils.isEmpty(mStrChannelName)) {
            ToastUtils.show(new WeakReference<Context>(MainActivity.this), "Channel name cannot be null!");
            return;
        }

        Intent forwardToChatRoom = new Intent();
        forwardToChatRoom.putExtra(IOConstants.AUDIO_ENUM, mAE);
        forwardToChatRoom.putExtra(IOConstants.AUDIO_PROFILE, mAP);
        forwardToChatRoom.putExtra(IOConstants.CHANNEL_NAME, mStrChannelName);
        forwardToChatRoom.putExtra(IOConstants.CHANNEL_PROFILE, mCP);

        forwardToChatRoom.setClass(MainActivity.this, ChatRoomActivity.class);
        startActivity(forwardToChatRoom);
    }

    private void initHideSoftKeyBoard() {
        LinearLayout v = findViewById(R.id.ll_main);
        v.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                InputMethodManager inputMethodManager =
                        (InputMethodManager) getSystemService(
                                Activity.INPUT_METHOD_SERVICE);
                if (inputMethodManager != null && getCurrentFocus() != null) {
                    inputMethodManager.hideSoftInputFromWindow(
                            getCurrentFocus().getWindowToken(), 0);
                }
            }
        });
    }

    public void checkSelfPermission(String[] permissions, int requestCode) {
        List<String> temp = new ArrayList<>();
        for (String permission : permissions) {
            if (ContextCompat.checkSelfPermission(this, permission) != PackageManager.PERMISSION_GRANTED)
                temp.add(permission);
        }

        if (ContextCompat.checkSelfPermission(this,
                String.valueOf(temp.toArray()))
                != PackageManager.PERMISSION_GRANTED) {

            ActivityCompat.requestPermissions(this,
                    permissions,
                    requestCode);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == 200) {
            initWidget();
            initHideSoftKeyBoard();
            registerListener();
        }
    }
}
