//
//  InfoModel.h
//  AgoraAudioIO
//
//  Created by CavanSu on 2017/9/18.
//  Copyright © 2017 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoModel : NSObject
@property (nonatomic, copy) NSString *infoStr;
@property (nonatomic, assign) float height;
+ (instancetype)modelWithInfoStr:(NSString *)infoStr;
@end
