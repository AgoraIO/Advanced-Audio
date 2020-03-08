package io.agora.advancedaudio.customrecorder;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.media.AudioRecord;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

import io.agora.advancedaudio.AgoraApplication;
import io.agora.rtc.RtcEngine;

public class CustomRecorderService extends Service {
    private static final String TAG = CustomRecorderService.class.getSimpleName();

    private RecordThread mThread;
    private volatile boolean mStopped;

    public AgoraApplication application() {
        return (AgoraApplication) getApplication();
    }

    public RtcEngine rtcEngine() {
        return application().rtcEngine();
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        startForeground();
        startRecording();
        return Service.START_STICKY;
    }

    private void startForeground() {
        createNotificationChannel();
        Intent notificationIntent = new Intent(this, CustomRecorderActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this,
                0, notificationIntent, 0);

        Notification notification = new NotificationCompat.Builder(this, TAG)
                .setContentTitle(TAG)
                .setContentIntent(pendingIntent)
                .build();

        startForeground(1, notification);
    }

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel serviceChannel = new NotificationChannel(
                    TAG, TAG, NotificationManager.IMPORTANCE_DEFAULT
            );

            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(serviceChannel);
        }
    }

    private void startRecording() {
        mThread = new RecordThread();
        mThread.start();
    }

    private void stopRecording() {
        mStopped = true;
    }

    @Override
    public void onDestroy() {
        stopRecording();
        super.onDestroy();
    }

    private class RecordThread extends Thread {
        private CustomRecorder mRecorder;
        private byte[] mBuffer;

        RecordThread() {
            mRecorder = new CustomRecorder();
            CustomRecorderConfig config = mRecorder.getConfig();
            mBuffer = new byte[config.getBufferSize()];
        }

        @Override
        public void run() {
            mRecorder.start();
            while (!mStopped) {
                int result = mRecorder.read(mBuffer, 0, mBuffer.length);
                if (result >= 0) {
                    rtcEngine().pushExternalAudioFrame(
                            mBuffer, System.currentTimeMillis());
                } else {
                    logRecordError(result);
                }
            }
            release();
        }

        private void logRecordError(int error) {
            String message = "";
            switch (error) {
                case AudioRecord.ERROR:
                    message = "generic operation failure";
                    break;
                case AudioRecord.ERROR_BAD_VALUE:
                    message = "failure due to the use of an invalid value";
                    break;
                case AudioRecord.ERROR_DEAD_OBJECT:
                    message = "object is no longer valid and needs to be recreated";
                    break;
                case AudioRecord.ERROR_INVALID_OPERATION:
                    message = "failure due to the improper use of method";
                    break;
            }
            Log.e(TAG, message);
        }

        private void release() {
            if (mRecorder != null) {
                mRecorder.stop();
                mBuffer = null;
            }
        }
    }
}
