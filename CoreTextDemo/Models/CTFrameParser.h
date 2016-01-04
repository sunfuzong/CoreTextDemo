//
//  CTFrameParser.h
//  CoreTextDemo
//
//  Created by fuzong on 15/11/26.
//  Copyright © 2015年 fuzong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextData.h"
#import "CTFrameParserConfig.h"
#import "UIColor+Hex.h"
#import "CoreTextImageData.h"
#import "CoreTextLinkData.h"

@interface CTFrameParser : NSObject

+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig *)config;

+ (CoreTextData *)parseAttributeContent:(NSAttributedString *)content config:(CTFrameParserConfig *)config;

+ (CoreTextData *)parseTemplateArray:(NSArray *)paragraphs config:(CTFrameParserConfig *)config;
@end
