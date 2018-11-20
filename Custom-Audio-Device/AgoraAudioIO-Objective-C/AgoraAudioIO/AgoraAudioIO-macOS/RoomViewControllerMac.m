//
//  RoomViewController.m
//  AgoraAudioIO
//
//  Created by suleyu on 2017/12/15.
//  Copyright © 2017 Agora. All rights reserved.
//

#import "RoomViewControllerMac.h"
#import "AppID.h"
#import "ExternalAudio.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

@interface RoomViewControllerMac ()<AgoraRtcEngineDelegate>
@property (unsafe_unretained) IBOutlet NSTextView *logTextView;
@property (weak) IBOutlet NSTextField *channelNameTextField;
@property (weak) IBOutlet NSButton *roleButton;

@property (nonatomic, strong) ExternalAudio *exAudio;
@property (nonatomic, strong) AgoraRtcEngineKit *agoraKit;
@property (nonatomic, assign) BOOL isMute;
@property (nonatomic, assign) BOOL isHost;
@property (nonatomic, assign) int channels;
@end

@implementation RoomViewControllerMac

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _channels = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.channelNameTextField.stringValue = self.channelName;
    [self loadRtcEngine];
    [self joinChannel];
}

- (void)viewDidDisappear {
    [AgoraRtcEngineKit destroy];
}

- (void)setIsHost:(BOOL)isHost {
    _isHost = isHost;
    if (_isHost) {
        [self.roleButton setImage:[NSImage imageNamed:@"host"]];
    }
    else {
        [self.roleButton setImage:[NSImage imageNamed:@"audience"]];
    }
}

- (IBAction)didClickMuteButton:(NSButton *)sender {
    _isMute = !_isMute;
    [self.agoraKit muteLocalAudioStream:_isMute];
    if (!_isMute) {
        sender.image = [NSImage imageNamed:@"unmutemac"];
    } else {
        sender.image = [NSImage imageNamed:@"mute"];
    }
}

- (IBAction)didClickHangUpButton:(NSButton *)sender {
    sender.enabled = NO;
    [self.exAudio stopWork];
    [self.agoraKit leaveChannel:nil];
    [self.delegate roomVCNeedClose:self];
}

- (IBAction)didClickRoleChangedButton:(NSButton *)sender {
    self.isHost = !self.isHost;
    AgoraRtcClientRole role = self.isHost == AgoraRtc_ClientRole_Broadcaster ? AgoraRtc_ClientRole_Broadcaster : AgoraRtc_ClientRole_Audience;
    [self.agoraKit setClientRole:role withKey:nil];
}

- (void)appendToLogView:(NSString*)text {
    NSString *string = [NSString stringWithFormat:@"%@\n", text];
    NSAttributedString* attr = [[NSAttributedString alloc] initWithString:string];
    [[self.logTextView textStorage] appendAttributedString:attr];
    [self.logTextView scrollRangeToVisible:NSMakeRange([[self.logTextView string] length], 0)];
}

- (void)loadRtcEngine {
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:[AppID appID] delegate:self];
    
    if (self.channelMode == ChannelModeLiveBroadcast) {
        self.roleButton.hidden = NO;
        self.isHost = self.role == ClientRoleBroadcast ? YES : NO;
        [self.agoraKit setChannelProfile:AgoraRtc_ChannelProfile_LiveBroadcasting];
        AgoraRtcClientRole role = self.role == ClientRoleBroadcast ? AgoraRtc_ClientRole_Broadcaster : AgoraRtc_ClientRole_Audience;
        [self.agoraKit setClientRole:role withKey:nil];
    }
    
    if (self.audioMode != AudioCRModeSDKCaptureSDKRender) {
        self.exAudio = [ExternalAudio sharedExternalAudio];
        [self.exAudio setupExternalAudioWithAgoraKit:self.agoraKit sampleRate:_sampleRate channels:_channels audioCRMode:self.audioMode IOType:IOUnitTypeVPIO];
    }
    
    switch (self.audioMode) {
        case AudioCRModeExterCaptureSDKRender:
            [self appendToLogView:[NSString stringWithFormat:@"AudioCRModeExterCaptureSDKRender"]];
            [self.agoraKit enableExternalAudioSourceWithSampleRate:_sampleRate channelsPerFrame:_channels];
            break;
            
        case AudioCRModeSDKCaptureExterRender:
            [self appendToLogView:[NSString stringWithFormat:@"AudioCRModeSDKCaptureExterRender"]];
            [self.agoraKit setParameters: @"{\"che.audio.external_capture\": false}"];
            [self.agoraKit setParameters: @"{\"che.audio.external_render\": true}"];
            [self.agoraKit setPlaybackAudioFrameParametersWithSampleRate:(NSInteger)_sampleRate channel:_channels mode:AgoraRtc_RawAudioFrame_OpMode_ReadOnly samplesPerCall:(NSInteger)_sampleRate * _channels * 0.01];
            break;
            
        case AudioCRModeSDKCaptureSDKRender:
            [self appendToLogView:[NSString stringWithFormat:@"AudioCRModeSDKCaptureSDKRender"]];
            [self.agoraKit setParameters: @"{\"che.audio.external_capture\": false}"];
            [self.agoraKit setParameters: @"{\"che.audio.external_render\": false}"];
            break;
            
        case AudioCRModeExterCaptureExterRender:
            [self appendToLogView:[NSString stringWithFormat:@"AudioCRModeExterCaptureExterRender"]];
            [self.agoraKit setParameters: @"{\"che.audio.external_capture\": true}"];
            [self.agoraKit setParameters: @"{\"che.audio.external_render\": true}"];
            [self.agoraKit setRecordingAudioFrameParametersWithSampleRate:(NSInteger)_sampleRate channel:_channels mode:AgoraRtc_RawAudioFrame_OpMode_WriteOnly samplesPerCall:(NSInteger)_sampleRate * _channels * 0.01];
            [self.agoraKit setPlaybackAudioFrameParametersWithSampleRate:(NSInteger)_sampleRate channel:_channels mode:AgoraRtc_RawAudioFrame_OpMode_ReadOnly samplesPerCall:(NSInteger)_sampleRate * _channels * 0.01];
            break;
            
        default:
            break;
    }
}

- (void)joinChannel {
    [self.agoraKit joinChannelByKey:nil channelName:self.channelName info:nil uid:0 joinSuccess:nil];
}

#pragma mark - AgoraRtcEngineDelegate
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString*)channel withUid:(NSUInteger)uid elapsed:(NSInteger) elapsed {
    [self.exAudio startWork];
    [self appendToLogView:[NSString stringWithFormat:@"rtcEngine:didJoinChannel:withUid : %zd", uid]];
}

- (void)rtcEngineConnectionDidInterrupted:(AgoraRtcEngineKit *)engine {
    [self appendToLogView:@"rtcEngineConnectionDidInterrupted"];
}

- (void)rtcEngineConnectionDidLost:(AgoraRtcEngineKit *)engine {
    [self appendToLogView:@"rtcEngineConnectionDidLost"];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraRtcErrorCode)errorCode {
    [self appendToLogView:[NSString stringWithFormat:@"rtcEngine:didOccurError: %zd", errorCode]];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didRejoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    [self appendToLogView:[NSString stringWithFormat:@"rtcEngine:didRejoinChannel:withUid: %zd", uid]];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    [self appendToLogView:[NSString stringWithFormat:@"rtcEngine:didJoinedOfUid: %zd", uid]];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason {
    [self appendToLogView:[NSString stringWithFormat:@"rtcEngine:didOfflineOfUid: %zd, reason:%zd", uid, reason]];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didClientRoleChanged:(AgoraRtcClientRole)oldRole newRole:(AgoraRtcClientRole)newRole {
    NSString *newRoleStr = newRole == AgoraRtc_ClientRole_Audience ? @"Audience" : @"Broadcast";
    [self appendToLogView:[NSString stringWithFormat:@"Self became %@", newRoleStr]];
}

@end
