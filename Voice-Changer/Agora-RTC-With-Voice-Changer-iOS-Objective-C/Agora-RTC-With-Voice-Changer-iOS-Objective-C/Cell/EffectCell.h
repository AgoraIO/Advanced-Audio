//
//  EffectCell.h
//  Agora-RTC-With-Voice-Changer-iOS-Objective-C
//
//  Created by ZhangJi on 2018/5/4.
//  Copyright © 2018 ZhangJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AgoraAudioKit/AgoraRtcEngineKit.h>

typedef struct CSRange {
    float minValue;
    float maxValue;
}CSRange;

@class EffectCell;
@protocol EffectCellDelegate <NSObject>
- (void)effectCell:(EffectCell *)effectCell sliderValue:(double)value didChangedAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface EffectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titelLabel;
@property (weak, nonatomic) IBOutlet UISlider *valuaSlider;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) id<EffectCellDelegate> delegate;
@property (assign, nonatomic) NSIndexPath *indexPath;

- (CSRange)rangeOfBandFrequency:(AgoraAudioEqualizationBandFrequency)bandFrequency;

- (CSRange)rangeOfReverType:(AgoraAudioReverbType)reverType;

@end
