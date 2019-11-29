package io.agora.highqualityaudio.ui;

import android.content.Context;
import android.util.AttributeSet;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

public class VoiceChangeRecyclerView extends RecyclerView {
    private static final int SPAN_COUNT = 3;

    public VoiceChangeRecyclerView(@NonNull Context context) {
        super(context);
        init(context);
    }

    public VoiceChangeRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public VoiceChangeRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init(context);
    }

    private void init(Context context) {
        GridLayoutManager manager = new GridLayoutManager(context, SPAN_COUNT);
        setLayoutManager(manager);
    }
}
