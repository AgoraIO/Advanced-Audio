package io.agora.highqualityaudio.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

import io.agora.highqualityaudio.R;
import io.agora.highqualityaudio.utils.ChannelUtil;

public class ChannelListAdapter extends RecyclerView.Adapter {
    private LayoutInflater mInflater;
    private List<ChannelItem> channelList;
    private ChannelItemClickListener mListener;

    public ChannelListAdapter(Context context) {
        initFakeChannels(context);
        mInflater = LayoutInflater.from(context);
    }

    private void initFakeChannels(Context context) {
        channelList = ChannelUtil.genFakeChannels(context);
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = mInflater.inflate(R.layout.channel_list_item, parent, false);
        return new ChannelListItemHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, final int position) {
        ChannelListItemHolder h = (ChannelListItemHolder) holder;
        final ChannelItem item = channelList.get(position);
        h.mBackground.setBackgroundResource(item.getListBgRes());
        h.mTitle.setText(item.getName());
        h.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (mListener != null) {
                    mListener.onChannelItemClicked(position, item);
                }
            }
        });
    }

    @Override
    public int getItemCount() {
        return channelList.size();
    }

    public interface ChannelItemClickListener {
        void onChannelItemClicked(int pos, ChannelItem item);
    }

    public void setItemClickListener(ChannelItemClickListener listener) {
        mListener = listener;
    }

    public static class ChannelItem {
        public ChannelItem(String name, int listBgRes, int roomBgRes) {
            mName = name;
            mListBgRes = listBgRes;
            mRoomBgRes = roomBgRes;
        }

        public String getName() {
            return mName;
        }

        int getListBgRes() {
            return mListBgRes;
        }

        public int getRoomBgRes() {
            return mRoomBgRes;
        }

        private String mName;
        private int mListBgRes;
        private int mRoomBgRes;
    }

    private static class ChannelListItemHolder extends RecyclerView.ViewHolder {
        TextView mBackground;
        TextView mTitle;

        ChannelListItemHolder(@NonNull View itemView) {
            super(itemView);
            mBackground = itemView.findViewById(R.id.channel_list_item_bg);
            mTitle = itemView.findViewById(R.id.channel_list_item_title);
        }
    }
}
