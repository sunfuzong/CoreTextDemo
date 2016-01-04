//
//  CoreTextUtils.h
//  CoreTextDemo
//
//  Created by fuzong on 16/1/3.
//  Copyright © 2016年 fuzong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextLinkData.h"
#import "CoreTextData.h"

@interface CoreTextUtils : NSObject

+ (CoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data;

+ (CFIndex)touchContentOffsetInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data;

@end
