//
//  DefaultChannelName.m
//  AgoraAudioIO
//
//  Created by CavanSu on 15/03/2018.
//  Copyright © 2018 CavanSu. All rights reserved.
//

#import "DefaultChannelName.h"

@implementation DefaultChannelName

+ (void)setDefaultChannelName:(NSString *)channelName {
    [[NSUserDefaults standardUserDefaults] setObject:channelName forKey:@"ChannelName"];
}

+ (NSString *)getDefaultChannelName {
    NSString *channelName = [[NSUserDefaults standardUserDefaults] objectForKey:@"ChannelName"];
    return channelName;
}
@end
