package io.agora.highqualityaudio.ui;

import android.content.Context;
import android.util.AttributeSet;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

import io.agora.highqualityaudio.adapters.SeatListAdapter;

public class SeatListRecyclerView extends RecyclerView {
    private static final int SEAT_SPAN_COUNT = 4;

    private SeatListAdapter mAdapter;

    public SeatListRecyclerView(@NonNull Context context) {
        super(context);
        init(context);
    }

    public SeatListRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public SeatListRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init(context);
    }

    private void init(Context context) {
        GridLayoutManager usrLayoutManager = new GridLayoutManager(context, SEAT_SPAN_COUNT);
        setLayoutManager(usrLayoutManager);
        mAdapter = new SeatListAdapter(context);
        setAdapter(mAdapter);
    }

    /**
     * Add a user to the first available seat
     * @param uid user id
     */
    public void addUser(int uid) {
        mAdapter.addUser(uid);
    }

    public void removeUserByUid(int uid) {
        mAdapter.removeUserByUid(uid);
    }

    public void changeMuteStateByUid(int uid, boolean muted) {
        mAdapter.changeMuteStateByUid(uid, muted);
    }

    /**
     * Update the seat states when a Windows user joins if needed.
     * @param uid windows user uid
     */
    public void updateWindowsClientJoin(int uid) {
        mAdapter.changeStateWithWindowsUidJoin(uid);
    }

    /**
     * Update the seat states when a Windows user leaves if needed.
     * @param uid windows user uid
     */
    public void updateWindowsClientLeave(int uid) {
        mAdapter.changeStateWithWindowsUidLeave(uid);
    }

    public void setOnSeatClickListener(SeatListAdapter.OnSeatClickListener listener) {
        mAdapter.setmOnSeatClickListener(listener);
    }

    /**
     * Start the animation indicating who are speaking
     * @param uidList list of user ids who are speaking
     */
    public void indicateSpeaking(List<Integer> uidList) {
        mAdapter.indicateSpeaking(uidList);
    }

    public void stopIndicateSpeaking() {
        mAdapter.stopIndicateSpeaking();
    }
}
