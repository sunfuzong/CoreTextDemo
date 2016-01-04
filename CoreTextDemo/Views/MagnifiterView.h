//
//  MagnifiterView.h
//  CoreTextDemo
//
//  Created by fuzong on 16/1/3.
//  Copyright © 2016年 fuzong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MagnifiterView : UIView

@property (weak, nonatomic) UIView *viewToMagnify;
@property (nonatomic) CGPoint touchPoint;

@end
