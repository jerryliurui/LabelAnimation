//
//  UIView+Frame.h
//  LabelAnimationDemo
//
//  Created by JerryLiu on 2017/5/29.
//  Copyright © 2017年 JerryLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)
@property (nonatomic, getter = top, setter = setTop:) CGFloat y;
@property (nonatomic, getter = left, setter = setLeft:) CGFloat x;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;

-(void)setOrigin:(CGPoint)loc;
-(void)setX:(CGFloat)x;
-(void)setY:(CGFloat)y;
-(void)setSize:(CGSize)sz;
-(void)setWidth:(CGFloat)w;
-(void)setHeight:(CGFloat)h;
-(void)setCenterX:(CGFloat)x;
-(void)setCenterY:(CGFloat)y;
-(CGPoint)origin;
-(CGFloat)x;
-(CGFloat)y;
-(CGFloat)left;
-(CGFloat)top;
-(CGFloat)bottom;
-(CGFloat)right;
-(CGSize)size;
-(CGFloat)height;
-(CGFloat)width;
-(CGFloat)centerX;
-(CGFloat)centerY;
-(CGFloat)maxX;
-(CGFloat)maxY;

@end
