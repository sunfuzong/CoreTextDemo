//
//  CoreTextData.h
//  CoreTextDemo
//
//  Created by fuzong on 15/11/26.
//  Copyright © 2015年 fuzong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextImageData.h"

@interface CoreTextData : NSObject

@property (nonatomic, assign) CTFrameRef ctFrame;
@property (nonatomic, assign) CGFloat height;
@property (strong, nonatomic) NSArray * imageArray;
@property (strong, nonatomic) NSArray * linkArray;
@property (strong, nonatomic) NSAttributedString *content;

@end
