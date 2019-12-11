package com.chivox;

import android.content.Context;
import android.content.res.Resources;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import io.agora.pronunciation.R;

public class AIEngineHelper {
    private static final String CONFIG_CREATE = "{" +
            "\"appKey\": \"%s\", " +
            "\"secretKey\": \"%s\", " +
            "\"provision\": \"%s\"," +
            "\"prof\": { " +
                "\"enable\":0, " +
                "\"output\":\"\"" +
            "}, " +
            "\"cloud\":{" +
                "\"enable\":1," +
                "\"server\": \"ws://cloud.chivox.com\"" +
            "}}";

    private static final String CONFIG_START_ENGLISH_WORD = "{" +
            "\"coreProvideType\":\"cloud\"," +
            "\"app\": {" +
                "\"userId\": \"%s\"" +
            "}, " +
            "\"audio\":{" +
                "\"audioType\": \"wav\", " +
                "\"sampleRate\": 16000, " +
                "\"channel\": 1, " +
                "\"sampleBytes\": 2" +
            "}, " +
            "\"request\":{" +
            "\"coreType\": \"en.word.score\", " +
            "\"refText\": \"%s\", " +
            "\"rank\": 100, " +
            "\"attachAudioUrl\": 0}" +
            "}";

    private static final String PROVISION_NAME = "aiengine.provision";
    private static final int BUFFER_SIZE = 128;

    private Context mContext;

    public AIEngineHelper(Context context) {
        mContext = context;
    }

    public long createEngine() {
        Resources resources = mContext.getResources();
        String config = String.format(CONFIG_CREATE,
                resources.getString(R.string.CHIVOX_APP_KEY),
                resources.getString(R.string.CHIVOX_SECRET_KEY),
                getProvisionPath());
        return AIEngine.aiengine_new(config, mContext);
    }

    private String getProvisionPath() {
        File filesDir = mContext.getExternalFilesDir(null);
        File provisionFile = new File(filesDir, PROVISION_NAME);
        if (provisionFile.exists()) {
            return provisionFile.getAbsolutePath();
        }

        BufferedInputStream bis = null;
        BufferedOutputStream bos = null;

        try {
            bis = new BufferedInputStream(
                    mContext.getAssets().open(PROVISION_NAME));
            bos = new BufferedOutputStream(
                    new FileOutputStream(provisionFile));
            int read;
            byte[] buffer = new byte[BUFFER_SIZE];
            while ((read = bis.read(buffer, 0, BUFFER_SIZE)) != -1) {
                bos.write(buffer, 0, read);
            }
            return provisionFile.getAbsolutePath();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (bos != null) {
                try {
                    bos.flush();
                    bos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            if (bis != null) {
                try {
                    bis.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return "";
    }

    public int startTest(long handle, String uid, String reference,
                         AIEngine.aiengine_callback callback) {
        String config = String.format(CONFIG_START_ENGLISH_WORD,
                uid, reference);
        return AIEngine.aiengine_start(handle, config, new byte[64],
                callback, mContext);
    }

    public int feedData(long handle, byte[] data, int size) {
        return AIEngine.aiengine_feed(handle, data, size);
    }

    public int stopTest(long handle) {
        return AIEngine.aiengine_stop(handle);
    }

    public int deleteEngine(long handle) {
        return AIEngine.aiengine_delete(handle);
    }
}
