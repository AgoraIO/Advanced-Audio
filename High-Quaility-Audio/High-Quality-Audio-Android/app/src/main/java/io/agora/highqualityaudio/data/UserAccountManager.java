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
        private static final int PLATFORM_ANDROID = 1;
        private static final int PLATFORM_IOS = 2;
        private static final int PLATFORM_WINDOWS = 3;

        static final int ANDROID_BIT = 1000;
        static final int IOS_BIT = 2000;
        static final int WINDOWS_BIT = 3000;

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

        static int getPlatform(int uid) {
            return uid / ANDROID_BIT;
        }

        public static boolean isAndroidUser(int uid) {
            return getPlatform(uid) == PLATFORM_ANDROID;
        }

        public static boolean isIOSUser(int uid) {
            return getPlatform(uid) == PLATFORM_IOS;
        }

        public static boolean isWindowsUser(int uid) {
            return getPlatform(uid) == PLATFORM_WINDOWS;
        }

        public static int toWindowsUid(int uid) {
            return uid % ANDROID_BIT + WINDOWS_BIT;
        }

        public static int toAndroidUid(int uid) {
            return uid % ANDROID_BIT + ANDROID_BIT;
        }

        public static int toIOSUid(int uid) {
            return uid % ANDROID_BIT + IOS_BIT;
        }

        int getPlatform() {
            return getPlatform(mUid);
        }

        boolean isAndroidUser() {
            return getPlatform() == PLATFORM_ANDROID;
        }

        boolean isIOSUser() {
            return getPlatform() == PLATFORM_IOS;
        }

        public boolean isWindowsUser() {
            return getPlatform() == PLATFORM_WINDOWS;
        }

        public int getUid() {
            return mUid;
        }

        public int getAvatarRes() {
            return mAvatarRes;
        }

        private int genAndroidUid() {
            return ANDROID_BIT + (int) (ANDROID_BIT * new Random().nextDouble());
        }
    }
}
