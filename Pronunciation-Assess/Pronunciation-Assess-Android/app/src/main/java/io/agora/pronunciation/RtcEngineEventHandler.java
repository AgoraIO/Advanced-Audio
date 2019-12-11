package io.agora.pronunciation;

import java.util.ArrayList;
import java.util.List;

import io.agora.rtc.IRtcEngineEventHandler;

public class RtcEngineEventHandler extends IRtcEngineEventHandler {
    private List<IEventHandler> mHandlers = new ArrayList<>();

    public void registerEventHandler(IEventHandler handler) {
        if (!mHandlers.contains(handler)) {
            mHandlers.add(handler);
        }
    }

    public void removeEventHandler(IEventHandler handler) {
        mHandlers.remove(handler);
    }

    @Override
    public void onJoinChannelSuccess(String channel, int uid, int elapsed) {
        for (IEventHandler handler : mHandlers) {
            handler.onJoinChannelSuccess(channel, uid, elapsed);
        }
    }
}
