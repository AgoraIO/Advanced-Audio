package io.agora.voice.changer.ui;

import android.app.AlertDialog;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.SeekBar;
import android.widget.TextView;

import io.agora.rtc.Constants;
import io.agora.voice.changer.R;

public class SoundEffectsDialog {
    private Context mCtx;

    private SoundEffectsPanelClickHandler mUserEventHandler;

    public SoundEffectsDialog(Context ctx) {
        mCtx = ctx;
    }

    public synchronized void show(SoundEffectsPanelClickHandler handler) {
        AlertDialog.Builder builder;
        AlertDialog alertDialog;
        View layout = LayoutInflater.from(mCtx).inflate(R.layout.effect_dialog, null);

        mUserEventHandler = handler;

        SeekBar amlPitch = (SeekBar) layout.findViewById(R.id.audio_mixing_pitch_value_bar);
        final TextView pitchValueView = (TextView) layout.findViewById(R.id.pitch_value_of_audio_mixing);
        int maxPitchValue = (int) (2.0f * 100.0f);
        amlPitch.setMax(maxPitchValue);
        pitchValueView.setText("" + amlPitch.getProgress() * 1.f / 100.f);
        amlPitch.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                if (fromUser) {
                    double realValue = progress * 1.f / 100.f;

                    if (realValue < 0.5f) {
                        realValue = 0.5f;
                        seekBar.setProgress((int) (0.5f * 100.0f));
                    }

                    pitchValueView.setText("" + realValue);
                    mUserEventHandler.onTargetPitchChanged(realValue);
                }
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });

        showEqualizationBandSeekBar(layout, Constants.AUDIO_EQUALIZATION_BAND_31,
                R.id.equalization_band31_value_bar, R.id.equalization_band31_tv);

        showEqualizationBandSeekBar(layout, Constants.AUDIO_EQUALIZATION_BAND_62,
                R.id.equalization_band62_value_bar, R.id.equalization_band62_tv);
        showEqualizationBandSeekBar(layout, Constants.AUDIO_EQUALIZATION_BAND_125,
                R.id.equalization_band125_value_bar, R.id.equalization_band125_tv);
        showEqualizationBandSeekBar(layout, Constants.AUDIO_EQUALIZATION_BAND_250,
                R.id.equalization_band250_value_bar, R.id.equalization_band250_tv);
        showEqualizationBandSeekBar(layout, Constants.AUDIO_EQUALIZATION_BAND_500,
                R.id.equalization_band500_value_bar, R.id.equalization_band500_tv);
        showEqualizationBandSeekBar(layout, Constants.AUDIO_EQUALIZATION_BAND_1K,
                R.id.equalization_band1k_value_bar, R.id.equalization_band1k_tv);
        showEqualizationBandSeekBar(layout, Constants.AUDIO_EQUALIZATION_BAND_2K,
                R.id.equalization_band2k_value_bar, R.id.equalization_band2k_tv);
        showEqualizationBandSeekBar(layout, Constants.AUDIO_EQUALIZATION_BAND_4K,
                R.id.equalization_band4k_value_bar, R.id.equalization_band4k_tv);
        showEqualizationBandSeekBar(layout, Constants.AUDIO_EQUALIZATION_BAND_8K,
                R.id.equalization_band8k_value_bar, R.id.equalization_band8k_tv);
        showEqualizationBandSeekBar(layout, Constants.AUDIO_EQUALIZATION_BAND_16K,
                R.id.equalization_band16k_value_bar, R.id.equalization_band16k_tv);

        showReverbSeekBar(layout, Constants.AUDIO_REVERB_DRY_LEVEL,
                R.id.reverb_dry_level_value_bar, R.id.reverb_dry_level_tv);
        showReverbSeekBar(layout, Constants.AUDIO_REVERB_WET_LEVEL,
                R.id.reverb_wet_level_value_bar, R.id.reverb_wet_level_tv);
        showReverbSeekBar(layout, Constants.AUDIO_REVERB_ROOM_SIZE,
                R.id.reverb_size_value_bar, R.id.reverb_size_tv);
        showReverbSeekBar(layout, Constants.AUDIO_REVERB_WET_DELAY,
                R.id.reverb_delay_value_bar, R.id.reverb_delay_tv);
        showReverbSeekBar(layout, Constants.AUDIO_REVERB_STRENGTH,
                R.id.reverb_strength_value_bar, R.id.reverb_strength_tv);

        builder = new AlertDialog.Builder(mCtx);
        builder.setView(layout);
        alertDialog = builder.create();
        alertDialog.show();
    }

    private void showEqualizationBandSeekBar(View layout, final int band_index, int seekBarId, int tvId) {
        SeekBar equalBand = (SeekBar) layout.findViewById(seekBarId);
        final TextView bandValueView = (TextView) layout.findViewById(tvId);
        int maxBandValue = 30;
        equalBand.setMax(maxBandValue);
        bandValueView.setText("" + (equalBand.getProgress() - 15));
        equalBand.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                if (fromUser) {
                    int realValue = progress - 15;

                    bandValueView.setText("" + realValue);

                    mUserEventHandler.onEqualizationBandChanged(band_index, realValue);
                }
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });

//        switch (band_index) {
//            case Constants.AUDIO_EQUALIZATION_BAND_31:
//                equalBand.setProgress(mBean.equalizationBand31);
//                break;
//            case Constants.AUDIO_EQUALIZATION_BAND_62:
//                equalBand.setProgress(mBean.equalizationBand62);
//                break;
//            case Constants.AUDIO_EQUALIZATION_BAND_250:
//                equalBand.setProgress(mBean.equalizationBand250);
//                break;
//            case Constants.AUDIO_EQUALIZATION_BAND_500:
//                equalBand.setProgress(mBean.equalizationBand500);
//                break;
//            case Constants.AUDIO_EQUALIZATION_BAND_1K:
//                equalBand.setProgress(mBean.equalizationBand1k);
//                break;
//            case Constants.AUDIO_EQUALIZATION_BAND_2K:
//                equalBand.setProgress(mBean.equalizationBand2k);
//                break;
//            case Constants.AUDIO_EQUALIZATION_BAND_4K:
//                equalBand.setProgress(mBean.equalizationBand4k);
//                break;
//            case Constants.AUDIO_EQUALIZATION_BAND_8K:
//                equalBand.setProgress(mBean.equalizationBand8k);
//                break;
//            case Constants.AUDIO_EQUALIZATION_BAND_16K:
//                equalBand.setProgress(mBean.equalizationBand16k);
//                break;
//            default:
//                break;
//        }
    }

    private void showReverbSeekBar(View view, final int reverbParamKey, int seekBarId, int tvId) {
        SeekBar reverbSb = (SeekBar) view.findViewById(seekBarId);
        final TextView reverbValueView = (TextView) view.findViewById(tvId);

        int maxBandValue = 200;
        int defaultValue = 0;
        switch (reverbParamKey) {
            case Constants.AUDIO_REVERB_DRY_LEVEL:
//                reverbSb.setProgress(mBean.reverbDryLevel);
                maxBandValue = 30;
                defaultValue = reverbSb.getProgress() - 20;
                break;
            case Constants.AUDIO_REVERB_WET_LEVEL:
//                reverbSb.setProgress(mBean.reverbWetLevel);
                maxBandValue = 30;
                defaultValue = reverbSb.getProgress() - 20;
                break;
            case Constants.AUDIO_REVERB_ROOM_SIZE:
//                reverbSb.setProgress(mBean.reverbRoomSize);
                maxBandValue = 100;
                defaultValue = reverbSb.getProgress();
                break;
            case Constants.AUDIO_REVERB_STRENGTH:
//                reverbSb.setProgress(mBean.reverbStrength);
                maxBandValue = 100;
                defaultValue = reverbSb.getProgress();
                break;
            case Constants.AUDIO_REVERB_WET_DELAY:
//                reverbSb.setProgress(mBean.reverbDelay);
                maxBandValue = 200;
                defaultValue = reverbSb.getProgress();
                break;
            default:
                break;
        }


        reverbSb.setMax(maxBandValue);
        reverbValueView.setText("" + defaultValue);
        reverbSb.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                if (fromUser) {
                    int realValue = 0;

                    switch (reverbParamKey) {
                        case Constants.AUDIO_REVERB_DRY_LEVEL:
                        case Constants.AUDIO_REVERB_WET_LEVEL:
                            realValue = progress - 20;
                            break;
                        case Constants.AUDIO_REVERB_ROOM_SIZE:
                        case Constants.AUDIO_REVERB_STRENGTH:
                        case Constants.AUDIO_REVERB_WET_DELAY:
                            realValue = progress;
                            break;
                        default:
                            break;
                    }

                    reverbValueView.setText("" + realValue);

                    mUserEventHandler.onReverbParamChanged(reverbParamKey, realValue);
                }
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });
    }
}
