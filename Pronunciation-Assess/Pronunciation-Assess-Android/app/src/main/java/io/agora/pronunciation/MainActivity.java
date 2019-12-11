package io.agora.pronunciation;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import com.chivox.AIEngine;

import org.json.JSONException;
import org.json.JSONObject;

import io.agora.pronunciation.langurage.english.WordRandomizer;
import io.agora.rtc.Constants;
import io.agora.rtc.IAudioFrameObserver;
import io.agora.rtc.IRtcEngineEventHandler;

public class MainActivity extends BaseActivity
        implements IEventHandler, IAudioFrameObserver, AIEngine.aiengine_callback {
    private static final String DEFAULT_CHANNEL = "pronunciation assessment";
    private static final int SAMPLE_RATE = 16000;
    private static final int CHANNEL = 1;
    private static final int SAMPLES_PER_CALL = 1600;

    private TextView mRandomWordText;
    private TextView mResultText;
    private String mOverallHint;

    private String mUid;
    private volatile boolean mTestStarted;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initUI();
    }

    private void initUI() {
        setContentView(R.layout.activity_main);
        mRandomWordText = findViewById(R.id.word_text);
        mResultText = findViewById(R.id.result_text);
        mOverallHint = getResources().getString(R.string.result_hint);
    }

    @Override
    protected void onRtcEngineCreated() {
        registerEventHandler(this);
        rtcEngine().setRecordingAudioFrameParameters(SAMPLE_RATE, CHANNEL,
                Constants.RAW_AUDIO_FRAME_OP_MODE_READ_ONLY, SAMPLES_PER_CALL);
        rtcEngine().registerAudioFrameObserver(this);
        rtcEngine().joinChannel(null, DEFAULT_CHANNEL, "", 0);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        removeEventHandler(this);
        rtcEngine().leaveChannel();
    }

    @Override
    public void onJoinChannelSuccess(String channel, int uid, int elapsed) {
        mUid = String.valueOf(uid & 0xFFFFFFFFL);
    }

    @Override
    public boolean onRecordFrame(byte[] samples, int numOfSamples, int bytesPerSample, int channels, int samplesPerSec) {
        if (mTestStarted) {
            aiEngineHelper().feedData(aiEngineHandle(), samples, samples.length);
        }
        return true;
    }

    @Override
    public boolean onPlaybackFrame(byte[] samples, int numOfSamples, int bytesPerSample, int channels, int samplesPerSec) {
        return false;
    }

    @Override
    public int run(byte[] id, int type, byte[] data, int size) {
        if (type == AIEngine.AIENGINE_MESSAGE_TYPE_JSON) {
            final String overallText = mOverallHint + getOverallMark(data);
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    mResultText.setText(overallText);
                }
            });
        }
        return 0;
    }

    private int getOverallMark(byte[] data) {
        try {
            JSONObject object = new JSONObject(new String(data));
            JSONObject resultObj = object.getJSONObject("result");
            return resultObj.getInt("overall");
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public void onPickWord(View view) {
        mRandomWordText.setText(WordRandomizer.pickRandomWord());
        mResultText.setText("");
    }

    public void onStartTestWord(View view) {
        mTestStarted = true;
        mResultText.setText("");
        aiEngineHelper().startTest(aiEngineHandle(), mUid,
                mRandomWordText.getText().toString(), this);
    }

    public void onStopTestWord(View view) {
        mTestStarted = false;
        aiEngineHelper().stopTest(aiEngineHandle());
    }
}
