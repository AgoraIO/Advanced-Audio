//
//  ReplacementSegue.m
//  AgoraAudioIO
//
//  Created by suleyu on 2017/12/15.
//  Copyright © 2017 Agora. All rights reserved.
//

#import "ReplacementSegue.h"

@implementation ReplacementSegue

- (void)perform {
    NSViewController *sourceVC = self.sourceController;
    sourceVC.view.window.contentViewController = self.destinationController;
}

@end
