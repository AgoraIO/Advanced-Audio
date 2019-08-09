package io.agora.highqualityaudio.data;

public class Seat {
    public static final int VACANT = 1;
    public static final int SPEAKING = 2;
    public static final int MUTE = 3;

    public Seat(int idx, int status) {
        this.mIdx = idx;
        this.mStatus = status;
    }

    public int getIndex() {
        return mIdx;
    }

    public void setIndex(int idx) {
        this.mIdx = idx;
    }

    public int getStatus() {
        return mStatus;
    }

    public void setStatus(int status) {
        this.mStatus = status;
    }

    private int mIdx;

    private int mStatus;
}
