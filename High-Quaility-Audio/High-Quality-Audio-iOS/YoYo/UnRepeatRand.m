//
//  UnRepeatRand.m
//  YoYo
//
//  Created by CavanSu on 2018/7/9.
//  Copyright © 2018 CavanSu. All rights reserved.
//

#import "UnRepeatRand.h"

@implementation UnRepeatRand
+ (int)rand {
    srand((unsigned)time(0));
    return rand();
}
@end
