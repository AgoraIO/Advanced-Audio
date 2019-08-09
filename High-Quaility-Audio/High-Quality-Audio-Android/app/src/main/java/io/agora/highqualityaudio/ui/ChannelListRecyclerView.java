package io.agora.highqualityaudio.ui;

import android.content.Context;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import io.agora.highqualityaudio.R;
import io.agora.highqualityaudio.adapters.ChannelListAdapter;

public class ChannelListRecyclerView extends RecyclerView {
    private static final int SPAN_COUNT = 2;

    private ChannelListAdapter mAdapter;
    private int mItemPadding;

    public ChannelListRecyclerView(@NonNull Context context) {
        super(context);
        init(context);
    }

    public ChannelListRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public ChannelListRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init(context);
    }

    private void init(Context context) {
        mItemPadding = context.getResources().getDimensionPixelSize(
                R.dimen.channel_list_margin_horizontal);
        mAdapter = new ChannelListAdapter(context);
        setAdapter();

        setHasFixedSize(true);
        GridLayoutManager manager = new GridLayoutManager(context, SPAN_COUNT);
        setLayoutManager(manager);

        addItemDecoration(new ItemDecoration() {
            @Override
            public void getItemOffsets(@NonNull Rect outRect, @NonNull View view,
                                       @NonNull RecyclerView parent, @NonNull State state) {
                int pos = parent.getChildAdapterPosition(view);
                int padding = mItemPadding;
                if (pos % 2 == 0) {
                    outRect.right = padding;
                } else {
                    outRect.left = padding;
                }

                if (pos >= SPAN_COUNT) outRect.top = padding;
                outRect.bottom = padding;
            }
        });
    }

    private void setAdapter() {
        setAdapter(mAdapter);
    }

    public void setItemClickListener(ChannelListAdapter.ChannelItemClickListener listener) {
        mAdapter.setItemClickListener(listener);
    }
}
