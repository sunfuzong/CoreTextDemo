//
//  HandlerData.h
//  CoreTextDemo
//
//  Created by fuzong on 15/11/27.
//  Copyright © 2015年 fuzong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTFrameParserConfig.h"

@interface HandlerData : NSObject
- (NSArray *)handlerData:(NSArray *)txtArr imageArray:(NSArray *)imgArr config:(CTFrameParserConfig *)config;
@end
