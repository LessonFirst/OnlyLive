//
//  OnlyLiveView.h
//  OnlyLive
//
//  Created by only on 2018/3/9.
//  Copyright © 2018年 only. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OnlyLiveViewClick) {
    OnlyLiveViewClickStart = 101, //
    OnlyLiveViewClickStop = 102, //
    OnlyLiveViewClickResetCamera = 103,
    OnlyLiveViewClickBeauty = 104,
    OnlyLiveViewClickClose = 105,
};

typedef void (^OnlyLiveViewClickCompletion)(OnlyLiveViewClick Click);

@interface OnlyLiveView : UIView

-(instancetype)initWithFrame:(CGRect)frame completion:(OnlyLiveViewClickCompletion)completion;

- (void)updateOnlyLiveVieWithMessage:(NSString *)message;

@end
