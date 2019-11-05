//
//  CXEngine.h
//  Pronunciation-Assess
//
//  Created by CavanSu on 2019/11/1.
//  Copyright © 2019 CavanSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgoraMediaRawData.h"

@class CXEngine;
@protocol CXEngineDelegate <NSObject>
- (void)cxEngine:(CXEngine * _Nonnull)engine pronunciateResult:(NSInteger)result;
@end

@interface CXEngine : NSObject
@property (atomic, assign, readonly) BOOL isNeedAudioData;
@property (nonatomic, weak) id<CXEngineDelegate> _Nullable delegate;

- (void)prepareWithAppKey:(NSString * _Nonnull)appKey secrectKey:(NSString * _Nonnull)secretKey;
- (void)request:(NSString * _Nonnull)key;
- (void)sendAudioData:(AgoraAudioRawData * _Nonnull)data;
- (void)stopSend;
@end
