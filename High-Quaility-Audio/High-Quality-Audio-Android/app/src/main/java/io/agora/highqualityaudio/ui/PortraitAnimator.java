package io.agora.highqualityaudio.ui;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;

import io.agora.highqualityaudio.R;

public class PortraitAnimator {
    private static final String TAG = "PortraitAnimator";

    // The delay to run the next animation if not stopped
    private static final int ANIM_DELAY = 1050;

    private static final int MSG_START = 0;
    private static final int MSG_FORCE_STOP = 1;

    private Context mContext;
    private View mLayer1;
    private View mLayer2;

    private Animation mAnimLayer1;
    private Animation mAnimLayer2;

    private boolean mIsRunning;
    private PortraitAnimationHandler mHandler;
    private PortraitAnimationRunnable mRunnable;

    public PortraitAnimator(Context context, View layer1, View layer2) {
        mContext = context;
        mHandler = new PortraitAnimationHandler(mContext.getMainLooper());
        mRunnable = new PortraitAnimationRunnable();
        mLayer1 = layer1;
        mLayer2 = layer2;
        initAnimation();
    }

    private void initAnimation() {
        mAnimLayer1 = AnimationUtils.loadAnimation(
                mContext, R.anim.chat_room_portrait_anim_layer1);
        mAnimLayer2 = AnimationUtils.loadAnimation(
                mContext, R.anim.chat_room_portrait_anim_layer2);
    }

    public void startAnimation() {
        if (!mIsRunning) {
            mIsRunning = true;
            mHandler.post(mRunnable);
            mHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    mIsRunning = false;
                }
            }, ANIM_DELAY);
        }
    }

    public void forceStop() {
        mHandler.sendEmptyMessage(MSG_FORCE_STOP);
    }

    private class PortraitAnimationHandler extends Handler {
        private PortraitAnimationHandler(Looper looper) {
            super(looper);
        }

        @Override
        public void handleMessage(Message msg) {
            if (msg.what == MSG_START) {
                if (!mIsRunning) {
                    mIsRunning = true;
                    mHandler.post(mRunnable);
                    mHandler.postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            mIsRunning = false;
                        }
                    }, ANIM_DELAY);
                }
            } else if (msg.what == MSG_FORCE_STOP) {
                forceStop();
            }
        }

        private void forceStop() {
            mIsRunning = false;
            mLayer1.clearAnimation();
            mLayer2.clearAnimation();
            mLayer1.setVisibility(View.GONE);
            mLayer2.setVisibility(View.GONE);
            mHandler.removeCallbacks(mRunnable);
        }
    }

    private class PortraitAnimationRunnable implements Runnable {
        @Override
        public void run() {
            mLayer1.setVisibility(View.VISIBLE);
            mLayer2.setVisibility(View.VISIBLE);
            mLayer1.startAnimation(mAnimLayer1);
            mLayer2.startAnimation(mAnimLayer2);
        }
    }
}
