//
//  CoreTextLinkData.h
//  CoreTextDemo
//
//  Created by fuzong on 15/11/27.
//  Copyright © 2015年 fuzong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreTextLinkData : NSObject

@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * linkUrl;
@property (assign, nonatomic) NSRange range;

@end
