//
//  MainViewController.m
//  AgoraEatChicken
//
//  Created by CavanSu on 15/11/2017.
//  Copyright © 2017 Agora. All rights reserved.
//

#import "MainViewController.h"
#import "GameViewController.h"

@interface MainViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *channelNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (nonatomic, assign) RoleType roleType;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.channelNameTextField.delegate = self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.joinButton.layer.cornerRadius = self.joinButton.width_CS * 0.5;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
    GameViewController *gameVC = segue.destinationViewController;
    gameVC.channelName = self.channelNameTextField.text;
}

- (IBAction)joinButtonClick:(UIButton *)sender {
    BOOL YesOrNo = self.channelNameTextField.text.length > 0 ? YES : NO;
    if (!YesOrNo) return;
    [self performSegueWithIdentifier:@"mainToLive" sender:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.channelNameTextField endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.channelNameTextField endEditing:YES];
    
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
