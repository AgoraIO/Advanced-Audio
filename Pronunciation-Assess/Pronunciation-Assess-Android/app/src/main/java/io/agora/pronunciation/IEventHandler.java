package io.agora.pronunciation;

public interface IEventHandler {
    void onJoinChannelSuccess(String channel, int uid, int elapsed);
}
