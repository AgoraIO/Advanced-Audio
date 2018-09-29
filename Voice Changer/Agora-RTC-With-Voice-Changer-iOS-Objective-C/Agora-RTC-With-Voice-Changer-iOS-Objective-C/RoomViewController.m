//
//  RoomViewController.m
//  Agora-RTC-With-Voice-Changer-iOS-Objective-C
//
//  Created by ZhangJi on 2018/5/4.
//  Copyright © 2018 ZhangJi. All rights reserved.
//

#import "RoomViewController.h"
#import "EffectTableViewController.h"
#import "LogCell.h"
#import "AppID.h"

@interface RoomViewController () <UITableViewDelegate, UIPopoverPresentationControllerDelegate, AgoraRtcEngineDelegate>

@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *broadcastButton;
@property (weak, nonatomic) IBOutlet UIButton *muteAudioButton;
@property (weak, nonatomic) IBOutlet UIButton *spaekButton;
@property (weak, nonatomic) IBOutlet UITableView *logTableView;

@property (nonatomic, strong) NSMutableArray *logs;
@property (nonatomic, strong) AgoraRtcEngineKit *agoraKit;

@property (assign, nonatomic) BOOL isBroadcaster;
@property (assign, nonatomic) BOOL speakerEnabled;
@property (assign, nonatomic) BOOL isMuted;

@property(strong, nonatomic) EffectTableViewController *effectVC;

@end

@implementation RoomViewController
- (BOOL)isBroadcaster {
    return self.clientRole == AgoraClientRoleBroadcaster;
}

- (void)setIsMuted:(BOOL)isMuted {
    _isMuted = isMuted;
    [self.agoraKit muteLocalAudioStream:isMuted];
    [self.muteAudioButton setImage:[UIImage imageNamed:(isMuted ? @"btn_mute_blue" : @"btn_mute")] forState:UIControlStateNormal];
}

- (void)setSpeakerEnabled:(BOOL)speakerEnabled {
    _speakerEnabled = speakerEnabled;
    [self.agoraKit setEnableSpeakerphone:speakerEnabled];
    [self.spaekButton setImage:[UIImage imageNamed:speakerEnabled ? @"btn_speaker_blue" : @"btn_speaker"] forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.roomNameLabel.text = self.roomName;
    self.logTableView.rowHeight = UITableViewAutomaticDimension;
    self.logTableView.estimatedRowHeight = 25;
    [self updateButtonsVisiablity];
    [self initAgoraKit];
}

- (void)updateButtonsVisiablity {
    [self.muteAudioButton setEnabled:self.isBroadcaster];
    [self.broadcastButton setImage:[UIImage imageNamed:self.isBroadcaster ? @"btn_join_blue" : @"btn_join"] forState:UIControlStateNormal];
    
}

#pragma mark- initAgoraKit
- (void)initAgoraKit {
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:appID delegate:self];
    [self.agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    
    
    [self.agoraKit setClientRole:self.clientRole];
    [self.agoraKit joinChannelByToken:nil channelId:self.roomName info:nil uid:0 joinSuccess:nil];
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"ToEffect"] && _effectVC) {
        self.effectVC.agoraKit = self.agoraKit;
        self.effectVC.popoverPresentationController.sourceView = sender;
        self.effectVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
        self.effectVC.popoverPresentationController.delegate = self;
        [self presentViewController:self.effectVC animated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueId = segue.identifier;
    
    if ([segueId isEqualToString:@"ToEffect"]) {
        EffectTableViewController *effectVC = segue.destinationViewController;
        effectVC.agoraKit = self.agoraKit;
        effectVC.popoverPresentationController.delegate = self;
        _effectVC = effectVC;
    }
}

#pragma mark- Button Pressed
- (IBAction)doBroadcastPressed:(UIButton *)sender {
    if (self.isBroadcaster) {
        self.clientRole = AgoraClientRoleAudience;
    } else {
        self.clientRole = AgoraClientRoleBroadcaster;
    }
    
    [self.agoraKit setClientRole:self.clientRole];
    [self updateButtonsVisiablity];
}

- (IBAction)doHandupPressed:(UIButton *)sender {
    [self.agoraKit leaveChannel:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doSpeakPressed:(UIButton *)sender {
    self.speakerEnabled = !self.speakerEnabled;
}

- (IBAction)doMutePressed:(UIButton *)sender {
    self.isMuted = !self.isMuted;
}
#pragma mark- Append info to tableView to display
- (void)appendInfoToTableViewWithInfo:(NSString *)infoStr {
    [[self logs] insertObject:infoStr atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.logTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

#pragma mark- <AgoraRtcEngineDelegate>
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString*)channel withUid:(NSUInteger)uid elapsed:(NSInteger) elapsed {
    [self appendInfoToTableViewWithInfo:[NSString stringWithFormat:@"Self join channel with uid:%zd", uid]];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    [self appendInfoToTableViewWithInfo:[NSString stringWithFormat:@"Uid:%zd joined channel with elapsed:%zd", uid, elapsed]];
}

- (void)rtcEngineConnectionDidInterrupted:(AgoraRtcEngineKit *)engine {
    [self appendInfoToTableViewWithInfo:@"ConnectionDidInterrupted"];
}

- (void)rtcEngineConnectionDidLost:(AgoraRtcEngineKit *)engine {
    [self appendInfoToTableViewWithInfo:@"ConnectionDidLost"];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraErrorCode)errorCode {
    [self appendInfoToTableViewWithInfo:[NSString stringWithFormat:@"Error Code:%zd", errorCode]];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
    [self appendInfoToTableViewWithInfo:[NSString stringWithFormat:@"Uid:%zd didOffline reason:%zd", uid, reason]];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didAudioRouteChanged:(AgoraAudioOutputRouting)routing {
    switch (routing) {
        case AgoraAudioOutputRoutingDefault:
            NSLog(@"AgoraRtc_AudioOutputRouting_Default");
            break;
        case AgoraAudioOutputRoutingHeadset:
            NSLog(@"AgoraRtc_AudioOutputRouting_Headset");
            break;
        case AgoraAudioOutputRoutingEarpiece:
            NSLog(@"AgoraRtc_AudioOutputRouting_Earpiece");
            break;
        case AgoraAudioOutputRoutingHeadsetNoMic:
            NSLog(@"AgoraRtc_AudioOutputRouting_HeadsetNoMic");
            break;
        case AgoraAudioOutputRoutingSpeakerphone:
            NSLog(@"AgoraRtc_AudioOutputRouting_Speakerphone");
            break;
        case AgoraAudioOutputRoutingLoudspeaker:
            NSLog(@"AgoraRtc_AudioOutputRouting_Loudspeaker");
            break;
        case AgoraAudioOutputRoutingHeadsetBluetooth:
            NSLog(@"AgoraRtc_AudioOutputRouting_HeadsetBluetooth");
            break;
        default:
            break;
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didClientRoleChanged:(AgoraClientRole)oldRole newRole:(AgoraClientRole)newRole {
    if (newRole == AgoraClientRoleBroadcaster) {
        [self appendInfoToTableViewWithInfo:@"Self changed to Broadcaster"];
    }
    else {
        [self appendInfoToTableViewWithInfo:@"Self changed to Audience"];
    }
}


#pragma mark- <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LogCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"logCell"];
    cell.logLabel.text = self.logs[indexPath.row];
    return cell;
}


#pragma mark- UIPopoverPresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return  UIModalPresentationNone;
}

#pragma mark- others
- (NSMutableArray *)logs {
    if (!_logs) {
        _logs = [NSMutableArray array];
    }
    return _logs;
}
@end
