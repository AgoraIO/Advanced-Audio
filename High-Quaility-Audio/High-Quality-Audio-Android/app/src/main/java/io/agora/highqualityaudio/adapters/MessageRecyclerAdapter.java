package io.agora.highqualityaudio.adapters;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

import de.hdodenhof.circleimageview.CircleImageView;
import io.agora.highqualityaudio.R;
import io.agora.highqualityaudio.data.MessageItem;
import io.agora.highqualityaudio.data.UserAccountManager;

public class MessageRecyclerAdapter extends RecyclerView.Adapter<MessageRecyclerAdapter.ViewHolder> {
    private static final int MAX_MSG_COUNT = 20;

    private LayoutInflater mInflater;
    private List<MessageItem> mItems;

    private UserAccountManager.UserAccount mAccount;

    public MessageRecyclerAdapter(Context context) {
        this.mInflater = LayoutInflater.from(context);
        this.mItems = new ArrayList<>();
    }

    @Override
    public MessageRecyclerAdapter.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = mInflater.inflate(R.layout.msg_list_item, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        if (mAccount != null) {
            holder.portrait.setImageResource(mAccount.genAvatarRes());
            String msg = mAccount.getUid() + ": " + mItems.get(position).getMessage();
            holder.message.setText(msg);
        }
    }

    @Override
    public int getItemCount() {
        return mItems.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        CircleImageView portrait;
        TextView message;

        ViewHolder(View view) {
            super(view);
            portrait = view.findViewById(R.id.img_usr_portrait);
            message = view.findViewById(R.id.txt_msg_content);
        }
    }

    public void setUser(UserAccountManager.UserAccount account) {
        mAccount = account;
    }

    public void addMessage(String message) {
        int size = mItems.size();
        if (size >= MAX_MSG_COUNT) mItems.remove(size - 1);
        mItems.add(0, new MessageItem(mAccount.getUid(), message));
        notifyDataSetChanged();
    }
}
