//
//  MainViewController.m
//  Agora-RTC-With-ASMR
//
//  Created by CavanSu on 2017/9/16.
//  Copyright © 2017 Agora. All rights reserved.
//

#import "MainViewController.h"
#import "ChannelNameCheck.h"
#import "RoomViewController.h"
#import "ChooseButton.h"

@interface MainViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UITextField *channelNameTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sampleRateSegControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *channelsSegControl;
@property (nonatomic, assign) AudioCRMode audioMode;
@property (nonatomic, strong) NSArray *sampleRateArray;
@property (nonatomic, strong) NSArray *channelsArray;
@property (nonatomic, weak) UIButton *lastButton;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateViews];
}

- (void)updateViews {
    self.view.backgroundColor = ThemeColor;
    self.channelsSegControl.selectedSegmentIndex = 1;
    self.joinButton.backgroundColor = [UIColor whiteColor];
    [self.joinButton setTitleColor:ThemeColor forState:UIControlStateNormal];
    self.welcomeLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.joinButton.layer.cornerRadius = self.joinButton.bounds.size.height * 0.5;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
    BOOL YesOrNo = self.channelNameTextField.text.length > 0 ? YES : NO;
    return YesOrNo;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
    RoomViewController *roomVC = segue.destinationViewController;
    roomVC.channelName = self.channelNameTextField.text;
    roomVC.audioMode = self.audioMode;
    roomVC.sampleRate = (int)[self.sampleRateArray[self.sampleRateSegControl.selectedSegmentIndex] intValue];
    roomVC.channels = (int)[self.channelsArray[self.channelsSegControl.selectedSegmentIndex] intValue];
}

- (IBAction)editingChannelName:(UITextField *)sender {
    NSString *legalChannelName = [ChannelNameCheck channelNameCheckLegal:sender.text];
    sender.text = legalChannelName;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.channelNameTextField endEditing:YES];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.channelNameTextField endEditing:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (NSArray *)sampleRateArray {
    if (!_sampleRateArray) {
        _sampleRateArray = @[@44100, @48000];
    }
    return _sampleRateArray;
}

- (NSArray *)channelsArray {
    if (!_channelsArray) {
        _channelsArray = @[@1, @2];
    }
    return _channelsArray;
}

@end
