//
//  UIView+ExProperty.m
//  AgoraAudio
//
//  Created by CavanSu on 07/02/2018.
//  Copyright © 2018 Agora. All rights reserved.
//

#import "UIView+ExProperty.h"
#import "UIColor+Hex.h"

@implementation UIView (ExProperty)
@dynamic borderColor, borderWidth, cornerRadius, masksToBounds, hexBackgroundColor, hexBorderColor;

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (void)setMasksToBounds:(BOOL)masksToBounds {
    self.layer.masksToBounds = masksToBounds;
}

- (void)setHexBackgroundColor:(NSString *)hexBackgroundColor {
    if (hexBackgroundColor == nil || hexBackgroundColor.length == 0) return;
    self.backgroundColor = [UIColor colorWithHexString: hexBackgroundColor];
}

- (void)setHexBorderColor:(NSString *)hexBorderColor {
    if (hexBorderColor == nil || hexBorderColor.length == 0) return;
    self.layer.borderColor = [UIColor colorWithHexString:hexBorderColor].CGColor;
}
@end

@implementation UILabel (ExProperty)
@dynamic adjustsFontSizeToFit, hexTextColor;

- (void)setAdjustsFontSizeToFit:(BOOL)adjustsFontSizeToFit {
    self.adjustsFontSizeToFitWidth = adjustsFontSizeToFit;
}

- (void)setHexTextColor:(NSString *)hexTextColor {
    if (hexTextColor == nil || hexTextColor.length == 0) return;
    self.textColor = [UIColor colorWithHexString:hexTextColor];
}
@end

@implementation UIButton (ExProperty)
@dynamic adjustsFontSizeToFit, hexTextColor;

- (void)setAdjustsFontSizeToFit:(BOOL)adjustsFontSizeToFit {
    self.titleLabel.adjustsFontSizeToFitWidth = adjustsFontSizeToFit;
}

- (void)setHexTextColor:(NSString *)hexTextColor {
    if (hexTextColor == nil || hexTextColor.length == 0) return;
    [self setTitleColor:[UIColor colorWithHexString:hexTextColor] forState:UIControlStateNormal];
}
@end

@implementation UITextField (ExProperty)
@dynamic hexTextColor, placeholderColorString;

- (void)setHexTextColor:(NSString *)hexTextColor {
    if (hexTextColor == nil || hexTextColor.length == 0) return;
    self.textColor = [UIColor colorWithHexString:hexTextColor];
}

- (void)setPlaceholderColorString:(NSString *)placeholderColorString {
    if (placeholderColorString == nil || placeholderColorString.length == 0) return;
    
    NSArray *array = [placeholderColorString componentsSeparatedByString:@"-"];
    NSString *colorString = nil;
    NSString *textString = nil;

    if (array.count == 2) {
        colorString = array[0];
        textString = array[1];
    } else {
        colorString = [NSString stringWithFormat:@"%@-%@", array[0], array[1]];
        textString = array[2];
    }
    
    UIColor *color = [UIColor colorWithHexString:colorString];
    NSDictionary *dic = @{NSForegroundColorAttributeName: color};
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:textString attributes:dic];
    self.attributedPlaceholder = attrString;
}
@end

@implementation UISegmentedControl (ExProperty)
@dynamic hexTintColor;

- (void)setHexTintColor:(NSString *)hexTintColor {
    if (hexTintColor == nil || hexTintColor.length == 0) return;
    self.tintColor = [UIColor colorWithHexString:hexTintColor];
}
@end

@implementation UISwitch (ExProperty)
@dynamic hexTintColor, hexThumbTintColor;

- (void)setHexTintColor:(NSString *)hexTintColor {
    if (hexTintColor == nil || hexTintColor.length == 0) return;
    self.tintColor = [UIColor colorWithHexString:hexTintColor];
}

- (void)setHexThumbTintColor:(NSString *)hexThumbTintColor {
    if (hexThumbTintColor == nil || hexThumbTintColor.length == 0) return;
    self.thumbTintColor = [UIColor colorWithHexString:hexThumbTintColor];
}
@end

@implementation UISlider (ExProperty)
@dynamic hexThumbTintColor, thumbImage, maxTrackColor, minTrackColor;

- (void)setThumbImage:(NSString *)thumbImage {
    if (thumbImage == nil || thumbImage.length == 0) return;
    [self setThumbImage:[UIImage imageNamed:thumbImage] forState:UIControlStateNormal];
}

- (void)setHexThumbTintColor:(NSString *)hexThumbTintColor {
    if (hexThumbTintColor == nil || hexThumbTintColor.length == 0) return;
    self.thumbTintColor = [UIColor colorWithHexString:hexThumbTintColor];
}

- (void)setMaxTrackColor:(NSString *)maxTrackColor {
    if (maxTrackColor == nil || maxTrackColor.length == 0) return;
    self.maximumTrackTintColor = [UIColor colorWithHexString:maxTrackColor];
}

- (void)setMinTrackColor:(NSString *)minTrackColor {
    if (minTrackColor == nil || minTrackColor.length == 0) return;
    self.minimumTrackTintColor = [UIColor colorWithHexString:minTrackColor];
}
@end

@implementation UINavigationController (ExProperty)
@dynamic titleFont;

- (void)setTitleFont:(CGFloat)titleFont {
    NSMutableDictionary *attrDic = nil;
    if (self.navigationBar.titleTextAttributes) {
        attrDic = [NSMutableDictionary dictionaryWithDictionary:self.navigationBar.titleTextAttributes];
    } else {
        attrDic = [NSMutableDictionary dictionary];
    }
    [attrDic setObject:[UIFont systemFontOfSize:titleFont] forKey:NSFontAttributeName];
    self.navigationBar.titleTextAttributes = attrDic;
}
@end







