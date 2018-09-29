//
//  GameViewController.m
//  AgoraEatChicken
//
//  Created by CavanSu on 15/11/2017.
//  Copyright © 2017 Agora. All rights reserved.
//

#include <math.h>
#import <AgoraAudioKit/AgoraRtcEngineKit.h>
#import "GameViewController.h"
#import "RoleView.h"
#import "TouchView.h"
#import "AppID.h"
#import "JsonHandle.h"

@interface GameViewController () <AgoraRtcEngineDelegate, TouchViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic, assign) NSInteger myUid;
@property (nonatomic, assign) int creatDataStreamIsSuccess;
@property (nonatomic, strong) AgoraRtcEngineKit *agoraKit;
@property (nonatomic, strong) NSMutableDictionary *otherRoleDic;
@property (nonatomic, weak) RoleView *myRoleView;
@end

@implementation GameViewController

static NSInteger streamID = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAgoraKit];
}

- (void)initAgoraKit {
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:[AppID appID] delegate:self];
    [self.agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    [self.agoraKit setClientRole:AgoraClientRoleBroadcaster];
   
    [self.agoraKit setDefaultAudioRouteToSpeakerphone:true];
    [self.agoraKit setParameters:@"{\"che.audio.bitrate.level\":2}"];
    [self.agoraKit setAudioProfile:AgoraAudioProfileSpeechStandard scenario:AgoraAudioScenarioChatRoomEntertainment];
    [self.agoraKit joinChannelByToken:nil channelId:self.channelName  info:nil uid:0 joinSuccess:nil];
}

- (IBAction)closeAction:(UIButton *)sender {
    __weak typeof(GameViewController) *weakself = self;
    [self.agoraKit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
        [weakself dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)sendMyPointData {
    if (self.creatDataStreamIsSuccess != 0) return;
    
    NSData *data = [JsonHandle creatJsonWithRect:self.myRoleView.frame uid:self.myUid];
    [self.agoraKit sendStreamMessage:streamID data:data];
    [self iMoveToOther];
}

#pragma mark- <AgoraRtcEngineDelegate>
// Current joined success
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString*)channel withUid:(NSUInteger)uid elapsed:(NSInteger) elapsed {
    self.myUid = uid;
    streamID = uid;
    [self myRoleView];
    
    self.creatDataStreamIsSuccess = [self.agoraKit createDataStream:&streamID reliable:YES ordered:true];
    [self sendMyPointData];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    [self addRoleViewWithUid:uid];
    [self.agoraKit muteRemoteAudioStream:uid mute:YES];
    [self sendMyPointData];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
    [self removeRoleViewWithUid:uid];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine receiveStreamMessageFromUid:(NSUInteger)uid streamId:(NSInteger)streamId data:(NSData *)data {
    CGPoint point = [JsonHandle analyseJsonWithData:data];
    [self updateOtherRoleViewWithPoint:point uid:uid];
}

#pragma mark - <RoleView add, remove and move>
- (void)addRoleViewWithUid:(NSInteger)uid {
    RoleView *view = [self.otherRoleDic objectForKey:@(uid)];
    if (view) return;
    
    RoleView *roleView = [RoleView roleViewWithUid:uid isSelf:NO];
    [self.otherRoleDic setObject:roleView forKey:@(uid)];
    [self.view addSubview:roleView];
}

- (void)removeRoleViewWithUid:(NSInteger)uid {
    RoleView *deletedView = [self.otherRoleDic objectForKey:@(uid)];
    if (!deletedView) return;
    
    [self.otherRoleDic removeObjectForKey:@(uid)];
    [deletedView removeFromSuperview];
}

- (void)iMoveToOther {
    for (RoleView *view in [self.otherRoleDic allValues]) {
        [self otherMoveToMe:view];
    }
}

- (void)otherMoveToMe:(RoleView *)otherView {
    double myRoleCenterX = self.myRoleView.x_CS + self.myRoleView.radius;
    double myRoleCenterY = self.myRoleView.y_CS + self.myRoleView.radius;

    double lineX = fabs(myRoleCenterX - otherView.centerX_CS);
    double lineY = fabs(myRoleCenterY - otherView.centerY_CS);
    double distance =  hypot(lineX, lineY);
    
    if (self.myRoleView.radius >= distance) {

        [self.agoraKit muteRemoteAudioStream:otherView.uid mute:NO];
        
        // pan : - 1 left, 1 right
        double pan = sin(lineY / distance);
        pan = 1 - pan;
        
        if (self.myRoleView.x_CS > otherView.x_CS) {
            pan = -pan;
        }
        
        double gain = 100 / otherView.radius * distance;
        gain = 100 - gain;
        
        NSString *parameters = [NSString stringWithFormat:@"{\"uid\":%ld,\"pan\":%f,\"gain\":%f}", (long)otherView.uid, pan, gain];
        [self.agoraKit setParameters:[NSString stringWithFormat:@"{\"che.audio.game_place_sound_position\": %@}", parameters]];
    
    }
    else {
        [self.agoraKit muteRemoteAudioStream:otherView.uid mute:YES];
    }

}

- (void)updateOtherRoleViewWithPoint:(CGPoint)point uid:(NSInteger)uid {
    RoleView *roleView = [self.otherRoleDic objectForKey:@(uid)];
    if (!roleView) return;
    
    [UIView animateWithDuration:0.1 animations:^{
        roleView.x_CS = point.x;
        roleView.y_CS = point.y;
    } completion:^(BOOL finished) {
        [self otherMoveToMe:roleView];
    }];
}

#pragma mark - <TouchViewDelegate>
- (void)myRoleViewMove {
    [self sendMyPointData];
}

#pragma mark - Lazy Load
- (RoleView *)myRoleView {
    if (!_myRoleView) {
        RoleView *roleView = [RoleView roleViewWithUid:self.myUid isSelf:YES];
        [self.view addSubview:roleView];
        _myRoleView = roleView;
        
        TouchView *touchView = (TouchView *)self.view;
        touchView.myRoleView = _myRoleView;
        touchView.delegate = self;
    }
    return _myRoleView;
}

- (NSMutableDictionary *)otherRoleDic {
    if (!_otherRoleDic) {
        _otherRoleDic = [NSMutableDictionary dictionary];
    }
    return _otherRoleDic;
}

@end
