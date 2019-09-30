//
//  UIView+ExProperty.h
//  AgoraAudio
//
//  Created by CavanSu on 07/02/2018.
//  Copyright © 2018 Agora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ExProperty)
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable BOOL masksToBounds;
@property (nonatomic) IBInspectable NSString *hexBackgroundColor;
@property (nonatomic) IBInspectable NSString *hexBorderColor;
@end

@interface UILabel (ExProperty)
@property (nonatomic) IBInspectable BOOL adjustsFontSizeToFit;
@property (nonatomic) IBInspectable NSString *hexTextColor;
@end

@interface UIButton (ExProperty)
@property (nonatomic) IBInspectable BOOL adjustsFontSizeToFit;
@property (nonatomic) IBInspectable NSString *hexTextColor;
@end

@interface UITextField (ExProperty)
@property (nonatomic) IBInspectable NSString *hexTextColor;
@property (nonatomic) IBInspectable NSString *placeholderColorString;
@end

@interface UISegmentedControl (ExProperty)
@property (nonatomic) IBInspectable NSString *hexTintColor;
@end

@interface UISwitch (ExProperty)
@property (nonatomic) IBInspectable NSString *hexTintColor;
@property (nonatomic) IBInspectable NSString *hexThumbTintColor;
@end

@interface UISlider (ExProperty)
@property (nonatomic) IBInspectable NSString *hexThumbTintColor;
@property (nonatomic) IBInspectable NSString *thumbImage;
@property (nonatomic) IBInspectable NSString *maxTrackColor;
@property (nonatomic) IBInspectable NSString *minTrackColor;
@end

@interface UINavigationController (ExProperty)
@property (nonatomic) IBInspectable CGFloat titleFont;
@end
