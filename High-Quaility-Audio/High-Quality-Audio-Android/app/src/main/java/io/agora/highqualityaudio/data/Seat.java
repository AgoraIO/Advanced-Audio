package io.agora.highqualityaudio.data;

public class Seat {
    private static final int VACANT_MASK = 0x1;
    private static final int MUTE_MASK = 0x1 << 1;
    private static final int WINDOWS_CLIENT_MASK = 0x1 << 2;

    public Seat() {
        setVacant(true);
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

    private int mState;
}
