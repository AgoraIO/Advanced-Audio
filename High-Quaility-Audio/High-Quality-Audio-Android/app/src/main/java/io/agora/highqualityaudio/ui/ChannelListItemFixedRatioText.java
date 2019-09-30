package io.agora.highqualityaudio.ui;

import android.content.Context;
import android.util.AttributeSet;

import androidx.appcompat.widget.AppCompatTextView;

public class ChannelListItemFixedRatioText extends AppCompatTextView {
    // Ratio (height over width) that is used to avoid the
    // list item backgrounds being distorted.
    // Strongly related to the actual width and height of the
    // background images being used.
    private static final float ITEM_BG_RATIO = 141 / (float) 160;

    public ChannelListItemFixedRatioText(Context context) {
        super(context);
    }

    public ChannelListItemFixedRatioText(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public ChannelListItemFixedRatioText(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int width = getMeasuredWidth();
        int height = (int) (width * ITEM_BG_RATIO);
        setMeasuredDimension(widthMeasureSpec, height);
    }
}
