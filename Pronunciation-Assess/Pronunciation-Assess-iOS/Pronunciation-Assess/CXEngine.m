//
//  CXEngine.m
//  Pronunciation-Assess
//
//  Created by CavanSu on 2019/11/1.
//  Copyright © 2019 CavanSu. All rights reserved.
//

#import "CXEngine.h"
#include "aiengine.h"

static struct aiengine *engine;

@interface CXEngine ()
@property (atomic, assign) BOOL isNeedAudioData;
@end

@implementation CXEngine

int requestCallback(const void *usrdata, const char *id, int type, const void *message, int size) {
    
    if (type == AIENGINE_MESSAGE_TYPE_JSON) {
        NSString *string = [[NSString alloc] initWithUTF8String:message];
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *resultDic = dic[@"result"];
        NSNumber *pron = (NSNumber *)resultDic[@"pron"];
        
        CXEngine *engine = (__bridge CXEngine *)usrdata;
        if ([engine.delegate respondsToSelector:@selector(cxEngine:pronunciateResult:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [engine.delegate cxEngine:engine pronunciateResult:[pron integerValue]];
            });
        }
    }
    
    return 0;
}

- (void)prepareWithAppKey:(NSString * _Nonnull)appKey secrectKey:(NSString * _Nonnull)secretKey {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"aiengine" ofType:@"provision"];
    
    char buffer [500];
    char *cfg = buffer;
    
    char *app_key = (char *)[appKey UTF8String];
    char *secret_key = (char *)[secretKey UTF8String];
    char *provision = (char *)[path UTF8String];
    
    sprintf(cfg, "{\"appKey\": \"%s\", \"secretKey\": \"%s\", \"provision\": \"%s\",\"prof\": { \"enable\":1, \"output\":\"/Users/support/Desktop/syyd-log.txt\"}, \"cloud\":{\"enable\":1, \"server\": \"wss://cloud.chivox.com:443\"}}", app_key, secret_key, provision);
    engine = aiengine_new(cfg);
    if (0 == engine) {
        printf("create engine fail!");
    }
    else {
        printf("create engine success!");
    }
}

- (void)request:(NSString * _Nonnull)key {
    int rv = 0;
    
    char tokenBuffer [64];
    char parameters [1024];
    
    sprintf(parameters, "{\"coreProvideType\":\"cloud\",\"app\": {\"userId\": \"this-is-user-id\"}, \"audio\": {\"audioType\": \"wav\", \"sampleRate\": 16000, \"channel\": 1, \"sampleBytes\": 2}, \"request\" : {\"coreType\": \"en.word.score\", \"refText\": \"%s\", \"rank\": 100, \"attachAudioUrl\": 0}}", [key UTF8String]);
    
    rv = aiengine_start(engine, parameters, tokenBuffer, requestCallback, (__bridge const void *)(self));
    if (rv) {
        printf("myId aiengine_start() failed: %d\n", rv);
        return;
    }
    
    self.isNeedAudioData = YES;
}

- (void)sendAudioData:(AgoraAudioRawData * _Nonnull)data {
    aiengine_feed(engine, data.buffer, data.bufferLength);
}

- (void)stopSend {
    self.isNeedAudioData = NO;
    aiengine_stop(engine);
}

@end
