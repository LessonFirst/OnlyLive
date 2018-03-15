//
//  ViewController.m
//  OnlyLive
//
//  Created by only on 2018/3/9.
//  Copyright © 2018年 only. All rights reserved.
//

#import "ViewController.h"
#import "LFLiveKit.h"
#import "OnlyLiveView.h"
#import "OnlyCommonDefine.h"
#import "OnlyLiveSession.h"
@interface ViewController ()<OnlyLiveSessionDelegate>

@property (strong, nonatomic)  LFLiveSession *session;
@property (strong, nonatomic)  OnlyLiveSession *onlyLiveSession;
@property (strong, nonatomic)  OnlyLiveView *liveView;




@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    OnlyLiveView *liveView = [[OnlyLiveView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) completion:^(OnlyLiveViewClick Click) {
        [self doSomeThingWithOnlyLiveViewClick:(OnlyLiveViewClick)Click];
    }];
    self.liveView = liveView;
    [self.view addSubview:liveView];
    
    OnlyLiveSession *onlyLiveSession = [[OnlyLiveSession alloc]initWithDefaultSessionWithdelegate:self preView:liveView];
    self.onlyLiveSession = onlyLiveSession;
    
}

#pragma mark - OnlyLiveSessionDelegate

- (void)OnlyLiveCallBackMessage:(NSString *)callBackMessage
{
    [self.liveView updateOnlyLiveVieWithMessage:callBackMessage];
}

- (void)doSomeThingWithOnlyLiveViewClick:(OnlyLiveViewClick)Click{
    switch (Click) {
        case OnlyLiveViewClickStart:{
            [self onlyLiveSessionStartLive];
        }
            break;
        case OnlyLiveViewClickStop:{
            [self.onlyLiveSession stopLive];
        }
            break;
        case OnlyLiveViewClickResetCamera:
            [self.onlyLiveSession resetCamera];
            break;
        case OnlyLiveViewClickBeauty:
            break;
        case OnlyLiveViewClickClose:
            break;
        default:
            break;
    }
    
}

- (void)onlyLiveSessionStartLive{
    
    NSString * uuidStr =[[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *devCode  = [[uuidStr substringToIndex:3] lowercaseString];
    NSString *streamSrv = @"rtmp://mobile.kscvbu.cn/live";
    NSString *streamString = [NSString stringWithFormat:@"%@/%@", streamSrv, devCode];
    [self.onlyLiveSession startLiveWithStreamString:streamString];
    
}



@end
