package io.agora.highqualityaudio.data;

public class ChangeVoiceItem {
    private String title;
    private boolean isSelected;

    private ChangeVoiceItem(String title, boolean isSelected) {
        this.title = title;
        this.isSelected = isSelected;
    }

    public ChangeVoiceItem(String title) {
        this(title, false);
    }

    public String getTitle() {
        return title;
    }

    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }
}
