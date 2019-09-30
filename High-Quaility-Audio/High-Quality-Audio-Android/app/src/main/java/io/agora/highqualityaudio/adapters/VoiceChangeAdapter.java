package io.agora.highqualityaudio.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

import io.agora.highqualityaudio.R;
import io.agora.highqualityaudio.data.ChangeVoiceItem;

public class VoiceChangeAdapter extends RecyclerView.Adapter<VoiceChangeAdapter.ViewHolder> {
    private LayoutInflater mInflater;

    private List<ChangeVoiceItem> mChangeVoiceItems;

    public VoiceChangeAdapter(Context context) {
        this.mInflater = LayoutInflater.from(context);
        initVoiceItems(context);
    }

    private void initVoiceItems(Context context) {
        String[] titles = context.getResources().getStringArray(R.array.sound_effects);
        mChangeVoiceItems = new ArrayList<>(titles.length);
        for (String title : titles) {
            mChangeVoiceItems.add(new ChangeVoiceItem(title));
        }
    }

    @Override
    public VoiceChangeAdapter.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = mInflater.inflate(R.layout.change_voice_item, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, final int position) {
        final ChangeVoiceItem item = mChangeVoiceItems.get(position);
        holder.option.setText(item.getTitle());
        holder.option.setSelected(item.isSelected());
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setSelectedPosition(position);
            }
        });
    }

    @Override
    public int getItemCount() {
        return mChangeVoiceItems.size();
    }

    private void setSelected(int position, boolean selected) {
        if (position < 0 || position >= mChangeVoiceItems.size()) return;
        mChangeVoiceItems.get(position).setSelected(selected);
        notifyDataSetChanged();
    }

    public void setSelectedPosition(int position) {
        for (int i = 0; i < mChangeVoiceItems.size(); i++) {
            mChangeVoiceItems.get(i).setSelected(i == position);
        }
        notifyDataSetChanged();
    }

    public int getSelectedPosition() {
        int position = -1;
        for (int i = 0; i < mChangeVoiceItems.size(); i++) {
            if (mChangeVoiceItems.get(i).isSelected()) {
                position = i;
                break;
            }
        }

        return position;
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        private TextView option;

        ViewHolder(View view) {
            super(view);
            option = view.findViewById(R.id.change_voice_item);
        }
    }
}
