//
//  EffectTableViewController.h
//  Agora-RTC-With-Voice-Changer-iOS-Objective-C
//
//  Created by ZhangJi on 2018/5/4.
//  Copyright © 2018 ZhangJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AgoraAudioKit/AgoraRtcEngineKit.h>

typedef NS_ENUM(NSInteger, EffectRoles) {
    EffectRolesOldMan = 0,
    EffectRolesBabyBoy = 1,
    EffectRolesZhuBaJie = 2,
    EffectRolesEthereal = 3,
    EffectRolesHulk = 4,
    EffectRolesBabyGily = 5,
    EffectRolesDefault = 6,
};

@interface EffectTableViewController : UITableViewController

@property(strong, nonatomic) AgoraRtcEngineKit *agoraKit;

@end
