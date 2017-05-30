//
//  AnimationLabelView.h
//  LabelAnimationDemo
//
//  Created by JerryLiu on 2017/5/29.
//  Copyright © 2017年 JerryLiu. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

#pragma UIView+Frame

#pragma mark - Right
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

#pragma mark - Bottom
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

-(CGFloat)bottom{
    return self.frame.origin.y + self.frame.size.height;
}

#pragma mark - Origin
- (void)setOrigin:(CGPoint)origin{
    CGRect rc = self.frame;
    rc.origin = origin;
    self.frame = rc;
}

-(CGPoint)origin{
    return self.frame.origin;
}

#pragma mark - Top
- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

#pragma mark - Left
- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(void)setX:(CGFloat)x{
    CGRect rc = self.frame;
    rc.origin.x = x;
    self.frame = rc;
}

-(void)setY:(CGFloat)y{
    CGRect rc = self.frame;
    rc.origin.y = y;
    self.frame = rc;
}

-(void)setSize:(CGSize)sz{
    CGRect rc = self.frame;
    rc.size = sz;
    self.frame = rc;
}

-(void)setWidth:(CGFloat)w{
    CGRect rc = self.frame;
    rc.size.width = w;
    self.frame = rc;
}

-(void)setHeight:(CGFloat)h{
    CGRect rc = self.frame;
    rc.size.height = h;
    self.frame = rc;
}

-(void)setCenterY:(CGFloat)y{
    CGPoint pt = self.center;
    pt.y = y;
    self.center = pt;
}

-(void)setCenterX:(CGFloat)x{
    CGPoint pt = self.center;
    pt.x = x;
    self.center = pt;
}

-(CGFloat)x{
    return self.frame.origin.x;
}

-(CGFloat)y{
    return self.frame.origin.y;
}

-(CGSize)size{
    return self.frame.size;
}

-(CGFloat)height
{
    return self.frame.size.height;
}

-(CGFloat)width
{
    return self.frame.size.width;
}

-(CGFloat)centerX{
    return self.center.x;
}

-(CGFloat)centerY{
    return self.center.y;
}

-(CGFloat)maxX{
    return CGRectGetMaxX(self.frame);
}

-(CGFloat)maxY{
    return CGRectGetMaxY(self.frame);
}
@end
