//
//  LabelAnimationHelper.h
//  LabelAnimationDemo
//
//  Created by JerryLiu on 2017/5/29.
//  Copyright © 2017年 JerryLiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define COMMENT_COUNT_THRESHOLD 250//动画数字最少（业务相关）
#define COMMENT_COUNT_RANDOM_PERCENT 0.1//取原母数的百分之X作为随机数
#define COMMENT_RANDOM_COUNT 10 //分为10组差值增长
#define ANIMATION_TIMER_TIMES 10//定时器启动次数
#define ANIMATION_TIME_INTERVAL 3//动画间隔

typedef NS_ENUM(NSInteger, LabelAnimationHelperChangeValueType) {
    LabelAnimationHelperChangeValueTypeGroupAnimation,
    LabelAnimationHelperChangeValueTypeOnceAnimation,
    LabelAnimationHelperChangeValueTypeNoneAnimation
};

@interface LabelAnimationHelper : NSObject

@property (nonatomic , assign) BOOL commentViewPlaying;
@property (nonatomic , assign) BOOL overThreshold;

@property (nonatomic , strong) NSArray *randomIncreaseCountArray;
@property (nonatomic , assign) NSInteger randomReplyCount;
@property (nonatomic , assign) NSInteger currentTimes;

+ (instancetype)sharedInstance;

/**
 *  将randomReplyCount分成count个随机数
 */
- (void)configRandomArrayWithArrayCount:(NSInteger)count;

/**
 *  将oriCount取百分之XX， 计算出随机母数randomReplyCount
 */
- (void)calculateRandomCountWithOri: (NSInteger)oriCount withPercentage: (CGFloat)percent;

/**
 *  是否满足业务要求，例如功能是否打开
 */
- (BOOL)isOpened;

/**
 *  重置一下
 */
- (void)resetAllProperty;

@end
