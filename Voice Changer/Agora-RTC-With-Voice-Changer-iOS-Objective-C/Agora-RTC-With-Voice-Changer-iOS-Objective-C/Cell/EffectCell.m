//
//  EffectCell.m
//  Agora-RTC-With-Voice-Changer-iOS-Objective-C
//
//  Created by ZhangJi on 2018/5/4.
//  Copyright © 2018 ZhangJi. All rights reserved.
//

#import "EffectCell.h"

@implementation EffectCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)doValueChanged:(UISlider *)sender {
    self.valueLabel.text = [NSString stringWithFormat:@"%d", (int)sender.value];
    if ([self.delegate respondsToSelector:@selector(effectCell:sliderValue:didChangedAtIndexPath:)]) {
        [self.delegate effectCell:self sliderValue:sender.value didChangedAtIndexPath:self.indexPath];
    }
}

- (CSRange)rangeOfBandFrequency:(AgoraAudioEqualizationBandFrequency)bandFrequency {
    return (CSRange){-15.0, 15.0};
}

- (CSRange)rangeOfReverType:(AgoraAudioReverbType)reverType {
    switch (reverType) {
        case AgoraAudioReverbDryLevel: return (CSRange){-20.0, 10.0};
        case AgoraAudioReverbWetLevel: return (CSRange){-20.0, 10.0};
        case AgoraAudioReverbRoomSize: return (CSRange){0.0, 100.0};
        case AgoraAudioReverbStrength: return (CSRange){0.0, 200.0};
        case AgoraAudioReverbWetDelay: return (CSRange){0.0, 100.0};
    }
}


@end
