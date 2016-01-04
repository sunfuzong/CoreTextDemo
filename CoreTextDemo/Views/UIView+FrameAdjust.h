//
//  UIView+FrameAdjust.h
//  CoreTextDemo
//
//  Created by fuzong on 15/11/26.
//  Copyright © 2015年 fuzong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameAdjust)

- (CGPoint)origin;
- (void)setOrigin:(CGPoint) point;

- (CGSize)size;
- (void)setSize:(CGSize) size;

- (CGFloat)x;
- (void)setX:(CGFloat)x;

- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)tail;
- (void)setTail:(CGFloat)tail;

- (CGFloat)bottom;
- (void)setBottom:(CGFloat)bottom;

- (CGFloat)right;
- (void)setRight:(CGFloat)right;

@end
