//
//  RoomViewController.h
//  Agora-RTC-With-ASMR
//
//  Created by CavanSu on 2017/9/18.
//  Copyright © 2017 Agora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomViewController : UIViewController
@property (nonatomic, copy) NSString *channelName;
@property (nonatomic, assign) AudioIOMode audioMode;
@property (nonatomic, assign) int sampleRate;
@property (nonatomic, assign) int channels;
@end
