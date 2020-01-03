//
//  RoomViewController.h
//  AgoraAudioIO
//
//  Created by CavanSu on 2017/9/18.
//  Copyright © 2017 Agora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioOptions.h"
@interface RoomViewController : UIViewController
@property (nonatomic, assign) AudioCRMode audioMode;
@property (nonatomic, assign) ChannelMode channelMode;
@property (nonatomic, assign) ClientRole clientRole;
@property (nonatomic, assign) int sampleRate;
@property (nonatomic, copy) NSString *channelName;
@end
