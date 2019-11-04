package io.agora.pronunciation;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.chivox.AIEngineHelper;

import io.agora.rtc.RtcEngine;

public abstract class BaseActivity extends AppCompatActivity {
    private static final int PERMISSION_REQ_CODE = 1;

    private static final String[] PERMISSIONS = {
            Manifest.permission.RECORD_AUDIO,
            Manifest.permission.WRITE_EXTERNAL_STORAGE
    };

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        checkPermissions();
    }

    private void checkPermissions() {
        boolean granted = true;
        for (String permission : PERMISSIONS) {
            if (!checkSinglePermission(permission)) {
                granted = false;
                break;
            }
        }

        if (granted) {
            onRtcEngineCreated();
        } else {
            requestPermissions();
        }
    }

    private boolean checkSinglePermission(String permission) {
        return ContextCompat.checkSelfPermission(
                this, permission) == PackageManager.PERMISSION_GRANTED;
    }

    private void requestPermissions() {
        ActivityCompat.requestPermissions(this, PERMISSIONS, PERMISSION_REQ_CODE);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode,
               @NonNull String permissions[], @NonNull int[] grantResults) {
        if (requestCode == PERMISSION_REQ_CODE) {
            boolean granted = true;
            for (int result : grantResults) {
                granted = (result == PackageManager.PERMISSION_GRANTED);
                if (!granted) break;
            }

            if (granted) {
                onRtcEngineCreated();
            } else {
                toastNeedPermissions();
            }
        }
    }

    protected abstract void onRtcEngineCreated();

    private void toastNeedPermissions() {
        Toast.makeText(this, R.string.need_necessary_permissions, Toast.LENGTH_LONG).show();
    }

    public AgoraApplication application() {
        return (AgoraApplication) getApplication();
    }

    public RtcEngine rtcEngine() {
        return application().rtcEngine();
    }

    public void registerEventHandler(IEventHandler handler) {
        application().registerEventHandler(handler);
    }

    public void removeEventHandler(IEventHandler handler) {
        application().removeEventHandler(handler);
    }

    public AIEngineHelper aiEngineHelper() {
        return application().aiEngineHelper();
    }

    public long aiEngineHandle() {
        return application().aiEngineHandle();
    }
}
