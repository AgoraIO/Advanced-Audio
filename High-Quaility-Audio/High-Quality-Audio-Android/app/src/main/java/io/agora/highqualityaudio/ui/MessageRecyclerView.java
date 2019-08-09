package io.agora.highqualityaudio.ui;

import android.content.Context;
import android.util.AttributeSet;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import io.agora.highqualityaudio.adapters.MessageRecyclerAdapter;
import io.agora.highqualityaudio.data.UserAccountManager;

public class MessageRecyclerView extends RecyclerView {
    private MessageRecyclerAdapter mAdapter;

    public MessageRecyclerView(@NonNull Context context) {
        super(context);
        init(context);
    }

    public MessageRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public MessageRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init(context);
    }

    private void init(Context context) {
        mAdapter = new MessageRecyclerAdapter(context);
        setAdapter(mAdapter);
        LinearLayoutManager manager = new LinearLayoutManager(context);
        manager.setOrientation(VERTICAL);
        setLayoutManager(manager);
    }

    public void setUser(UserAccountManager.UserAccount account) {
        mAdapter.setUser(account);
    }

    public void addMessage(String message) {
        mAdapter.addMessage(message);
    }
}
