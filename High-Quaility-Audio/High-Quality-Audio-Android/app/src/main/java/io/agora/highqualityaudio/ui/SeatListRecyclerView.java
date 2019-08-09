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
     * @return the index of the seat or -1 if no seat available
     */
    public int addUser(int uid) {
        return mAdapter.addUser(uid);
    }

    /**
     * Add a user to an empty seat of a specific position.
     * This will replace whatever in this seat before.
     * @param position index of the seat
     * @param uid the user id
     * @param state Seat.SPEAKING or Seat.MUTE
     */
    public void addUser(int position, int uid, int state) {
        mAdapter.setTaken(position, uid, state);
    }

    /**
     * Remove the user on a seat and make this seat
     * available for other users.
     * @param position index of the seat
     */
    public void removeUserByPosition(int position) {
        mAdapter.removeUserByPosition(position);
    }

    public void removeUserByUid(int uid) {
        mAdapter.removeUserByUid(uid);
    }

    /**
     * Returns if the user has taken a seat in the list
     * @param uid user id
     */
    public boolean hasUserTaken(int uid) {
        return mAdapter.hasUserTaken(uid);
    }

    public void changeMuteStateByUid(int uid, boolean muted) {
        mAdapter.changeMuteStateByUid(uid, muted);
    }

    public void setOnItemClickListener(SeatListAdapter.OnItemClickListener listener) {
        mAdapter.setOnItemClickListener(listener);
    }

    public void indicateSpeaking(List<Integer> uidList) {
        mAdapter.indicateSpeaking(uidList);
    }

    public void stopIndicateSpeaking() {
        mAdapter.stopIndicateSpeaking();
    }
}
