//
//  ViewController.m
//  LabelAnimationDemo
//
//  Created by JerryLiu on 2017/5/29.
//  Copyright © 2017年 JerryLiu. All rights reserved.
//

#import "ViewController.h"
#import "AnimationLabelView.h"
#import "UIView+Frame.h"
#import "LabelAnimationHelper.h"

@interface ViewController ()

@end

@implementation ViewController {
    AnimationLabelView *_animationView;
    UIButton *_startButton;
    LabelAnimationHelper *_animationHelper;
    NSTimer *_animationIntervalTimer;
    NSInteger _count;
}

- (void)viewDidLoad {
    _animationHelper = [LabelAnimationHelper sharedInstance];
    _count = 66666;
    [super viewDidLoad];
    [self buildBaseViews];
    [self buildAnimationView];
}

- (void)buildBaseViews {
    _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _startButton.backgroundColor = [UIColor greenColor];
    _startButton.frame = CGRectMake(self.view.width/2 - 20, 100, 40, 30);
    [_startButton setTitle:@"开始" forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(beginAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startButton];
}

- (void)buildAnimationView {
    __weak ViewController *weakSelf = self;
    
    AnimationLabelView *animationView = [[AnimationLabelView alloc] init];
    UIFont *labelFont = [animationView labelFont];
    CGFloat width = [[NSString stringWithFormat:@"%li",(long)_count] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:labelFont} context:nil].size.width;
    animationView.frame = CGRectMake(140, self.view.frame.size.height/2, width, 46);

    GotoCommentBlock block = ^() {
        [weakSelf sayHello];
    };
    animationView.gotoCommentBlock = block;
    
    _animationView = animationView;
    [self.view addSubview:_animationView];
    [_animationView changeCommentViewWithPlay:NO with:[NSString stringWithFormat:@"%li",(long)_count]];
}

- (void)sayHello {
    
}

- (void)beginAnimation {
    [_animationHelper calculateRandomCountWithOri:3333 withPercentage:1];
    [self startTimerToPlayCommentViewWithType:LabelAnimationHelperChangeValueTypeGroupAnimation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)startTimerToPlayCommentViewWithType:(LabelAnimationHelperChangeValueType)type {
    _animationHelper.currentTimes = 0;
    NSInteger arrayCount = 0;
    if (type == LabelAnimationHelperChangeValueTypeGroupAnimation) {
        arrayCount = COMMENT_RANDOM_COUNT;
    }else if (type == LabelAnimationHelperChangeValueTypeOnceAnimation) {
        arrayCount = 1;
    }else if (type == LabelAnimationHelperChangeValueTypeNoneAnimation) {
        arrayCount = 0;
    }else {
        return;
    }
    
    [_animationHelper configRandomArrayWithArrayCount:arrayCount];
    if (_animationHelper.randomIncreaseCountArray || arrayCount == 0) {

        _animationIntervalTimer = [NSTimer scheduledTimerWithTimeInterval:ANIMATION_TIME_INTERVAL target:self selector:@selector(playCommentViewAnimation) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_animationIntervalTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)playCommentViewAnimation {
    if (_animationHelper.randomIncreaseCountArray) {
        if (_animationHelper.randomIncreaseCountArray.count >= (_animationHelper.currentTimes+1)) {
            NSInteger increaseCount = [_animationHelper.randomIncreaseCountArray[_animationHelper.currentTimes] integerValue];
            if (increaseCount > 0) {
                _count += increaseCount;
                [_animationView changeCommentViewWithPlay:YES with:[NSString stringWithFormat:@"%li",(long)_count]];
            }
        }
    }
    
    _animationHelper.currentTimes += 1;
    if (_animationHelper.currentTimes == ANIMATION_TIMER_TIMES) {
        //停止定时器
        _animationHelper.currentTimes = 0;
        [_animationIntervalTimer invalidate];
    }
}


@end
