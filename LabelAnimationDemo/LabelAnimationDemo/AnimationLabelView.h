//
//  AnimationLabelView.h
//  LabelAnimationDemo
//
//  Created by JerryLiu on 2017/5/29.
//  Copyright © 2017年 JerryLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GotoCommentBlock)();

@interface AnimationLabelView : UIView <CAAnimationDelegate>

//点击整个view
@property (nonatomic,copy) void(^ gotoCommentBlock)(void);
//返回字体
- (UIFont *)labelFont;
- (void)changeCommentViewWithPlay:(BOOL)willPlay with:(NSString *)commentText;
- (void)updateColorTheme;

@end
