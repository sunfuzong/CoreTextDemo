//
//  HandlerData.m
//  CoreTextDemo
//
//  Created by fuzong on 15/11/27.
//  Copyright © 2015年 fuzong. All rights reserved.
//

#import "HandlerData.h"
#import "HrefContentOperation.h"

@interface HandlerData ()

@property (nonatomic, strong) NSArray *txtArray;
@property (nonatomic, strong) NSArray *imgArray;

@end

@implementation HandlerData

- (NSArray *)handlerData:(NSArray *)txtArr imageArray:(NSArray *)imgArr  config:(CTFrameParserConfig *)config{
    self.txtArray = txtArr;
    self.imgArray = imgArr;
    NSMutableArray *resultArr = [NSMutableArray array];
    
    for (NSString *str in txtArr) {
        if ([str isEqualToString:@""]) {
            continue;
        }
        if ([str rangeOfString:@"[attach]"].location != NSNotFound) {
            NSDictionary *dict = [self buildImageContentWithString:str config:config];
            [resultArr addObject:dict];
        }else {
            NSArray *arr = [self buildTextContentWithString:str];
            [resultArr addObjectsFromArray:arr];
        }
        NSArray *arr = [self buildTextContentWithString:@"\n"];
        [resultArr addObjectsFromArray:arr];
    }
    
    return resultArr;
}

- (NSDictionary *)buildImageContentWithString:(NSString *)contentStr config:(CTFrameParserConfig *)config{
    NSRange range = [contentStr rangeOfString:@"[attach]"];
    NSUInteger startIndex = range.location + range.length;
    NSRange endRange = [contentStr rangeOfString:@"[/attach]"];
    if (endRange.location == 0 || endRange.location - startIndex <= 0) {
        return nil;
    }
    NSRange imageIdRange = NSMakeRange(startIndex, endRange.location - startIndex);
    NSString *imageId = [contentStr substringWithRange:imageIdRange];
    
    NSArray *imageInfo = [self seprateImageInfoWithImageId:imageId];
    if (imageInfo == nil) {
        return nil;
    }
    
    NSString *imageURLStr = imageInfo[3];
    CGFloat height = [imageInfo[2] floatValue];
    CGFloat width = [imageInfo[1] floatValue];
    CGFloat rh = height*config.width/width;
    return @{@"width":@(config.width) , @"height":@(rh), @"url":imageURLStr, @"type":@"img"};
}

- (NSArray *)seprateImageInfoWithImageId:(NSString *)imageId{
    
    for (NSArray *imageInfo in self.imgArray){
        NSString *tempImageId = nil;
        if ([imageInfo[0] isKindOfClass:[NSNumber class]]) {
            tempImageId = [imageInfo[0] stringValue];
        }
        if ([tempImageId isEqualToString:imageId]) {
            return imageInfo;
        }
    }
    return nil;
}

- (NSArray *)buildTextContentWithString:(NSString *)contentStr{
    HrefContentOperation *hrefContentOperation = [[HrefContentOperation alloc] initWithContent:contentStr];
    NSMutableArray *hrefContentArray = [hrefContentOperation separateHrefAndContent];
    NSMutableArray *tempArr = [NSMutableArray array];
    for (HrefContent *hrefContent in hrefContentArray){
        if (hrefContent.hasHref) {
            [tempArr addObject:@{@"type":@"link", @"content":hrefContent.content, @"url":hrefContent.url, @"color":@"#F3281B"}];
        }else {
            [tempArr addObject:@{@"type":@"txt", @"content":hrefContent.content}];
        }
    }
    return tempArr;
}

@end
