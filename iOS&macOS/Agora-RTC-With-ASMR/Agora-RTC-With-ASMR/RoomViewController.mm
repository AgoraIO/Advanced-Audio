//
//  RoomViewController.m
//  Agora-RTC-With-ASMR
//
//  Created by CavanSu on 2017/9/18.
//  Copyright © 2017 Agora. All rights reserved.
//

#import "RoomViewController.h"
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import <AgoraRtcKit/IAgoraRtcEngine.h>
#import <AgoraRtcKit/IAgoraMediaEngine.h>
#import "KeyCenter.h"
#import "InfoCell.h"
#import "InfoModel.h"
#import "InfoTableView.h"
#import "AudioController.h"
#import "AudioWriteToFile.h"
#import "LogAudioSessionStatus.h"
#import "ChatButton.h"

@interface RoomViewController () <AgoraRtcEngineDelegate, AudioControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;
@property (weak, nonatomic) IBOutlet InfoTableView *tableView;
@property (weak, nonatomic) IBOutlet ChatButton *speakerButton;
@property (nonatomic, strong) AgoraRtcEngineKit *agoraKit;
@property (nonatomic, strong) AudioController *audioController;
@property (nonatomic, strong) NSMutableArray *infoArray;
@end

static NSObject *threadLockCapture;
static NSObject *threadLockPlay;

#pragma mark - C++ AgoraAudioFrameObserver
class AgoraAudioFrameObserver : public agora::media::IAudioFrameObserver
{
private:
    
    // total buffer length of per second
    enum { kBufferLengthBytes = 441 * 2 * 2 * 50 }; // 88200 bytes
    
    // capture
    char byteBuffer[kBufferLengthBytes]; // char take up 1 byte, byterBuffer[] take up 88200 bytes
    int readIndex = 0;
    int writeIndex = 0;
    int availableBytes = 0;
    
    // play
    char byteBuffer_play[kBufferLengthBytes];
    int readIndex_play = 0;
    int writeIndex_play = 0;
    int availableBytes_play = 0;
    
public:
    int sampleRate = 0;
    int sampleRate_play = 0;
    int channels = 0;
    int channels_play = 0;
    
#pragma mark- <C++ Capture>
    // push audio data to special buffer(Array byteBuffer)
    // bytesLength = date length
    void pushExternalData(void* data, int bytesLength)
    {
        @synchronized(threadLockCapture) {
            
            if (availableBytes + bytesLength > kBufferLengthBytes) {
                
                readIndex = 0;
                writeIndex = 0;
                availableBytes = 0;
            }
            
            if (writeIndex + bytesLength > kBufferLengthBytes) {
                
                int left = kBufferLengthBytes - writeIndex;
                memcpy(byteBuffer + writeIndex, data, left);
                memcpy(byteBuffer, (char *)data + left, bytesLength - left);
                writeIndex = bytesLength - left;
            }
            else {
                
                memcpy(byteBuffer + writeIndex, data, bytesLength);
                writeIndex += bytesLength;
            }
            availableBytes += bytesLength;
        }
    }
    
    // copy byteBuffer to audioFrame.buffer
    virtual bool onRecordAudioFrame(AudioFrame& audioFrame) override 
    {
        @synchronized(threadLockCapture) {
            
            int readBytes = sampleRate / 100 * channels * audioFrame.bytesPerSample;
            
            if (availableBytes < readBytes) {
                return false;
            }
            
            audioFrame.samplesPerSec = sampleRate;
            unsigned char tmp[1920]; // The most rate:@48k fs, channels = 2, the most total size = 960;
            
            if (readIndex + readBytes > kBufferLengthBytes) {
                int left = kBufferLengthBytes - readIndex;
                memcpy(tmp, byteBuffer + readIndex, left);
                memcpy(tmp + left, byteBuffer, readBytes - left);
                readIndex = readBytes - left;
            }
            else {
                memcpy(tmp, byteBuffer + readIndex, readBytes);
                readIndex += readBytes;
            }
            
            availableBytes -= readBytes;
            
            if (channels == audioFrame.channels) {
                memcpy(audioFrame.buffer, tmp, readBytes);
            }
            return true;
        }
    }
    
#pragma mark- <C++ Render>
    // read Audio data from byteBuffer_play to audioUnit
    int readAudioData(void* data, int bytesLength) 
    {
        @synchronized(threadLockPlay) {
            
            if (NULL == data || bytesLength < 1 || availableBytes_play < bytesLength) {
                return 0;
            }
            
            int readBytes = bytesLength;
            unsigned char tmp[4096]; // unsigned char takes up 1 byte
            
            if (readIndex_play + readBytes > kBufferLengthBytes) {
                
                int left = kBufferLengthBytes - readIndex_play;
                memcpy(tmp, byteBuffer_play + readIndex_play, left);
                memcpy(tmp + left, byteBuffer_play, readBytes - left);
                readIndex_play = readBytes - left;
            }
            else {
                
                memcpy(tmp, byteBuffer_play + readIndex_play, readBytes);
                readIndex_play += readBytes;
            }
            
            availableBytes_play -= readBytes;
            memcpy(data, tmp, readBytes);
            
            return readBytes;
        }
    }
    
    // recive remote audio stream, push audio data to byteBuffer_play
    virtual bool onPlaybackAudioFrame(AudioFrame& audioFrame) override
    {
        @synchronized(threadLockPlay) {
            
            if (audioFrame.renderTimeMs <= 0) {
                return false;
            }
            
            int bytesLength = audioFrame.samples * audioFrame.channels * audioFrame.bytesPerSample;
            char *data = (char *)audioFrame.buffer;
            
            if (availableBytes_play + bytesLength > kBufferLengthBytes) {
                
                readIndex_play = 0;
                writeIndex_play = 0;
                availableBytes_play = 0;
            }
            
            if (writeIndex_play + bytesLength > kBufferLengthBytes) {
                
                int left = kBufferLengthBytes - writeIndex_play;
                memcpy(byteBuffer_play + writeIndex_play, data, left);
                memcpy(byteBuffer_play, (char *)data + left, bytesLength - left);
                writeIndex_play = bytesLength - left;
            }
            else {
                
                memcpy(byteBuffer_play + writeIndex_play, data, bytesLength);
                writeIndex_play += bytesLength;
            }
            
            availableBytes_play += bytesLength;
            
            return true;
        }
    }
    
    virtual bool onPlaybackAudioFrameBeforeMixing(unsigned int uid, AudioFrame& audioFrame) override { return true; }
    
    virtual bool onMixedAudioFrame(AudioFrame& audioFrame) override { return true; }
};

static AgoraAudioFrameObserver* s_audioFrameObserver;

@implementation RoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self updateViews];
    [self loadAgoraKitAndAudioController];
}

#pragma mark - setupViews
- (void)updateViews {
    self.roomNameLabel.text = self.channelName;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.speakerButton.selected = YES;
}

#pragma mark - initAgoraKitAndInitAudioController
- (void)loadAgoraKitAndAudioController {
    threadLockCapture = [[NSObject alloc] init];
    threadLockPlay = [[NSObject alloc] init];

    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:[KeyCenter AppId] delegate:self];
    [self.agoraKit setParameters: @"{\"che.audio.external_capture\": true}"];
    [self.agoraKit setParameters: @"{\"che.audio.external_render\": true}"];
    [self.agoraKit setAudioProfile:AgoraAudioProfileMusicStandardStereo scenario:AgoraAudioScenarioDefault];
    
    self.audioController = [AudioController audioController];
    self.audioController.delegate = self;
    [self.audioController setUpAudioSessionWithSampleRate:self.sampleRate channelCount:self.channels];

    // Set capture format
    [self.agoraKit setRecordingAudioFrameParametersWithSampleRate:(NSInteger)self.sampleRate
                                                          channel:self.channels mode:AgoraAudioRawFrameOperationModeWriteOnly
                                                   samplesPerCall:(NSInteger)self.sampleRate * self.channels * 0.01]; // samplesPerCall : sampleRate * channels * duration
    
    [self.agoraKit setPlaybackAudioFrameParametersWithSampleRate:(NSInteger)self.sampleRate
                                                         channel:self.channels
                                                            mode:AgoraAudioRawFrameOperationModeReadOnly
                                                  samplesPerCall:(NSInteger)self.sampleRate * self.channels * 0.01];
    

    agora::rtc::IRtcEngine* rtc_engine = (agora::rtc::IRtcEngine*)self.agoraKit.getNativeHandle;
    agora::util::AutoPtr<agora::media::IMediaEngine> mediaEngine;
    
    mediaEngine.queryInterface(rtc_engine, agora::AGORA_IID_MEDIA_ENGINE);
    
    if (mediaEngine) {
        s_audioFrameObserver = new AgoraAudioFrameObserver();
        s_audioFrameObserver -> sampleRate = self.sampleRate;
        s_audioFrameObserver -> sampleRate_play = self.sampleRate;
        s_audioFrameObserver -> channels = self.channels;
        s_audioFrameObserver -> channels_play = self.channels;
        mediaEngine->registerAudioFrameObserver(s_audioFrameObserver);
    }
    [self.agoraKit joinChannelByToken:nil channelId:self.channelName info:nil uid:0 joinSuccess:nil];
}

#pragma mark- Click Buttons
- (IBAction)clickMuteButton:(UIButton *)sender {
    [self.agoraKit muteLocalAudioStream:sender.selected];
}

- (IBAction)clickHungUpButton:(UIButton *)sender {
    sender.enabled = NO;
    [self.audioController stopWork];
    
    agora::rtc::IRtcEngine* rtc_engine = (agora::rtc::IRtcEngine *)self.agoraKit.getNativeHandle;
    agora::util::AutoPtr<agora::media::IMediaEngine> mediaEngine;
    mediaEngine.queryInterface(rtc_engine, agora::AGORA_IID_MEDIA_ENGINE);
    
    delete s_audioFrameObserver;
    
    if (mediaEngine) {
        mediaEngine->registerAudioFrameObserver(NULL);
    }
    
    [self.agoraKit leaveChannel:nil];
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

#pragma mark- <AudioCaptureDelegate>
- (void)audioController:(AudioController *)controller didCaptureData:(unsigned char *)data bytesLength:(int)bytesLength {
    if (s_audioFrameObserver) {
        s_audioFrameObserver -> pushExternalData(data, bytesLength);
    }
}

- (int)audioController:(AudioController *)controller didPlayData:(unsigned char *)data bytesLength:(int)bytesLength {
    int result = 0;
    
    if (s_audioFrameObserver) {
        result = s_audioFrameObserver -> readAudioData(data, bytesLength);
    }

    return result;
}

- (void)audioController:(AudioController *)controller error:(OSStatus)error info:(NSString *)info {
    [self.tableView appendInfoToTableViewWithInfo:[NSString stringWithFormat:@"Error :%d, info: %@", (int)error, info]];
}

#pragma mark- <AgoraRtcEngineDelegate>
// Current joined success
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString*)channel withUid:(NSUInteger)uid elapsed:(NSInteger) elapsed {
    [self.tableView appendInfoToTableViewWithInfo:[NSString stringWithFormat:@"Current joined channel with uid:%zd", uid]];
    [self.audioController startWork];
    
    // Attention Here, Set Mode: AVAudioSessionModeDefault
    [[AVAudioSession sharedInstance] setMode:AVAudioSessionModeDefault error:nil];
    [[AVAudioSession sharedInstance] setPreferredSampleRate:self.sampleRate error:nil];
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
    [self.tableView appendInfoToTableViewWithInfo:[NSString stringWithFormat:@"Self Rejoin Channel"]];
}

#pragma mark - StatusBar Style
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
