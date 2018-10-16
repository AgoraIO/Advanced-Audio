//
//  TouchView.m
//  AgoraEatChicken
//
//  Created by CavanSu on 15/11/2017.
//  Copyright © 2017 Agora. All rights reserved.
//

#import "TouchView.h"

@implementation TouchView

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:self];
    CGPoint prePoint = [touch previousLocationInView:self];
    CGFloat offX = prePoint.x - curPoint.x;
    CGFloat offY = prePoint.y - curPoint.y;
    
    self.myRoleView.transform = CGAffineTransformTranslate(self.myRoleView.transform, -offX, -offY);
    
    if (self.myRoleView.x_CS + self.myRoleView.width_CS > Screen_Width) {
        [UIView animateWithDuration:0.1 animations:^{
            self.myRoleView.x_CS = Screen_Width - self.myRoleView.width_CS;
        }];
    }
    
    if (self.myRoleView.x_CS < 0) {
        [UIView animateWithDuration:0.1 animations:^{
            self.myRoleView.x_CS = 0;
        }];
    }
    
    if (self.myRoleView.y_CS + self.myRoleView.height_CS > Screen_Hight) {
        [UIView animateWithDuration:0.1 animations:^{
            self.myRoleView.y_CS = Screen_Hight - self.myRoleView.height_CS;
        }];
    }
    
    if (self.myRoleView.y_CS < 20) {
        [UIView animateWithDuration:0.1 animations:^{
            self.myRoleView.y_CS = 20;
        }];
    }
    
    if ([self.delegate respondsToSelector:@selector(myRoleViewMove)]) {
        [self.delegate myRoleViewMove];
    }
}

@end
