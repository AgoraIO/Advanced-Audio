package io.agora.highqualityaudio.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

import de.hdodenhof.circleimageview.CircleImageView;
import io.agora.highqualityaudio.R;
import io.agora.highqualityaudio.data.Seat;
import io.agora.highqualityaudio.data.UserAccountManager;
import io.agora.highqualityaudio.ui.PortraitAnimator;

public class SeatListAdapter extends RecyclerView.Adapter<SeatListAdapter.ViewHolder> {
    private static final int MAX_VACANCY = 8;

    private Context mContext;
    private LayoutInflater mInflater;
    private List<Vacancy> mVacancies;
    private OnSeatClickListener mOnSeatClickListener;
    private UserAccountManager.UserAccount mMyAccount;

    public SeatListAdapter(Context context) {
        this.mContext = context;
        this.mInflater = LayoutInflater.from(context);
        mMyAccount = UserAccountManager.INSTANCE.account();
        initVacancies();
    }

    private void initVacancies() {
        mVacancies = new ArrayList<>(MAX_VACANCY);
        for (int i = 0; i < MAX_VACANCY; i++) {
            Seat seat = new Seat(i, Seat.VACANT);
            mVacancies.add(new Vacancy(seat));
        }
    }

    public void setmOnSeatClickListener(OnSeatClickListener listener) {
        mOnSeatClickListener = listener;
    }

    @Override
    public SeatListAdapter.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = mInflater.inflate(R.layout.participants_item, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, final int position) {
        final int pos = holder.getAdapterPosition();
        final View view = holder.itemView;

        final Vacancy vacancy = mVacancies.get(pos);

        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (vacancy.getUser() != null) {
                    if (vacancy.getUser().getUid() == mMyAccount.getUid()) {
                        // Clicking the current user's own avatar
                        // will cause him to leave the seat
                        removeUserByPosition(position);
                        notifyDataSetChanged();
                        if (mOnSeatClickListener != null) {
                            mOnSeatClickListener.onSeatTakenByMyself(
                                    position, view, mMyAccount);
                        }
                    } else if (mOnSeatClickListener != null) {
                        // Nothing will happen in the seat list when
                        // we click other users' avatars.
                        mOnSeatClickListener.onSeatTakenByAnother(
                                position, view, vacancy.getUser());
                    }
                } else {
                    int index = userSeatPosition(mMyAccount.getUid());
                    if (0 <= index && index < MAX_VACANCY &&
                            mOnSeatClickListener != null) {
                        // The user has taken another seat in the list,
                        // so nothing will happen here.
                        mOnSeatClickListener.onUserAlreadyHasSeat(
                                position, index, view, vacancy.getUser());
                    } else {
                        setTaken(position, mMyAccount.getUid(), Seat.SPEAKING);
                        if (mOnSeatClickListener != null) {
                            mOnSeatClickListener.onSeatAvailable(position, view,vacancy.getUser());
                        }
                    }
                }
            }
        });

        vacancy.initAnimator(mContext,
                holder.itemView.findViewById(R.id.chat_room_seat_anim_layer1),
                holder.itemView.findViewById(R.id.chat_room_seat_anim_layer2));

        switch (vacancy.getState()) {
            case Seat.VACANT:
                holder.mAnimLayer1.setVisibility(View.GONE);
                holder.mAnimLayer2.setVisibility(View.GONE);
                holder.imgPortrait.setVisibility(View.GONE);
                holder.imgState.setVisibility(View.VISIBLE);
                holder.imgState.setImageResource(R.drawable.ic_open);
                holder.imgMute.setVisibility(View.GONE);
                break;
            case Seat.MUTE:
                holder.imgPortrait.setVisibility(View.VISIBLE);
                holder.imgPortrait.setImageResource(vacancy.getUser().genAvatarRes());
                holder.imgState.setVisibility(View.GONE);
                holder.imgMute.setVisibility(View.VISIBLE);
                break;
            case Seat.SPEAKING:
                holder.mAnimLayer1.setVisibility(View.VISIBLE);
                holder.mAnimLayer2.setVisibility(View.VISIBLE);
                holder.imgPortrait.setVisibility(View.VISIBLE);
                holder.imgPortrait.setImageResource(vacancy.getUser().genAvatarRes());
                holder.imgState.setVisibility(View.GONE);
                holder.imgMute.setVisibility(View.GONE);
                break;
        }
    }

    @Override
    public int getItemCount() {
        return mVacancies.size();
    }

    public void setTaken(int position, int uid, int state) {
        Vacancy vacancy = mVacancies.get(position);
        vacancy.setUser(new UserAccountManager.UserAccount(uid));
        vacancy.setState(state);
        notifyDataSetChanged();
    }

    /**
     * Whether the user has taken a seat
     * @param uid
     * @return
     */
    public boolean hasUserTaken(int uid) {
        for (int i = 0; i < MAX_VACANCY; i++) {
            if (hasUserTaken(i, uid)) {
                return true;
            }
        }
        return false;
    }

    private int userSeatPosition(int uid) {
        int index = -1;
        for (int i = 0; i < MAX_VACANCY; i++) {
            if (hasUserTaken(i, uid)) {
                index = i;
            }
        }
        return index;
    }

    /**
     * Whether the seat of a specific position
     * is taken by this user
     * @param position
     * @param uid
     * @return
     */
    private boolean hasUserTaken(int position, int uid) {
        UserAccountManager.UserAccount account = mVacancies.get(position).getUser();
        return account != null && account.getUid() == uid;
    }

    public int addUser(int uid) {
        for (int i = 0; i < MAX_VACANCY; i++) {
            Vacancy vacancy = mVacancies.get(i);
            if (vacancy.getUser() == null) {
                vacancy.setUser(new UserAccountManager.UserAccount(uid));
                vacancy.setState(Seat.SPEAKING);
                notifyDataSetChanged();
                return i;
            }
        }

        return -1;
    }

    public void removeUserByPosition(int position) {
        Vacancy vacancy = mVacancies.get(position);
        vacancy.setUser(null);
        vacancy.setState(Seat.VACANT);
        notifyDataSetChanged();
    }

    public void removeUserByUid(int uid) {
        for (int i = 0; i < MAX_VACANCY; i++) {
            Vacancy vacancy = mVacancies.get(i);
            UserAccountManager.UserAccount account = vacancy.getUser();
            if (account != null && account.getUid() == uid) {
                vacancy.setUser(null);
                vacancy.setState(Seat.VACANT);
                notifyDataSetChanged();
            }
        }
    }

    public void changeMuteStateByUid(int uid, boolean muted) {
        for (int i = 0; i < MAX_VACANCY; i++) {
            Vacancy vacancy = mVacancies.get(i);
            UserAccountManager.UserAccount account = vacancy.getUser();
            if (account != null && account.getUid() == uid) {
                vacancy.setState(muted ? Seat.MUTE : Seat.SPEAKING);
                notifyDataSetChanged();
            }
        }
    }

    public void indicateSpeaking(List<Integer> uidList) {
        for (int i = 0; i < MAX_VACANCY; i++) {
            Vacancy vacancy = mVacancies.get(i);
            UserAccountManager.UserAccount account = vacancy.getUser();
            if (account == null) continue;
            if (uidList.contains(account.getUid())) vacancy.startAnimation();
        }
    }

    public void stopIndicateSpeaking() {
        for (int i = 0; i < MAX_VACANCY; i++) {
            Vacancy vacancy = mVacancies.get(i);
            vacancy.stopAnimation();
        }
    }

    class ViewHolder extends RecyclerView.ViewHolder {
        private CircleImageView imgPortrait;
        private ImageView imgState;
        private View mAnimLayer1;
        private View mAnimLayer2;
        private ImageView imgMute;

        ViewHolder(View view) {
            super(view);
            imgPortrait = view.findViewById(R.id.chat_room_img_participant);
            imgState = view.findViewById(R.id.chat_room_state);
            mAnimLayer1 = view.findViewById(R.id.chat_room_seat_anim_layer1);
            mAnimLayer2 = view.findViewById(R.id.chat_room_seat_anim_layer2);
            imgMute = view.findViewById(R.id.chat_room_img_mute);
        }
    }

    public interface OnSeatClickListener {
        /**
         * Called when the seat asked is available and is
         * successfully taken by this caller user
         * @param position
         * @param seat
         * @param account
         */
        void onSeatAvailable(int position, View seat, UserAccountManager.UserAccount account);

        /**
         * Called when the seat asked is already taken by another user
         * @param position
         * @param seat
         * @param account
         */
        void onSeatTakenByAnother(int position, View seat, UserAccountManager.UserAccount account);

        /**
         * Called when the seat is already taken by the caller user
         * @param position
         * @param seat
         * @param account
         */
        void onSeatTakenByMyself(int position, View seat, UserAccountManager.UserAccount account);

        /**
         * Called when the user has taken another seat
         * @param askedPosition
         * @param takenPosition
         * @param seat
         * @param account
         */
        void onUserAlreadyHasSeat(int askedPosition, int takenPosition, View seat, UserAccountManager.UserAccount account);
    }

    public static class Vacancy {
        private Seat mSeat;
        private UserAccountManager.UserAccount mUser;
        private PortraitAnimator mAnimator;

        Vacancy(Seat seat) {
            mSeat = seat;
        }

        UserAccountManager.UserAccount getUser() {
            return mUser;
        }

        void setUser(UserAccountManager.UserAccount user) {
            mUser = user;
        }

        int getState() {
            return mSeat.getStatus();
        }

        private void setState(int state) {
            mSeat.setStatus(state);
        }

        void initAnimator(Context context, View layer1, View layer2) {
            mAnimator = new PortraitAnimator(context, layer1, layer2);
        }

        void startAnimation() {
            if (mAnimator != null) mAnimator.startAnimation();
        }

        void stopAnimation() {
            if (mAnimator != null) mAnimator.forceStop();
        }
    }
}
