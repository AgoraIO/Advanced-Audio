//
//  Define.h
//  OpenVodieCall
//
//  Created by CavanSu on 2017/9/5.
//  Copyright © 2017 Agora. All rights reserved.
//

#ifndef Define_h
#define Define_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, AudioCRMode) {    
    AudioCRModeExterCaptureSDKRender = 1,
    AudioCRModeSDKCaptureExterRender = 2,
    AudioCRModeSDKCaptureSDKRender = 3,
    AudioCRModeExterCaptureExterRender = 4
};

#define ThemeColor [UIColor colorWithRed:122.0 / 255.0 green:203.0 / 255.0 blue:253.0 / 255.0 alpha:1]

#endif /* Define_h */
