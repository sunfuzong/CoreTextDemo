//
//  HrefContentOperation.m
//  haitao
//
//  Created by buu iti on 14-10-14.
//  Copyright (c) 2014年 lianhechuangyi. All rights reserved.
//

#import "HrefContentOperation.h"

@implementation HrefContent


@end

@interface HrefContentOperation()

@property (nonatomic, strong) NSMutableArray *hrefContentArray;
@property (nonatomic, strong) NSString *content;
@end

@implementation HrefContentOperation

- (id)initWithContent:(NSString *)content{
    self = [super init];
    if (self) {
        self.content = content;
        self.hrefContentArray = [NSMutableArray array];
    }
    return self;
}

- (NSMutableArray *)separateHrefAndContent{
    
    NSArray *strArray = [self.content componentsSeparatedByString:@"<a>"];
    for (NSString *str in strArray){
        if ([str rangeOfString:@"](http:"].location == NSNotFound && [str rangeOfString:@"](https:"].location == NSNotFound) {
            HrefContent *hrefContent = [[HrefContent alloc] init];
            hrefContent.content = str;
            hrefContent.hasHref = NO;
            [self.hrefContentArray addObject:hrefContent];
        }else{
            HrefContent *hrefContent = [self separaterSubString:str];
            if (hrefContent == nil) {
                continue;
            }
            [self.hrefContentArray addObject:hrefContent];
//            [self.hrefContentArray addObject:[self separaterSubString:str]];
        }
    }
    return self.hrefContentArray;
}

- (HrefContent *)separaterSubString:(NSString *)subString{
    HrefContent *hrefContent = [[HrefContent alloc] init];
    NSRange range = [subString rangeOfString:@"]("];
    if (range.location == 0) {
        return nil;
    }
    

    
    NSRange contentRange = NSMakeRange(1, range.location - 1);
    NSString *hrefContentStr = [subString substringWithRange:contentRange];
    hrefContent.content = hrefContentStr;
    hrefContent.hasHref = YES;
    subString = [subString substringFromIndex:range.location];
    NSRange hrefRange = [subString rangeOfString:@")"];
    hrefRange = NSMakeRange(2, subString.length - 3);
    hrefContent.url = [subString substringWithRange:hrefRange];
    return hrefContent;
}

@end
