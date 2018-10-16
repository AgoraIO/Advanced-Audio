//
//  LogAudioSessionStatus.m
//  Agora-RTC-With-ASMR
//
//  Created by CavanSu on 14/12/2017.
//  Copyright © 2017 Agora. All rights reserved.
//

#import "LogAudioSessionStatus.h"
#import <AVFoundation/AVFoundation.h>

@implementation LogAudioSessionStatus

+ (NSString *)logAudioSessionStatusWithCallPosition:(NSString *)position {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSString *info = [NSString stringWithFormat:@"<LogAudio> category : %@, categoryOptions : %lu , mode : %@", [session category], (unsigned long)[session categoryOptions], [session mode]];
    
    NSLog(@"%@", info);
    
    for (AVAudioSessionPortDescription *pd in [session currentRoute].inputs) {
        NSLog(@"<LogAudio> currentRoute Inputs : %@", pd.portName);
    }
    
    for (AVAudioSessionPortDescription *pd in [session currentRoute].outputs) {
        NSLog(@"<LogAudio> currentRoute Outputs : %@", pd.portName);
    }
    
    NSLog(@"<LogAudio> sampleRate : %f", [session preferredSampleRate]);
    NSLog(@"<LogAudio> -----------------------position : %@", position);
    
    return info;
}

@end
