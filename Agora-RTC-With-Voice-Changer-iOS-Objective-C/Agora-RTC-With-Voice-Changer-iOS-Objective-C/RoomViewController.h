//
//  RoomViewController.h
//  Agora-RTC-With-Voice-Changer-iOS-Objective-C
//
//  Created by ZhangJi on 2018/5/4.
//  Copyright © 2018 ZhangJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AgoraAudioKit/AgoraRtcEngineKit.h>

@interface RoomViewController : UIViewController

@property (copy, nonatomic) NSString *roomName;
@property (assign, nonatomic) AgoraClientRole clientRole;

@end
