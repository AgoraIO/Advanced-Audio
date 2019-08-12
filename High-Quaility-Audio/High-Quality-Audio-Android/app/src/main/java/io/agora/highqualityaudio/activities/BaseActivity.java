package io.agora.highqualityaudio.activities;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.view.Window;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import io.agora.highqualityaudio.AgoraApplication;
import io.agora.highqualityaudio.data.UserAccountManager;
import io.agora.highqualityaudio.rtc.EventHandler;
import io.agora.highqualityaudio.utils.WindowUtil;
import io.agora.rtc.RtcEngine;

public abstract class BaseActivity extends AppCompatActivity {
    private static int REQ_CODE = 1 << 4;

    private String[] PERMISSIONS = {
            Manifest.permission.RECORD_AUDIO,
            Manifest.permission.WRITE_EXTERNAL_STORAGE
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        supportRequestWindowFeature(Window.FEATURE_NO_TITLE);
        super.onCreate(savedInstanceState);
        WindowUtil.hideWindowStatusBar(getWindow());
        checkPermission();
    }

    private void checkPermission() {
        boolean granted = true;
        for (String per : PERMISSIONS) {
            if (!permissionGranted(per)) {
                granted = false;
                break;
            }
        }

        if (granted) {
            onAllPermissionGranted();
        } else {
            requestPermissions();
        }
    }

    private boolean permissionGranted(String permission) {
        return ContextCompat.checkSelfPermission(
                this, permission) == PackageManager.PERMISSION_GRANTED;
    }

    private void requestPermissions() {
        ActivityCompat.requestPermissions(this, PERMISSIONS, REQ_CODE);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String permissions[], @NonNull int[] grantResults) {
        if (requestCode == REQ_CODE) {
            boolean granted = true;
            for (int result : grantResults) {
                granted = (result == PackageManager.PERMISSION_GRANTED);
            }

            if (granted) {
                onAllPermissionGranted();
            } else {
                finish();
            }
        }
    }

    protected abstract void onAllPermissionGranted();

    public AgoraApplication application() { return (AgoraApplication) getApplication(); }

    public UserAccountManager.UserAccount myAccount() { return application().myAccount(); }

    public RtcEngine rtcEngine() { return application().engine(); }

    public void addHandler(EventHandler handler) { application().handler().addHandler(handler); }

    public void removeHandler(EventHandler handler) { application().handler().removeHandler(handler); }
}
