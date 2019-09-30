package io.agora.highqualityaudio.rtc;

import java.util.ArrayList;

import io.agora.rtc.IRtcEngineEventHandler;

public class AgoraEventHandler extends IRtcEngineEventHandler {
    private ArrayList<EventHandler> mHandler = new ArrayList<>();

    public void addHandler(EventHandler handler) {
        mHandler.add(handler);
    }

    public void removeHandler(EventHandler handler) {
        mHandler.remove(handler);
    }

    @Override
    public void onJoinChannelSuccess(String channel, int uid, int elapsed) {
        for (EventHandler handler : mHandler) {
            handler.onJoinChannelSuccess(channel, uid, elapsed);
        }
    }

    @Override
    public void onLeaveChannel(RtcStats stats) {
        for (EventHandler handler : mHandler) {
            handler.onLeaveChannel(stats);
        }
    }

    @Override
    public void onUserJoined(int uid, int elapsed) {
        for (EventHandler handler : mHandler) {
            handler.onUserJoined(uid, elapsed);
        }
    }

    @Override
    public void onUserOffline(int uid, int reason) {
        for (EventHandler handler : mHandler) {
            handler.onUserOffline(uid, reason);
        }
    }

    @Override
    public void onAudioVolumeIndication(AudioVolumeInfo[] speakers, int totalVolume) {
        for (EventHandler handler : mHandler) {
            handler.onAudioVolumeIndication(speakers, totalVolume);
        }
    }

    @Override
    public void onUserMuteAudio(int uid, boolean muted) {
        for (EventHandler handler : mHandler) {
            handler.onUserMuteAudio(uid, muted);
        }
    }

    @Override
    public void onRemoteAudioStats(RemoteAudioStats stats) {
        for (EventHandler handler : mHandler) {
            handler.onRemoteAudioStats(stats);
        }
    }

    @Override
    public void onFirstRemoteAudioDecoded(int uid, int elapsed) {
        for (EventHandler handler : mHandler) {
            handler.onFirstRemoteAudioDecoded(uid, elapsed);
        }
    }

    @Override
    public void onClientRoleChanged(int oldRole, int newRole) {
        for (EventHandler handler : mHandler) {
            handler.onClientRoleChanged(oldRole, newRole);
        }
    }
}
