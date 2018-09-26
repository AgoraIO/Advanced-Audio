//
//  MainViewController.m
//  Agora-RTC-With-Voice-Changer-iOS-Objective-C
//
//  Created by ZhangJi on 2018/5/4.
//  Copyright © 2018 ZhangJi. All rights reserved.
//

#import "MainViewController.h"
#import "RoomViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UITextField *channelTextField;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueId = segue.identifier;
    
    if ([segueId isEqualToString:@"mainToRoom"]) {
        RoomViewController *RoomVC = segue.destinationViewController;
        RoomVC.roomName = self.channelTextField.text;
        RoomVC.clientRole = [sender integerValue];
    }
}

- (void)showRoleSelection {
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *broadcaster = [UIAlertAction actionWithTitle:@"Broadcaster" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self joinWithRole:AgoraClientRoleBroadcaster];
    }];
    UIAlertAction *audience = [UIAlertAction actionWithTitle:@"Audience" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self joinWithRole:AgoraClientRoleAudience];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    [sheet addAction:broadcaster];
    [sheet addAction:audience];
    [sheet addAction:cancel];
    [sheet popoverPresentationController].sourceView = self.joinButton;
    [sheet popoverPresentationController].permittedArrowDirections = UIPopoverArrowDirectionUp;
    [self presentViewController:sheet animated:YES completion:nil];
}

- (void)joinWithRole:(AgoraClientRole)role {
    [self performSegueWithIdentifier:@"mainToRoom" sender:@(role)];
}

- (IBAction)doJoinButtonPressed:(id)sender {
    if (self.channelTextField.text.length) {
        [self showRoleSelection];
    }
}

@end
