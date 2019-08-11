package io.agora.highqualityaudio.activities;


import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;

import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import io.agora.highqualityaudio.R;
import io.agora.highqualityaudio.adapters.ChannelListAdapter;
import io.agora.highqualityaudio.data.UserAccountManager;
import io.agora.highqualityaudio.ui.ChannelListRecyclerView;
import io.agora.highqualityaudio.utils.Constants;

public class MainActivity extends BaseActivity implements
        ChannelListAdapter.ChannelItemClickListener,
        SwipeRefreshLayout.OnRefreshListener {

    // Because we now have no server to get the room list,
    // we finish the refreshing after a fixed delay time.
    private static final int SWIPE_DELAY = 800;

    private SwipeRefreshLayout mSwipeList;
    private Handler mHandler;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initUI();
        initHandler();
    }

    private void initUI() {
        ChannelListRecyclerView list = findViewById(R.id.main_channel_list);
        list.setItemClickListener(this);

        mSwipeList = findViewById(R.id.main_channel_layout);
        mSwipeList.setOnRefreshListener(this);
    }

    private void initHandler() {
        mHandler = new Handler(getMainLooper());
    }

    @Override
    protected void onAllPermissionGranted() {
        Log.i("MainActivity", "All permission granted");
    }

    @Override
    public void onChannelItemClicked(int pos, ChannelListAdapter.ChannelItem item) {
        UserAccountManager.UserAccount account = myAccount();
        Intent intent = new Intent();
        intent.setClass(this, ChatActivity.class);
        intent.putExtra(Constants.BUNDLE_KEY_UID, account.getUid());
        intent.putExtra(Constants.BUNDLE_KEY_PORTRAIT_RES, account.getAvatarRes());
        intent.putExtra(Constants.BUNDLE_KEY_CHANNEL_NAME, item.getName());
        intent.putExtra(Constants.BUNDLE_KEY_BG_RES, item.getRoomBgRes());
        startActivity(intent);
    }

    @Override
    public void onRefresh() {
        mHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                mSwipeList.setRefreshing(false);
            }
        }, SWIPE_DELAY);
    }
}
