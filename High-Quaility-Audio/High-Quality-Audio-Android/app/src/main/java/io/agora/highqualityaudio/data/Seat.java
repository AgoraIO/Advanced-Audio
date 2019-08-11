package io.agora.highqualityaudio.data;

public class Seat {
    public static final int VACANT = 1;
    public static final int SPEAKING = 2;
    public static final int MUTE = 3;

    private static final int VACANT_MASK = 0x1;
    private static final int MUTE_MASK = 0x1 << 1;
    private static final int WINDOWS_CLIENT_MASK = 0x1 << 2;

    Seat() {
        this(0, 0);
    }

    Seat(int index) {
        this(index, 0);
    }

    public Seat(int idx, int status) {
        mIdx = idx;
        mState = status;
    }

    public void setWindowsClient(boolean hasClient) {
        if (hasClient) mState |= WINDOWS_CLIENT_MASK;
        else mState &= ~WINDOWS_CLIENT_MASK;
    }

    public boolean hasWindowsClient() {
        return (mState & WINDOWS_CLIENT_MASK) > 0;
    }

    public void setMuted(boolean muted) {
        if (muted) mState |= MUTE_MASK;
        else mState &= ~ MUTE_MASK;
    }

    public boolean isMuted() {
        return (mState & MUTE_MASK) > 0;
    }

    public void setVacant(boolean vacant) {
        if (vacant) mState |= VACANT_MASK;
        else mState &= ~ VACANT_MASK;
        setMuted(false);
        setWindowsClient(false);
    }

    public boolean isVacant() {
        return (mState & VACANT_MASK) > 0;
    }

    private int mIdx;

    private int mState;
}
