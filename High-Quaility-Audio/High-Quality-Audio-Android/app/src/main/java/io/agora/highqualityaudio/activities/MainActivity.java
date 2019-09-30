package io.agora.highqualityaudio.activities;


import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;

import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import io.agora.highqualityaudio.R;
import io.agora.highqualityaudio.adapters.ChannelListAdapter;
import io.agora.highqualityaudio.data.UserAccountManager;
import io.agora.highqualityaudio.ui.ChannelListRecyclerView;
import io.agora.highqualityaudio.utils.Constants;

public class MainActivity extends BaseActivity implements
        ChannelListAdapter.ChannelItemClickListener,
        SwipeRefreshLayout.OnRefreshListener {
    private static final int SWIPE_TIMEOUT = 500;

    private SwipeRefreshLayout mSwipeList;
    private Handler mSwipeHandler;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initUI();
    }

    private void initUI() {
        ChannelListRecyclerView list = findViewById(R.id.main_channel_list);
        list.setItemClickListener(this);

        mSwipeList = findViewById(R.id.main_channel_layout);
        mSwipeList.setOnRefreshListener(this);
        mSwipeHandler = new Handler(getMainLooper());
    }

    @Override
    protected void onAllPermissionGranted() {
        // Nothing to be done here.
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
        mSwipeHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                // There is no server to get the room list, so we
                // finish the refreshing after timeout.
                mSwipeList.setRefreshing(false);
            }
        }, SWIPE_TIMEOUT);
    }
}
