//
//  AnimationLabelView.m
//  LabelAnimationDemo
//
//  Created by JerryLiu on 2017/5/29.
//  Copyright © 2017年 JerryLiu. All rights reserved.
//

#import "AnimationLabelView.h"
#import "UIView+Frame.h"

#define ONE_CHAR_HEIGHT 16
#define FONT_SIZE 12.5
#define CHAR_STRING_TOP 15

@interface AnimationLabelView ()

@property (nonatomic,copy) NSString *commentText;
@property (nonatomic,assign) BOOL willPlay;
@property (nonatomic,strong) NSMutableArray *labelsArray;
@property (nonatomic,strong) NSArray *commentTextCharArray;
@property (nonatomic,strong) UIImageView *commentIconImage;
@property (nonatomic,assign) NSInteger animationTimes;
@end

@implementation AnimationLabelView

-(instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _labelsArray = [NSMutableArray new];
        _commentTextCharArray = [NSMutableArray new];
        [self buildBaseViews];
        [self addGotoCommentTap];
    }
    return self;
}

#pragma mark - UI
- (void)buildBaseViews {
    _commentIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(4, 13, 20, 20)];
    _commentIconImage.backgroundColor = [UIColor clearColor];
    [self addSubview:_commentIconImage];
    
    [self configIconImagesView];
}

- (void)configIconImagesView {
    UIImage *image = nil;
    image = [UIImage imageNamed:@"lalala"];
    _commentIconImage.image = image;
}

- (void)updateColorTheme {
    [self configIconImagesView];
    
    for (UILabel *label in _labelsArray) {
        [label setTextColor:[UIColor colorWithRed:(225)/255.0 green:(0)/255.0 blue:(0)/255.0 alpha:1]];
    }
}

- (void)layoutCommentViewsWithAnimationTimes:(NSInteger)times withCharArray:(NSArray *)charArray {
    if (!charArray) {
        return;
    }
    
    NSInteger labelCountDiff = charArray.count - _labelsArray.count;
    CGFloat width = [_commentText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[self labelFont]} context:nil].size.width;
    CGFloat oneCharWidth = width / charArray.count;
    if (labelCountDiff > 0) {
        //进位
        //调整其他label位置
        for (int i = 0; i < _labelsArray.count ; i ++) {
            UILabel *label = _labelsArray[i];
            label.frame = CGRectMake(_commentIconImage.right + 2 + (labelCountDiff * oneCharWidth) + i * oneCharWidth, CHAR_STRING_TOP, oneCharWidth, ONE_CHAR_HEIGHT);
        }
        //补label
        for (int i = 0; i < labelCountDiff ; i ++) {
            UILabel *charLabel = [[UILabel alloc] initWithFrame:CGRectMake(_commentIconImage.right + 2 + i * oneCharWidth, CHAR_STRING_TOP, oneCharWidth, ONE_CHAR_HEIGHT)];
            [charLabel setTextColor:[UIColor colorWithRed:(225)/255.0 green:(0)/255.0 blue:(0)/255.0 alpha:1]];
            charLabel.textAlignment = NSTextAlignmentLeft;
            UIFont *font = [self labelFont];
            [charLabel setFont:font];
            if (i < charArray.count) {
                [charLabel setText:charArray[i]];
            }
            [charLabel sizeToFit];
            [self addSubview:charLabel];
            charLabel.backgroundColor = [UIColor clearColor];
            [_labelsArray insertObject:charLabel atIndex:i];
        }
    }else if(labelCountDiff < 0){
        //减位
        labelCountDiff = -labelCountDiff;
        for (int i = 0; i < labelCountDiff ; i ++) {
            if (i >= 0 && i < _labelsArray.count) {
                UILabel *label = _labelsArray[i];
                [label removeFromSuperview];
                [_labelsArray removeObject:label];
            }
        }
        //调整其他label位置
        for (int i = 0; i < _labelsArray.count ; i ++) {
            UILabel *label = _labelsArray[i];
            label.frame = CGRectMake(_commentIconImage.right + 2 + i * oneCharWidth, CHAR_STRING_TOP, oneCharWidth, ONE_CHAR_HEIGHT);
        }
    }else {
        for (int i = 0; i < _labelsArray.count ; i ++) {
            UILabel *label = _labelsArray[i];
            label.frame = CGRectMake(_commentIconImage.right + 2 + i * oneCharWidth, CHAR_STRING_TOP, oneCharWidth, ONE_CHAR_HEIGHT);
        }
    }
    
    //经过上边的操作，现在label中就是新的label数组
    if (_willPlay) {
        //进行动画
        [self playCommentIconAnimation];
        if (times <= _labelsArray.count) {//动画次数是不可能大于现在的label数目的
            NSInteger index = charArray.count - 1;
            if ([self legalChangeValueAndLabelScopeWith:(int)index]) {
                UILabel *label = (UILabel *)_labelsArray[index];
                [self startLabelAnimation:label withLabelText:charArray[index] withIndex:index];
            }
        }
    }else {
        //不进行动画，普通赋值
        for (int i = 0 ; i < _labelsArray.count; i ++) {
            if ([self legalChangeValueAndLabelScopeWith:i]) {
                UILabel *label = (UILabel *)_labelsArray[i];
                NSString *oneCharString = _commentTextCharArray[i];
                [label setText:oneCharString];
                [label sizeToFit];
            }
        }
    }
}

#pragma mark - Tap to comment List
- (void)addGotoCommentTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGoToCommentView:)];
    [self addGestureRecognizer:tap];
}

- (void)tapGoToCommentView:(id)sender {
    if (self.gotoCommentBlock) {
        self.gotoCommentBlock();
    }
}

-(void)setGotoCommentBlock:(void (^)(void))gotoCommentBlock {
    _gotoCommentBlock = gotoCommentBlock;
}

#pragma mark - ConfigProperty
- (void)changeCommentViewWithPlay:(BOOL)willPlay with:(NSString *)commentText {
    if (!commentText) {
        return;
    }
    
    _willPlay = willPlay;
    
    //第一次赋值的时候
    if (!_commentText) {
        _animationTimes = 0;
    }else {//非第一次赋值
        _animationTimes = [self calculateAnimationTimesWithNewCommentText:commentText];
    }
    
    _commentTextCharArray = [self configCommentTextCharArrayWith:commentText];
    _commentText = commentText;
    
    [self layoutCommentViewsWithAnimationTimes:_animationTimes withCharArray:_commentTextCharArray];
}

#pragma mark - Animation
- (void)playCommentIconAnimation {
    //1.播放gif
    if (_commentIconImage) {
        if (!_commentIconImage.isAnimating) {
            [_commentIconImage startAnimating];
        }
    }
}

- (void)startLabelAnimation:(UILabel *)label withLabelText:(NSString *)text withIndex:(NSInteger)index {
    if (index < (_labelsArray.count - _animationTimes)) {
        return;
    }
    
    if (index < 0 || index > _labelsArray.count - 1 || index > _commentTextCharArray.count - 1) {
        return;
    }
    
    if (label && text) {
        [label setText:text];
    }
    
    for (UILabel *label in _labelsArray) {
        [label sizeToFit];
    }
    
    CGPoint originalP = label.layer.position;
    CAKeyframeAnimation *posAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSArray *values = @[[NSValue valueWithCGPoint:originalP],
                        [NSValue valueWithCGPoint:CGPointMake(originalP.x, originalP.y - 1.0)],
                        [NSValue valueWithCGPoint:CGPointMake(originalP.x, originalP.y - 3.0)],
                        [NSValue valueWithCGPoint:CGPointMake(originalP.x, originalP.y - 6.0)],
                        [NSValue valueWithCGPoint:CGPointMake(originalP.x, originalP.y - 3.0)],
                        [NSValue valueWithCGPoint:CGPointMake(originalP.x, originalP.y - 1.0)],
                        [NSValue valueWithCGPoint:CGPointMake(originalP.x, originalP.y + 0.5)],
                        [NSValue valueWithCGPoint:originalP]];
    posAnim.values = values;
    posAnim.keyTimes = @[@(0.0), @(0.05), @(0.4) , @(0.5) , @(0.75) , @(0.9) , @(0.95) , @(1.0)];
    posAnim.duration = 0.2;
    [label.layer addAnimation:posAnim forKey:@"labelAnimation"];
    
    NSInteger newIndex = index - 1;
    
    if (newIndex < 0 || newIndex > _labelsArray.count - 1 || newIndex > _commentTextCharArray.count - 1) {
        return;
    }
    
    UILabel *nextLabel = (UILabel *)_labelsArray[newIndex];
    NSString *nextString = _commentTextCharArray[newIndex];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        double delayInSeconds = 0.16;
        dispatch_time_t jumpTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(jumpTime, dispatch_get_main_queue(), ^{
            [self startLabelAnimation:nextLabel withLabelText:nextString withIndex:newIndex];
        });
    });
}

#pragma mark - Func
- (NSInteger )calculateAnimationTimesWithNewCommentText:(NSString *)increasedCommentText{
    //非法的新commentText 返回0
    if (!increasedCommentText) {
        return 0;
    }
    
    NSArray *increaseArray = [self configCommentTextCharArrayWith:increasedCommentText];
    if (_commentTextCharArray && increaseArray) {
        
        if (increaseArray.count != _commentTextCharArray.count) {//进位或者减位的情况，新view的每一位都要跳动
            return increaseArray.count;
        }else{//没有进位，具体判断
            NSInteger highestLocation = 0;
            for (int i = 0 ; i < increaseArray.count; i ++) {
                if (![increaseArray[i] isEqualToString:_commentTextCharArray[i]]) {
                    highestLocation = increaseArray.count - i;
                    break;
                }
            }
            return highestLocation;
        }
    }else {
        return 0;
    }
}

- (NSArray *)configCommentTextCharArrayWith:(NSString *)commentText {
    if(commentText){
        NSMutableArray *temArray = [NSMutableArray new];
        
        while (commentText.length != 0) {
            NSString *oneCharString = [commentText substringToIndex:1];
            [temArray addObject:oneCharString];
            commentText = [commentText substringFromIndex:1];
        }
        
        return temArray;
    }else {
        return nil;
    }
}

- (UIFont *)labelFont {
    CGFloat commentFontSize = FONT_SIZE;
    UIFont *commentFont = [UIFont systemFontOfSize:commentFontSize];
    return commentFont;
}

- (BOOL)legalChangeValueAndLabelScopeWith:(int)i {
    if (i >= 0 && i < _labelsArray.count && i < _commentTextCharArray.count) {
        return YES;
    }else {
        return NO;
    }
}

@end

