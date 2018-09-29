//
//  JsonHandle.h
//  AgoraEatChicken
//
//  Created by CavanSu on 15/11/2017.
//  Copyright © 2017 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonHandle : NSObject

+ (NSData *)creatJsonWithRect:(CGRect)rect uid:(NSInteger)uid;

+ (CGPoint)analyseJsonWithData:(NSData *)data;

@end
