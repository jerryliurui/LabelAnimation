//
//  LabelAnimationHelper.m
//  LabelAnimationDemo
//
//  Created by JerryLiu on 2017/5/29.
//  Copyright © 2017年 JerryLiu. All rights reserved.
//

#import "LabelAnimationHelper.h"

@interface LabelAnimationHelper ()

@property (nonatomic , assign) BOOL commentAnimationHallyOpened;
@end

@implementation LabelAnimationHelper

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    __strong static id _sharedObject = nil;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

-(instancetype)init {
    if (self = [super init]) {
        _randomIncreaseCountArray = [NSArray new];
        _commentAnimationHallyOpened = [self halleyIsOpen];
    }
    return self;
    
}

- (void)configRandomArrayWithArrayCount:(NSInteger)count {
    //排重和排序 都需要count - 1个随机数
    count = count - 1;
    //count要大于等于1,下边两种情况特殊处理
    if (count == 0) {
        _randomIncreaseCountArray = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInteger:_randomReplyCount], nil];
        return;
    }
    
    if (count < 0) {
        _randomIncreaseCountArray =  nil;
        return;
    }
    
    if (_randomReplyCount <= count) {
        _randomIncreaseCountArray = nil;
        return;
    }
    
    //保证每一个随机数都不为0：这里减去多少（>0）都可以，只是为了保证最后一个随机数不为0
    _randomReplyCount -= count;
    
    //排重
    NSMutableArray *randomArray = [NSMutableArray new];
    while (randomArray.count < count) {
        int value = arc4random() % _randomReplyCount + 1;
        NSNumber *valueNumber = [NSNumber numberWithInt:value];
        
        if (![randomArray containsObject:valueNumber]) {
            [randomArray addObject:valueNumber];
        }
    }
    
    //排序
    NSArray *sortedArray = [NSArray new];
    sortedArray = [randomArray sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        NSInteger loc1 = [obj1 integerValue];
        NSInteger loc2 = [obj2 integerValue];
        if (loc1 < loc2) { return NSOrderedAscending; }
        else if (loc1 > loc2){ return NSOrderedDescending; }
        else { return NSOrderedSame; }
    }];
    
    //算出增长值
    NSMutableArray *diffArray = [NSMutableArray new];
    for (int i = 0; i < count; i ++) {
        if (i == 0) {
            diffArray[0] = [NSNumber numberWithInteger:[sortedArray[0] integerValue]];
        }else {
            diffArray[i] = [NSNumber numberWithInteger:[sortedArray[i] integerValue] - [sortedArray[i - 1] integerValue]];
        }
    }
    
    //还原sum
    _randomReplyCount += count;
    diffArray[count] = [NSNumber numberWithInteger:_randomReplyCount - [sortedArray[count - 1] integerValue]];
    
    if (diffArray) {
        _randomIncreaseCountArray = diffArray;
    }else{
        _randomIncreaseCountArray = nil;
    }
}

- (void)calculateRandomCountWithOri: (NSInteger)oriCount withPercentage: (CGFloat)percent {
    NSInteger randomCount = 0;
    if (percent > 1 || percent <= 0) {
        randomCount = 0;
    }else if (percent == 1) {
        randomCount = oriCount;
    }else {
        float remainder = oriCount % (int)(percent * 100);
        randomCount = oriCount * percent + remainder;
    }
    _randomReplyCount = randomCount;
}

- (BOOL)halleyIsOpen {
    return YES;
}

- (BOOL)isOpened {
    return self.commentAnimationHallyOpened;
}

- (void)resetAllProperty {
    self.commentAnimationHallyOpened = [self halleyIsOpen];
    self.randomReplyCount = self.currentTimes = 0;
    self.randomIncreaseCountArray = nil;
}


@end
