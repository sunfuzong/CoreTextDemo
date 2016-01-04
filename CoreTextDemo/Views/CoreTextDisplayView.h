//
//  CoreTextDisplayView.h
//  CoreTextDemo
//
//  Created by fuzong on 15/11/25.
//  Copyright © 2015年 fuzong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreTextData.h"

typedef enum CTContentPressedType : NSInteger {
    CTContentPressedLink,       // 超链接
    CTContentPressedImage     // 图片
}CTContentPressedType;

@class CoreTextDisplayView;

@protocol CoreTextDisplayViewDelegate <NSObject>

@optional
- (void)coreTextDisplayView:(CoreTextDisplayView *)ctDisplayView didPressedType:(CTContentPressedType)pressType withInfo:(NSDictionary *)info;

@end


@interface CoreTextDisplayView : UIView

@property (nonatomic, strong) CoreTextData *data;

@property (nonatomic, weak) id<CoreTextDisplayViewDelegate> delegate;

@end
