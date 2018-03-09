//
//  OnlyLiveSession.h
//  OnlyLive
//
//  Created by only on 2018/3/9.
//  Copyright © 2018年 only. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol OnlyLiveSessionDelegate <NSObject>


- (void)OnlyLiveCallBackMessage:(NSString *)callBackMessage;

@end

@interface OnlyLiveSession : NSObject

@property (assign, nonatomic,readonly)  BOOL isPlaying;

- (instancetype)initWithDefaultSessionWithdelegate:(id<OnlyLiveSessionDelegate>)delegate preView:(UIView *)preView;

- (void)startLiveWithStreamString:(NSString *)streamString;

- (void)stopLive;

- (void)resetCamera;

@end
