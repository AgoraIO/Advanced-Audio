//
//  JsonHandle.m
//  AgoraEatChicken
//
//  Created by CavanSu on 15/11/2017.
//  Copyright © 2017 Agora. All rights reserved.
//

#import "JsonHandle.h"

@implementation JsonHandle

+ (NSData *)creatJsonWithRect:(CGRect)rect uid:(NSInteger)uid {

    NSDictionary *dic = @{
                          @"uid" : @(uid),
                          @"x" : @(rect.origin.x),
                          @"y" : @(rect.origin.y),
                          };

    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];

    return data;
}

+ (CGPoint)analyseJsonWithData:(NSData *)data {

    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    CGFloat X = [[dic objectForKey:@"x"] floatValue];
    CGFloat Y = [[dic objectForKey:@"y"] floatValue];
    CGPoint point = CGPointMake(X, Y);
    return point;
}

@end
