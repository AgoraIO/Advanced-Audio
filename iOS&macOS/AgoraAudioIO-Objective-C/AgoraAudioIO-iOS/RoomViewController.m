//
//  RoomViewController.m
//  AgoraAudioIO
//
//  Created by CavanSu on 2017/9/18.
//  Copyright © 2017 Agora. All rights reserved.
//

#import "RoomViewController.h"
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import "KeyCenter.h"
#import "InfoCell.h"
#import "InfoModel.h"
#import "InfoTableView.h"
#import "AudioController.h"
#import "AudioWriteToFile.h"
#import "LogAudioSessionStatus.h"
#import "ExternalAudio.h"

@interface RoomViewController () <AgoraRtcEngineDelegate>
@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;
@property (weak, nonatomic) IBOutlet InfoTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *roleChangedButton;

@property (nonatomic, strong) AgoraRtcEngineKit *agoraKit;
@property (nonatomic, strong) ExternalAudio *exAudio;
@property (nonatomic, strong) NSMutableArray *infoArray;
@property (nonatomic, assign) int channels;
@end

@implementation RoomViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _channels = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateViews];
    [self loadAgoraKitAndAudioController];
}

#pragma mark - setupViews
- (void)updateViews {
    self.roomNameLabel.text = self.channelName;
    
    // Live Mode
    self.roleChangedButton.hidden = self.channelMode == ChannelModeLiveBroadcast ? NO : YES;
    if (self.roleChangedButton.hidden == YES) return;
    self.roleChangedButton.selected = self.clientRole == ClientRoleAudience ? YES : NO;
}

#pragma mark - initAgoraKitAndInitAudioController
- (void)loadAgoraKitAndAudioController {
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:[KeyCenter AppId] delegate:self];
    
    if (self.channelMode == ChannelModeLiveBroadcast) {
        [self.agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
        AgoraClientRole role = self.clientRole == ClientRoleBroadcast ? AgoraClientRoleBroadcaster : AgoraClientRoleAudience;
        [self.agoraKit setClientRole:role];
    }
    
    if (self.audioMode != AudioCRModeSDKCaptureSDKRender) {
        self.exAudio = [ExternalAudio sharedExternalAudio];
        [self.exAudio setupExternalAudioWithAgoraKit:self.agoraKit sampleRate:_sampleRate channels:_channels audioCRMode:self.audioMode IOType:IOUnitTypeRemoteIO];
    }
  
    switch (self.audioMode) {
        case AudioCRModeExterCaptureSDKRender:
            [self.tableView appendInfoToTableViewWithInfo:[NSString stringWithFormat:@"Audio Mode ExterCapture SDKRender"]];
            [self.agoraKit enableExternalAudioSourceWithSampleRate:_sampleRate channelsPerFrame:_channels];
            break;
            
        case AudioCRModeSDKCaptureExterRender:
            [self.tableView appendInfoToTableViewWithInfo:[NSString stringWithFormat:@"Audio Mode SDKCapture ExterRender"]];
            [self.agoraKit setParameters: @"{\"che.audio.external_capture\": false}"];
            [self.agoraKit setParameters: @"{\"che.audio.external_render\": true}"];
            [self.agoraKit setPlaybackAudioFrameParametersWithSampleRate:(NSInteger)_sampleRate channel:_channels mode:AgoraAudioRawFrameOperationModeReadOnly samplesPerCall:(NSInteger)_sampleRate * _channels * 0.01];
            break;
            
        case AudioCRModeSDKCaptureSDKRender:
            [self.tableView appendInfoToTableViewWithInfo:[NSString stringWithFormat:@"Audio Mode SDKCapture SDKRender"]];
            [self.agoraKit setParameters: @"{\"che.audio.external_capture\": false}"];
            [self.agoraKit setParameters: @"{\"che.audio.external_render\": false}"];
            break;
            
        case AudioCRModeExterCaptureExterRender:
            [self.tableView appendInfoToTableViewWithInfo:[NSString stringWithFormat:@"Audio Mode ExterCapture ExterRender"]];
            [self.agoraKit setParameters: @"{\"che.audio.external_capture\": true}"];
            [self.agoraKit setParameters: @"{\"che.audio.external_render\": true}"];
            [self.agoraKit setRecordingAudioFrameParametersWithSampleRate:(NSInteger)_sampleRate channel:_channels mode:AgoraAudioRawFrameOperationModeWriteOnly samplesPerCall:(NSInteger)_sampleRate * _channels * 0.01];
            [self.agoraKit setPlaybackAudioFrameParametersWithSampleRate:(NSInteger)_sampleRate channel:_channels mode:AgoraAudioRawFrameOperationModeReadOnly samplesPerCall:(NSInteger)_sampleRate * _channels * 0.01];
            break;
            
        default:
            break;
    }
    
    [self.agoraKit joinChannelByToken:nil channelId:self.channelName info:nil uid:0 joinSuccess:nil];
}

#pragma mark- Click Buttons
- (IBAction)clickMuteButton:(UIButton *)sender {
    [self.agoraKit muteLocalAudioStream:sender.selected];
}

- (IBAction)clickHungUpButton:(UIButton *)sender {
    sender.enabled = NO;
    
    if (self.audioMode != AudioCRModeSDKCaptureSDKRender) {
        [self.exAudio stopWork];
    }
    
    [self.agoraKit leaveChannel:nil];
    [AgoraRtcEngineKit destroy];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickSpeakerButton:(UIButton *)sender {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        sender.selected = NO;
    }
    else {
        [self.agoraKit setEnableSpeakerphone:!sender.selected];
    }
}

- (IBAction)clickRoleChangedButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    AgoraClientRole role = sender.selected == YES ? AgoraClientRoleAudience : AgoraClientRoleBroadcaster;
    [self.agoraKit setClientRole:role];
}

#pragma mark- <AgoraRtcEngineDelegate>
// Current joined success
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString*)channel withUid:(NSUInteger)uid elapsed:(NSInteger) elapsed {
    
    [self.tableView appendInfoToTableViewWithInfo:[NSString stringWithFormat:@"Current joined channel with uid:%zd", uid]];
    [self.agoraKit setEnableSpeakerphone:YES];
   
    if (self.audioMode != AudioCRModeSDKCaptureSDKRender) {
        [self.exAudio startWork];
    }
    
    if (self.audioMode == AudioCRModeExterCaptureExterRender || self.audioMode == AudioCRModeSDKCaptureExterRender) {
        [[AVAudioSession sharedInstance] setPreferredSampleRate:_sampleRate error:nil];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    [self.tableView appendInfoToTableViewWithInfo:[NSString stringWithFormat:@"Uid:%zd joined channel with elapsed:%zd", uid, elapsed]];
}

- (void)rtcEngineConnectionDidInterrupted:(AgoraRtcEngineKit *)engine {
    [self.tableView appendInfoToTableViewWithInfo:@"Connection Did Interrupted"];
}

- (void)rtcEngineConnectionDidLost:(AgoraRtcEngineKit *)engine {
    [self.tableView appendInfoToTableViewWithInfo:@"Connection Did Lost"];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraErrorCode)errorCode {
    [self.tableView appendInfoToTableViewWithInfo:[NSString stringWithFormat:@"Error Code:%zd", errorCode]];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
    [self.tableView appendInfoToTableViewWithInfo:[NSString stringWithFormat:@"Uid:%zd didOffline reason:%zd", uid, reason]];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didRejoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    [self.tableView appendInfoToTableViewWithInfo:[NSString stringWithFormat:@"Current Rejoined Channel"]];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didClientRoleChanged:(AgoraClientRole)oldRole newRole:(AgoraClientRole)newRole {
    NSString *newRoleStr = newRole == AgoraClientRoleAudience ? @"Audience" : @"Broadcast";
    [self.tableView appendInfoToTableViewWithInfo:[NSString stringWithFormat:@"Current became %@", newRoleStr]];
}

#pragma mark - StatusBar Style
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
