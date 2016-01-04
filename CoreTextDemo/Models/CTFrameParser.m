//
//  CTFrameParser.m
//  CoreTextDemo
//
//  Created by fuzong on 15/11/26.
//  Copyright © 2015年 fuzong. All rights reserved.
//

#import "CTFrameParser.h"

@implementation CTFrameParser

+ (NSMutableDictionary *)attributesWithConfig:(CTFrameParserConfig *)config {
    CGFloat fontSize = config.fontSize;
    NSString *fontNameString = config.fontNameString;
    CGFloat lineSpace = config.lineSpace;
    UIColor *textColor = config.textColor;
    
    //字体
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)fontNameString, fontSize, NULL);
    //行间距
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpace},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpace},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpace}
    };
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    //配置属性
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[(id)kCTFontAttributeName] = (__bridge id)(fontRef);
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    //释放资源
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    
    return dict;
}

+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetterRef config:(CTFrameParserConfig *)config height:(CGFloat)height {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frameRef;
}

+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig *)config {
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSAttributedString *contentString = [[NSAttributedString alloc] initWithString:content attributes:attributes];
    
    //创建CTFramesetterRef实例
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)contentString);
    //获取要绘制的区域
    CGSize drawSize = CGSizeMake(config.width, MAXFLOAT);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetterRef, CFRangeMake(0, 0), nil, drawSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    //生成CTFrameRef
    CTFrameRef frameRef = [self createFrameWithFramesetter:framesetterRef config:config height:textHeight];
    
    //将生成好的CTFrameRef实例和计算好的绘制高度保存到CoreTextData实例中，最后返回CoreTextData实例
    CoreTextData *data = [[CoreTextData alloc] init];
    data.ctFrame = frameRef;
    data.height = textHeight;
    data.content = contentString;
    
    CFRelease(frameRef);
    CFRelease(framesetterRef);
    return data;
}

+ (CoreTextData *)parseAttributeContent:(NSAttributedString *)content config:(CTFrameParserConfig *)config {
    //创建CTFramesetterRef实例
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    //获取要绘制的区域
    CGSize drawSize = CGSizeMake(config.width, MAXFLOAT);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetterRef, CFRangeMake(0, 0), nil, drawSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    //生成CTFrameRef
    CTFrameRef frameRef = [self createFrameWithFramesetter:framesetterRef config:config height:textHeight];
    
    //将生成好的CTFrameRef实例和计算好的绘制高度保存到CoreTextData实例中，最后返回CoreTextData实例
    CoreTextData *data = [[CoreTextData alloc] init];
    data.ctFrame = frameRef;
    data.height = textHeight;
    data.content = content;
    
    CFRelease(frameRef);
    CFRelease(framesetterRef);
    return data;
}

/**
 * 模板数据解析
 */
+ (CoreTextData *)parseTemplateArray:(NSArray *)templateArr config:(CTFrameParserConfig *)config {
    NSMutableArray *linkArray = [NSMutableArray array];
    NSMutableArray *imageArray = [NSMutableArray array];
    NSAttributedString *attrs = [self loadTemplateArray:templateArr config:config imageArray:imageArray linkArray:linkArray];
    
    CoreTextData *data = [self parseAttributeContent:attrs config:config];
    data.imageArray = imageArray;
    data.linkArray = linkArray;
    return data;
}

+ (NSAttributedString *)loadTemplateArray:(NSArray *)templateArr
                                  config:(CTFrameParserConfig*)config
                              imageArray:(NSMutableArray *)imageArray
                               linkArray:(NSMutableArray *)linkArray {
    
    NSMutableAttributedString *attrs = [[NSMutableAttributedString alloc] init];
    if (templateArr.count > 0) {
        for (NSDictionary *item in templateArr) {
            NSString *type = item[@"type"];
            if ([type isEqualToString:@"txt"]) {
                //文本
                NSAttributedString *attr = [self parseAttributedContentFromNSDictionary:item config:config];
                [attrs appendAttributedString:attr];
            }else if ([type isEqualToString:@"img"]) {
                //图片
                CoreTextImageData *imageData = [[CoreTextImageData alloc] init];
                imageData.location = [attrs length];
                imageData.imageUrl = item[@"url"];
                [imageArray addObject:imageData];
                
                NSAttributedString *attr = [self parseImageDataFromNSDictionary:item config:config];
                [attrs appendAttributedString:attr];
            }else if ([type isEqualToString:@"link"]) {
                //超链接
                NSUInteger startPos = attrs.length;
                NSAttributedString *attr = [self parseAttributedContentFromNSDictionary:item
                                                                               config:config];
                [attrs appendAttributedString:attr];
                
                NSUInteger length = attrs.length - startPos;
                NSRange linkRange = NSMakeRange(startPos, length);
                CoreTextLinkData *linkData = [[CoreTextLinkData alloc] init];
                linkData.linkUrl = item[@"url"];
                linkData.title = item[@"content"];
                linkData.range = linkRange;
                
                [linkArray addObject:linkData];
            }
        }
    }
    
    return attrs;
}

//普通文本
+ (NSAttributedString *)parseAttributedContentFromNSDictionary:(NSDictionary *)dict
                                                        config:(CTFrameParserConfig*)config {
    NSMutableDictionary *attributes = [self attributesWithConfig:config];
    // set color
    UIColor *color = [self colorFromTemplate:dict[@"color"]];
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    // set font size
    CGFloat fontSize = [dict[@"fontSize"] floatValue];
    NSString *fontNameStr = dict[@"fontName"];
    if (fontSize > 0 && fontNameStr.length > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)fontNameStr, fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }else if(fontSize > 0){
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)config.fontNameString, fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }else if (fontNameStr.length > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)fontNameStr, config.fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    NSString *content = dict[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}
//图片
+ (NSAttributedString *)parseImageDataFromNSDictionary:(NSDictionary *)dict
                                                config:(CTFrameParserConfig*)config {
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(dict));
    
    // 使用0xFFFC作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary * attributes = [self attributesWithConfig:config];
    NSMutableAttributedString * space = [[NSMutableAttributedString alloc] initWithString:content
                                                                               attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    return space;
}

+ (UIColor *)colorFromTemplate:(NSString *)colorStr {
    if (colorStr == nil) {
        return nil;
    }
    return [UIColor colorWithHexString:colorStr];
}

static CGFloat ascentCallback(void *ref) {
    return [(NSNumber*)[(__bridge NSDictionary *)ref objectForKey:@"height"] floatValue];
}

static CGFloat descentCallback(void *ref){
    return 0;
}

static CGFloat widthCallback(void* ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}

@end
