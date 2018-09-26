//
//  MainViewController.m
//  AgoraAudioIO
//
//  Created by suleyu on 2017/12/15.
//  Copyright © 2017 Agora. All rights reserved.
//

#import "RoomViewControllerMac.h"
#import "MainViewControllerMac.h"
#import "DefaultChannelName.h"

@interface MainViewControllerMac () <RoomVCMacDelegate>
@property (weak) IBOutlet NSTextField *channelNameTextField;
@property (weak) IBOutlet NSSegmentedControl *sampleRateSegControl;
@property (weak) IBOutlet NSPopUpButton *audioModePopUpButton;
@property (weak) IBOutlet NSSegmentedControl *channelSegControl;
@property (nonatomic, assign) ChannelMode channelMode;
@property (nonatomic, assign) ClientRole role;
@end

@implementation MainViewControllerMac

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *channelName = [DefaultChannelName getDefaultChannelName];
    if (channelName) {
        self.channelNameTextField.stringValue = channelName;
    }
}
- (IBAction)didClickJoinButton:(NSButton *)sender {
    self.channelMode = self.channelSegControl.selectedSegment == 0 ? ChannelModeCommunication : ChannelModeLiveBroadcast;
    if (self.channelMode == ChannelModeLiveBroadcast) {
        [self presentChannelOptions];
    }
    else {
        [self enterRoom];
    }
}

- (void)presentChannelOptions {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Channel Mode"];
    [alert addButtonWithTitle:@"Audience"];
    [alert addButtonWithTitle:@"Broadcaster"];
    [alert addButtonWithTitle:@"Cancel"];
    alert.alertStyle = NSAlertStyleWarning;
    NSModalResponse response = alert.runModal;
    
    if(response == NSAlertFirstButtonReturn) {
        self.role = ClientRoleAudience;
        [self enterRoom];
    }
    else if(response == NSAlertSecondButtonReturn) {
        self.role = ClientRoleBroadcast;
        [self enterRoom];
    }
    else if(response == NSAlertThirdButtonReturn) {
    }
}

- (void)enterRoom {
    BOOL YesOrNo = self.channelNameTextField.stringValue.length > 0 ? YES : NO;
    if (YesOrNo == NO) return;
    [self performSegueWithIdentifier:@"joinChannel" sender:nil];
}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"joinChannel"]) {
        AudioCRMode mode = 0;
        switch (self.audioModePopUpButton.indexOfSelectedItem) {
            case 0: mode = AudioCRModeSDKCaptureSDKRender; break;
            case 1: mode = AudioCRModeExterCaptureSDKRender; break;
            case 2: mode = AudioCRModeSDKCaptureExterRender; break;
            case 3: mode = AudioCRModeExterCaptureExterRender; break;
            default: break;
        }
        int sampleRate = self.sampleRateSegControl.selectedSegment == 0 ? 44100 : 48000;
        RoomViewControllerMac *roomVC = segue.destinationController;
        roomVC.channelName = self.channelNameTextField.stringValue;
        roomVC.sampleRate = sampleRate;
        roomVC.audioMode = mode;
        roomVC.channelMode = self.channelMode;
        roomVC.role = self.role;
        roomVC.delegate = self;
        [DefaultChannelName setDefaultChannelName:self.channelNameTextField.stringValue];
    }
}

- (void)roomVCNeedClose:(RoomViewControllerMac *)roomVC {
    roomVC.view.window.contentViewController = self;
}

@end
