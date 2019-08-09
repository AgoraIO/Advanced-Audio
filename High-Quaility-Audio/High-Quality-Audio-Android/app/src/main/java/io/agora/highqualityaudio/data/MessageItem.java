package io.agora.highqualityaudio.data;

public class MessageItem {
    private int mUid;
    private String mMessage;

    public MessageItem(int uid, String message) {
        mUid = uid;
        mMessage = message;
    }

    public int getUid() {
        return mUid;
    }

    public void setUid(int uid) {
        mUid = uid;
    }

    public String getMessage() {
        return mMessage;
    }

    public void setMessage(String message) {
        mMessage = message;
    }
}
