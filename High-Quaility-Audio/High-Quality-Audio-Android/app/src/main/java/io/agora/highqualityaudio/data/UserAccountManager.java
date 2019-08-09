package io.agora.highqualityaudio.data;

import java.util.Random;

import io.agora.highqualityaudio.R;
import io.agora.highqualityaudio.utils.Constants;

public enum UserAccountManager {
    INSTANCE;

    private UserAccount mAccount;

    UserAccountManager() {
        mAccount = new UserAccount();
    }

    public UserAccount account() {
        return mAccount;
    }

    public static int genAvatarRes(int uid) {
        return Constants.AVATAR_RES[uid % Constants.AVATAR_COUNT];
    }

    public static class UserAccount {
        private static int ANDROID_BIT = 1000;
        private int mUid;
        private int mAvatarRes;

        UserAccount() {
            mUid = genAndroidUid();
            mAvatarRes = UserAccountManager.genAvatarRes(mUid);
        }

        public UserAccount(int uid) {
            mUid = uid;
            mAvatarRes = UserAccountManager.genAvatarRes(mUid);
        }

        public int getUid() {
            return mUid;
        }

        public int genAvatarRes() {
            return mAvatarRes;
        }

        private int genAndroidUid() {
            return ANDROID_BIT + (int) (ANDROID_BIT * new Random().nextDouble());
        }
    }
}
