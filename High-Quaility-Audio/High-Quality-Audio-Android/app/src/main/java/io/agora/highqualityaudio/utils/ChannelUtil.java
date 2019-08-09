package io.agora.highqualityaudio.utils;

import android.content.Context;

import java.util.ArrayList;
import java.util.List;

import io.agora.highqualityaudio.R;
import io.agora.highqualityaudio.adapters.ChannelListAdapter;

public class ChannelUtil {
    private static final int MAX_CHANNEL = 5;

    private static int[] LIST_BACKGROUND = {
            R.drawable.ch_list_bg_0,
            R.drawable.ch_list_bg_1,
            R.drawable.ch_list_bg_2,
            R.drawable.ch_list_bg_3,
            R.drawable.ch_list_bg_4
    };

    private static int[] ROOM_BACKGROUND = {
            R.drawable.bg_room_0,
            R.drawable.bg_room_1,
            R.drawable.bg_room_2,
            R.drawable.bg_room_3,
            R.drawable.bg_room_4
    };

    public static List<ChannelListAdapter.ChannelItem> genFakeChannels(Context context) {
        String[] names = context.getResources().getStringArray(R.array.channel_titles);
        List<ChannelListAdapter.ChannelItem> list = new ArrayList<>();
        for (int i = 0; i < MAX_CHANNEL; i++) {
            list.add(new ChannelListAdapter.ChannelItem(
                    names[i],
                    LIST_BACKGROUND[i],
                    ROOM_BACKGROUND[i]
            ));
        }
        return list;
    }
}
