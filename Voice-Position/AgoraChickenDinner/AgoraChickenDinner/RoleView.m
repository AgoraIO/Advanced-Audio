//
//  RoleView.m
//  AgoraEatChicken
//
//  Created by CavanSu on 15/11/2017.
//  Copyright © 2017 Agora. All rights reserved.
//

#import "RoleView.h"

@interface RoleView ()
@property (nonatomic, assign) CGFloat radius;
@end

@implementation RoleView

+ (instancetype)roleViewWithUid:(NSInteger)uid isSelf:(BOOL)isSelf {
    CGFloat radius = 80;
    RoleView *roleView = [[RoleView alloc] initWithFrame:CGRectMake(0, 0, radius * 2, radius * 2)];
    roleView.radius = radius;
    roleView.uid = uid;
    roleView.backgroundColor = [UIColor clearColor];
    roleView.layer.cornerRadius = radius;
    roleView.layer.borderWidth = 2;
    
    if (isSelf) {
        int X = (int)Screen_Width;
        int Y = (int)Screen_Hight;
        
        int randX = arc4random_uniform(X - (int)roleView.width_CS);
        int randY = arc4random_uniform(Y - (int)roleView.height_CS);
        
        CGFloat ExY = 60;
        
        if (randY < ExY) {
            randY += ExY;
        }
        
        roleView.layer.borderColor = [UIColor redColor].CGColor;
        roleView.x_CS = randX;
        roleView.y_CS = randY;
    }
    else {
        roleView.layer.borderColor = [roleView randColor].CGColor;
    }
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star"]];
    [imageView setFrame:CGRectMake(0, 0, 20, 20)];
    imageView.centerX_CS = roleView.width_CS * 0.5;
    imageView.centerY_CS = roleView.height_CS * 0.5;
    [roleView addSubview:imageView];
    return roleView;
}

- (UIColor *)randColor {
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

@end
