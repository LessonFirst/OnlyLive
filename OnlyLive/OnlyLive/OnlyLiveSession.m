//
//  OnlyLiveSession.m
//  OnlyLive
//
//  Created by only on 2018/3/9.
//  Copyright © 2018年 only. All rights reserved.
//

#import "OnlyLiveSession.h"
#import "LFLiveKit.h"
#import "CaptureFaceService.h"

inline static NSString *formatedSpeed(float bytes, float elapsed_milli) {
    if (elapsed_milli <= 0) {
        return @"N/A";
    }
    
    if (bytes <= 0) {
        return @"0 KB/s";
    }
    
    float bytes_per_sec = ((float)bytes) * 1000.f /  elapsed_milli;
    if (bytes_per_sec >= 1000 * 1000) {
        return [NSString stringWithFormat:@"%.2f MB/s", ((float)bytes_per_sec) / 1000 / 1000];
    } else if (bytes_per_sec >= 1000) {
        return [NSString stringWithFormat:@"%.1f KB/s", ((float)bytes_per_sec) / 1000];
    } else {
        return [NSString stringWithFormat:@"%ld B/s", (long)bytes_per_sec];
    }
}


@interface OnlyLiveSession()<LFLiveSessionDelegate>

@property (assign, nonatomic)  BOOL isPlaying;
@property (strong, nonatomic)  LFLiveSession *session;
@property (weak, nonatomic)  id delegate;
@property (strong,nonatomic) CaptureFaceService *faceService;


@end

@implementation OnlyLiveSession

- (instancetype)initWithDefaultSessionWithdelegate:(id<OnlyLiveSessionDelegate>)delegate preView:(UIView*)preView{
    self = [super init];
    if (self) {
        [self setDefaultSessionWithdelegate:(id<OnlyLiveSessionDelegate>)delegate preView:(UIView*)preView];
    }
    return self;
    
}


#pragma mark - 开始播放 streamString:推流地址
- (void)startLiveWithStreamString:(NSString *)streamString{
    
    if (!self.session && streamString.length > 0) {
        @throw @"需要创建一个默认的session or 需要一个播放streamString";
        return;
    }
    NSLog(@"当前的streamString:%@",streamString);
    LFLiveStreamInfo *info = [LFLiveStreamInfo new];
    info.url = streamString;
    [self.session startLive:info];
    
}
#pragma mark - 停止播放
- (void)stopLive
{
    [_session stopLive];
}


#pragma mark - 摄像头翻转

- (void)resetCamera{
    AVCaptureDevicePosition devicePositon = self.session.captureDevicePosition;
    self.session.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    
}
#pragma mark - 设置默认的Session
- (void)setDefaultSessionWithdelegate:(id<OnlyLiveSessionDelegate>)delegate preView:(UIView*)preView{
    if (!_session) {
        self.delegate = delegate;
        /***   默认分辨率368 ＊ 640  音频：44.1 iphone6以上48  双声道  方向竖屏 ***/
        LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
        videoConfiguration.videoFrameRate = 15;
        videoConfiguration.videoMaxFrameRate = 15;
        videoConfiguration.videoMinFrameRate = 10;
        videoConfiguration.videoBitRate = 1000 * 1000;
        videoConfiguration.videoMaxBitRate = 1200 * 1000;
        videoConfiguration.videoMinBitRate = 500 * 1000;
        videoConfiguration.videoSize = CGSizeMake(720, 1280);
        
        
//        videoConfiguration.videoSize = CGSizeMake(preView.bounds.size.width, preView.bounds.size.height);
//        videoConfiguration.videoBitRate = 800*1024;
//        videoConfiguration.videoMaxBitRate = 1000*1024;
//        videoConfiguration.videoMinBitRate = 500*1024;
//        videoConfiguration.videoFrameRate = 24;
        videoConfiguration.videoMaxKeyframeInterval = 48;
        videoConfiguration.outputImageOrientation = UIInterfaceOrientationPortrait;
        videoConfiguration.autorotate = NO;
        videoConfiguration.sessionPreset = LFCaptureSessionPreset720x1280;
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:videoConfiguration captureType:LFLiveCaptureDefaultMask];
        _session.delegate = self;
        _session.preView = preView;
    }
    [self requestAccessForAudio];
    [self requestAccessForVideo];
}



#pragma mark -- LFStreamingSessionDelegate
/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state {
    NSLog(@"liveStateDidChange: %ld", state);
    NSString *needCallBackMessage;
    switch (state) {
        case LFLiveReady:
            needCallBackMessage = @"未连接";
            self.isPlaying = NO;
            break;
        case LFLivePending:
            needCallBackMessage = @"连接中";
            break;
        case LFLiveStart:
            self.isPlaying = YES;
            needCallBackMessage = @"已连接";
            break;
        case LFLiveError:
            needCallBackMessage = @"连接错误";
            self.isPlaying = NO;
            break;
        case LFLiveStop:
            needCallBackMessage = @"未连接";
            self.isPlaying = NO;
            break;
        default:
            needCallBackMessage = @"未知";
            break;
    }
    if ([self.delegate respondsToSelector:@selector(OnlyLiveCallBackMessage:)]) {
        [self.delegate OnlyLiveCallBackMessage:needCallBackMessage];
    }
}

/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug *)debugInfo {
    NSLog(@"debugInfo uploadSpeed: %@", formatedSpeed(debugInfo.currentBandwidth, debugInfo.elapsedMilli));
}

/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode {
    self.isPlaying = NO;
    NSLog(@"errorCode: %ld", errorCode);
}

// 传出的sampleBuffer
- (void)WillOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    
    if (!_faceService) {
        _faceService = [CaptureFaceService new];
    }
    
    [_faceService startDetectionFaceWithCMSampleBufferRef:sampleBuffer andCaptureFaceProgressBlock:^(float faceProgress, float eyeProgress, captureFaceStatus captureFaceStatus) {
        
    } andCompleteBlock:^(UIImage *resultImage, NSError *error) {
        
    }];
    
}

#pragma mark -- Public Method
- (void)requestAccessForVideo {
    __weak typeof(self) _self = self;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_self.session setRunning:YES];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            // 已经开启授权，可继续
            dispatch_async(dispatch_get_main_queue(), ^{
                [_self.session setRunning:YES];
            });
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            
            break;
        default:
            break;
    }
}

- (void)requestAccessForAudio {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}
-(CaptureFaceService *)faceService
{
    if(!_faceService){
        _faceService = [CaptureFaceService new];
    }
    return _faceService;
}

#pragma mark - delloc
- (void)dealloc
{
    _session ? _session = nil :nil;
}

@end
