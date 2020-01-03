//
//  ChooseButton.m
//  Agora-RTC-With-ASMR
//
//  Created by CavanSu on 10/11/2017.
//  Copyright © 2017 Agora. All rights reserved.
//

#import "ChooseButton.h"

@interface ChooseButton ()
@property (nonatomic, assign) BOOL isClick;
@end

@implementation ChooseButton
- (void)awakeFromNib {
    [super awakeFromNib];
    self.isClick = NO;
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(5, 0, self.bounds.size.width - 10, self.bounds.size.height);
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    self.isClick = !self.isClick;
    CGColorRef colorRef = self.isClick ? [UIColor blueColor].CGColor : [UIColor whiteColor].CGColor;
    self.layer.borderColor = colorRef;
    [super sendAction:action to:target forEvent:event];
}

- (void)cancelSelected {
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.isClick = NO;
}
@end
