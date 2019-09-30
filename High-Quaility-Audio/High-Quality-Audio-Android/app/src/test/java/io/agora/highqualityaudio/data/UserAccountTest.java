package io.agora.highqualityaudio.data;

import org.junit.Assert;
import org.junit.Test;

public class UserAccountTest {
    private static final int ANDROID_UID = 1234;
    private static final int IOS_UID = 2843;
    private static final int WINDOWS_UID = 3421;
    private static final int UNKNOWN_UID_1 = 32;
    private static final int UNKNOWN_UID_2 = 54234;

    @Test
    public void TestGenerateRandomAndroidUid() {
        UserAccountManager.UserAccount account = new
                UserAccountManager.UserAccount();
        Assert.assertTrue(account.isAndroidUser());
        Assert.assertTrue(account.getAvatarRes() > 0);
    }

    @Test
    public void TestDeterminePlatform() {
        UserAccountManager.UserAccount account =
                new UserAccountManager.UserAccount(ANDROID_UID);
        Assert.assertTrue(account.isAndroidUser());
        Assert.assertFalse(account.isIOSUser());
        Assert.assertFalse(account.isWindowsUser());

        account = new UserAccountManager.UserAccount(IOS_UID);
        Assert.assertFalse(account.isAndroidUser());
        Assert.assertTrue(account.isIOSUser());
        Assert.assertFalse(account.isWindowsUser());

        account = new UserAccountManager.UserAccount(WINDOWS_UID);
        Assert.assertFalse(account.isAndroidUser());
        Assert.assertFalse(account.isIOSUser());
        Assert.assertTrue(account.isWindowsUser());

        account = new UserAccountManager.UserAccount(UNKNOWN_UID_1);
        Assert.assertFalse(account.isAndroidUser());
        Assert.assertFalse(account.isIOSUser());
        Assert.assertFalse(account.isWindowsUser());

        account = new UserAccountManager.UserAccount(UNKNOWN_UID_2);
        Assert.assertFalse(account.isAndroidUser());
        Assert.assertFalse(account.isIOSUser());
        Assert.assertFalse(account.isWindowsUser());


        Assert.assertTrue(UserAccountManager.UserAccount.isAndroidUser(ANDROID_UID));
        Assert.assertFalse(UserAccountManager.UserAccount.isIOSUser(ANDROID_UID));
        Assert.assertFalse(UserAccountManager.UserAccount.isWindowsUser(ANDROID_UID));

        Assert.assertFalse(UserAccountManager.UserAccount.isAndroidUser(IOS_UID));
        Assert.assertTrue(UserAccountManager.UserAccount.isIOSUser(IOS_UID));
        Assert.assertFalse(UserAccountManager.UserAccount.isWindowsUser(IOS_UID));

        Assert.assertFalse(UserAccountManager.UserAccount.isAndroidUser(WINDOWS_UID));
        Assert.assertFalse(UserAccountManager.UserAccount.isIOSUser(WINDOWS_UID));
        Assert.assertTrue(UserAccountManager.UserAccount.isWindowsUser(WINDOWS_UID));

        Assert.assertFalse(UserAccountManager.UserAccount.isAndroidUser(UNKNOWN_UID_1));
        Assert.assertFalse(UserAccountManager.UserAccount.isIOSUser(UNKNOWN_UID_1));
        Assert.assertFalse(UserAccountManager.UserAccount.isWindowsUser(UNKNOWN_UID_1));

        Assert.assertFalse(UserAccountManager.UserAccount.isAndroidUser(UNKNOWN_UID_2));
        Assert.assertFalse(UserAccountManager.UserAccount.isIOSUser(UNKNOWN_UID_2));
        Assert.assertFalse(UserAccountManager.UserAccount.isWindowsUser(UNKNOWN_UID_2));
    }

    @Test
    public void TestConvertToWindowsUid() {
        int uid = UserAccountManager.UserAccount.toWindowsUid(ANDROID_UID);
        Assert.assertEquals(uid, 3234);

        uid = UserAccountManager.UserAccount.toWindowsUid(IOS_UID);
        Assert.assertEquals(uid, 3843);

        uid = UserAccountManager.UserAccount.toAndroidUid(IOS_UID);
        Assert.assertEquals(uid, 1843);

        uid = UserAccountManager.UserAccount.toAndroidUid(WINDOWS_UID);
        Assert.assertEquals(uid, 1421);

        uid = UserAccountManager.UserAccount.toIOSUid(ANDROID_UID);
        Assert.assertEquals(uid, 2234);

        uid = UserAccountManager.UserAccount.toIOSUid(WINDOWS_UID);
        Assert.assertEquals(uid, 2421);
    }
}
