//
//  RoleView.h
//  AgoraEatChicken
//
//  Created by CavanSu on 15/11/2017.
//  Copyright © 2017 Agora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoleView : UIView
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign, readonly) CGFloat radius;
@property (nonatomic, assign) BOOL isMuted;
+ (instancetype)roleViewWithUid:(NSInteger)uid isSelf:(BOOL)isSelf;
@end
