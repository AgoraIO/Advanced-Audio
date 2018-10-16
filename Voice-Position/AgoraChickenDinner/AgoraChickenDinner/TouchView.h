//
//  TouchView.h
//  AgoraEatChicken
//
//  Created by CavanSu on 15/11/2017.
//  Copyright © 2017 Agora. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchViewDelegate <NSObject>
- (void)myRoleViewMove;
@end

@interface TouchView : UIView
@property (nonatomic, weak) UIView *myRoleView;
@property (nonatomic, weak) id<TouchViewDelegate> delegate;
@end
