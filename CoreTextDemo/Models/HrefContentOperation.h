//
//  HrefContentOperation.h
//  haitao
//
//  Created by buu iti on 14-10-14.
//  Copyright (c) 2014年 lianhechuangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HrefContent : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *rangeStr;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) BOOL hasHref;

@end

@interface HrefContentOperation : NSObject

- (id)initWithContent:(NSString *)content;

- (NSMutableArray *)separateHrefAndContent;

@end
