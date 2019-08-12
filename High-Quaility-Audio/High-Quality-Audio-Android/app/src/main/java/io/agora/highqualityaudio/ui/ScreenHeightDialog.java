package io.agora.highqualityaudio.ui;

import android.content.Context;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.Window;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;

import io.agora.highqualityaudio.utils.WindowUtil;

public class ScreenHeightDialog extends AlertDialog {
    public static final int DIALOG_FULL_WIDTH = 0;
    public static final int DIALOG_WIDE = -1;

    // The maximum dialog width in dp
    private static final int WIDE_SCREEN_DP = 240;

    public interface OnDialogListener {
        void onDialogShow(final AlertDialog dialog);
    }

    public ScreenHeightDialog(@NonNull Context context) {
        super(context);
    }

    /**
     * @param res layout resource of the dialog
     * @param width Dialog width on screen in pixel, no wider than
     *        the full screen width.
     *        Use DIALOG_FULL_WIDTH or DIALOG_WIDE for simplicity.
     * @param gravity If the dialog is not full screen width,
     *        gravity is the place to show this dialog, usually
     *        either Gravity.START or Gravity.END
     * @param listener do the initialization in the callback
     */
    public void show(int res, int width, int gravity, OnDialogListener listener) {
        show();

        Window window = getWindow();
        if (window == null) return;

        WindowUtil.hideWindowStatusBar(window);

        window.setLayout(getWidth(window, width),
                WindowManager.LayoutParams.MATCH_PARENT);
        window.setContentView(res);
        window.setBackgroundDrawable(null);

        int gra = gravity == Gravity.START ||
                gravity == Gravity.END ?
                gravity : Gravity.START;
        window.setGravity(gra);

        listener.onDialogShow(this);
    }

    /**
     * Set the dialog full screen wide if the type is DIALOG_FULL_WIDTH
     * or the target width is larger than the actual screen width;
     * Otherwise, the dialog is set to target width, with the maximum
     * width WIDE_SCREEN_DP
     * @param window dialog window
     * @param width target width
     * @return MATCH_PARENT if full screen wide, otherwise the actual width
     *         of the dialog in pixels
     */
    private int getWidth(Window window, int width) {
        if (width == DIALOG_FULL_WIDTH) return WindowManager.LayoutParams.MATCH_PARENT;

        WindowManager manager = window.getWindowManager();
        DisplayMetrics outMetrics = new DisplayMetrics();
        manager.getDefaultDisplay().getMetrics(outMetrics);

        if (width >= outMetrics.widthPixels) {
            return WindowManager.LayoutParams.MATCH_PARENT;
        } else if (width == DIALOG_WIDE) {
            int w = (int) (WIDE_SCREEN_DP * outMetrics.density + 0.5);
            return Math.min(w, outMetrics.widthPixels);
        } else return width;
    }
}
