//
//  CTFrameParserConfif.h
//  CoreTextDemo
//
//  Created by fuzong on 15/11/26.
//  Copyright © 2015年 fuzong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTFrameParserConfig : NSObject

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) NSString *fontNameString;
@property (nonatomic, assign) CGFloat fontSize;

@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, strong) UIColor *textColor;

@end
