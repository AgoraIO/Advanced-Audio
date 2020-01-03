//
//  RoomViewController.m
//  AgoraAudioIO
//
//  Created by suleyu on 2017/12/15.
//  Copyright © 2017 Agora. All rights reserved.
//

#import "RoomViewControllerMac.h"
#import "KeyCenter.h"
#import "ExternalAudio.h"
#import <AgoraRtcKit/AgoraRtcEngineKit.h>

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
    AgoraClientRole role = self.isHost == AgoraClientRoleBroadcaster ? AgoraClientRoleBroadcaster : AgoraClientRoleAudience;
    [self.agoraKit setClientRole:role];
}

- (void)appendToLogView:(NSString*)text {
    NSString *string = [NSString stringWithFormat:@"%@\n", text];
    NSAttributedString* attr = [[NSAttributedString alloc] initWithString:string];
    [[self.logTextView textStorage] appendAttributedString:attr];
    [self.logTextView scrollRangeToVisible:NSMakeRange([[self.logTextView string] length], 0)];
}

- (void)loadRtcEngine {
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:[KeyCenter AppId] delegate:self];
    
    if (self.channelMode == ChannelModeLiveBroadcast) {
        self.roleButton.hidden = NO;
        self.isHost = self.role == ClientRoleBroadcast ? YES : NO;
        [self.agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
        AgoraClientRole role = self.role == ClientRoleBroadcast ? AgoraClientRoleBroadcaster : AgoraClientRoleAudience;
        [self.agoraKit setClientRole:role];
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
            [self.agoraKit setPlaybackAudioFrameParametersWithSampleRate:(NSInteger)_sampleRate channel:_channels mode:AgoraAudioRawFrameOperationModeReadOnly samplesPerCall:(NSInteger)_sampleRate * _channels * 0.01];
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
            [self.agoraKit setRecordingAudioFrameParametersWithSampleRate:(NSInteger)_sampleRate channel:_channels mode:AgoraAudioRawFrameOperationModeWriteOnly samplesPerCall:(NSInteger)_sampleRate * _channels * 0.01];
            [self.agoraKit setPlaybackAudioFrameParametersWithSampleRate:(NSInteger)_sampleRate channel:_channels mode:AgoraAudioRawFrameOperationModeReadOnly samplesPerCall:(NSInteger)_sampleRate * _channels * 0.01];
            break;
            
        default:
            break;
    }
}

- (void)joinChannel {
    [self.agoraKit joinChannelByToken:nil channelId:self.channelName info:nil uid:0 joinSuccess:nil];
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

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraErrorCode)errorCode {
    [self appendToLogView:[NSString stringWithFormat:@"rtcEngine:didOccurError: %zd", errorCode]];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didRejoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    [self appendToLogView:[NSString stringWithFormat:@"rtcEngine:didRejoinChannel:withUid: %zd", uid]];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    [self appendToLogView:[NSString stringWithFormat:@"rtcEngine:didJoinedOfUid: %zd", uid]];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
    [self appendToLogView:[NSString stringWithFormat:@"rtcEngine:didOfflineOfUid: %zd, reason:%zd", uid, reason]];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didClientRoleChanged:(AgoraClientRole)oldRole newRole:(AgoraClientRole)newRole {
    NSString *newRoleStr = newRole == AgoraClientRoleAudience ? @"Audience" : @"Broadcast";
    [self appendToLogView:[NSString stringWithFormat:@"Current became %@", newRoleStr]];
}

@end
