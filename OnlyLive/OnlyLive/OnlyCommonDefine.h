//
//  OnlyCommonDefine.h
//  LFLiveKitDemo
//
//  Created by only on 2018/3/9.
//  Copyright © 2018年 admin. All rights reserved.
//

#ifndef OnlyCommonDefine_h
#define OnlyCommonDefine_h

#pragma mark - 常规控件、计算
//-----------------------------------常规控件---------------------------------------------
#define kScreenHeight        ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth         ([UIScreen mainScreen].bounds.size.width)
#define kScreenMaxSide       (MAX(kScreenWidth, kScreenHeight))
#define kScreenMinSide       (MIN(kScreenWidth, kScreenHeight))
#define kScreenRect          CGRectMake(0, 0, kScreenWidth, kScreenHeight)
#define kStatusBarHeight     ([[UIApplication sharedApplication] statusBarFrame].size.height)  // 状态栏高
#define kBasicViewHeight     (self.view.bounds.size.height)
#define kNavBarHeight        (44.0f)
#define kNavBarShadowHeight  (6.0f)
#define kNavBarButtonHeight  (30.0f)
#define kNavBarButtonWidth   (30.0f)
#define kSafeAreaTopHeight   ((iPhoneX)?(88.0f):(64.0f))
#define kTabBarHeight        (49.0f)
#define kDefaultCellHeight   (44.0f)      // 默认cell高度
#define kSearchBarHeight     (44.0f)      // 搜索栏高度
#define kSafeAreaTopHeight   ((iPhoneX)?(88.0f):(64.0f)) // 顶部布局安全高度
#define kSafeAreaBottomHeight ((iPhoneX)?(34.0f):0)      // 底部布局安全高度

#define kScreenScaleTo6                 (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)?(kScreenWidth/375.0f):(kScreenHeight/375.0f))       // 当前屏幕对应iPhone6比例
#define kSizeBasedOnIPhone6(float)      ((float)*kScreenScaleTo6)   // 根据iPhone6为基准计算出当前尺寸
#define RADIANS_TO_DEGREES(x)           ((x)/M_PI*180.0)            // 弧度转角度
#define DEGREES_TO_RADIANS(x)           ((x)/180.0*M_PI)            // 角度转弧度


#endif /* OnlyCommonDefine_h */
