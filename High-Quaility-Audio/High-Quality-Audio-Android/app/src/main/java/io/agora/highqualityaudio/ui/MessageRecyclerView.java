package io.agora.highqualityaudio.ui;

import android.content.Context;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import io.agora.highqualityaudio.R;
import io.agora.highqualityaudio.adapters.MessageRecyclerAdapter;
import io.agora.highqualityaudio.data.UserAccountManager;

public class MessageRecyclerView extends RecyclerView {
    private MessageRecyclerAdapter mAdapter;
    private int mMessageMargin;

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

        mMessageMargin = context.getResources().
                getDimensionPixelSize(R.dimen.room_message_padding) / 2;
        addItemDecoration(new ItemDecoration() {
            @Override
            public void getItemOffsets(@NonNull Rect outRect, @NonNull View view,
                                       @NonNull RecyclerView parent, @NonNull State state) {
                int pos = parent.getChildAdapterPosition(view);
                outRect.top = mMessageMargin;
                outRect.bottom = mMessageMargin;
                if (pos == 0) outRect.top = 0;
                else if (pos == parent.getChildCount() - 1) outRect.bottom = 0;
            }
        });
    }

    public void setUser(UserAccountManager.UserAccount account) {
        mAdapter.setUser(account);
    }

    public void addMessage(String message) {
        mAdapter.addMessage(message);
    }
}
