//
//  CoreTextImageData.h
//  CoreTextDemo
//
//  Created by fuzong on 15/11/27.
//  Copyright © 2015年 fuzong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreTextImageData : NSObject

@property (strong, nonatomic) NSString * imageUrl;
@property (nonatomic) NSInteger location;
@property (nonatomic, strong) NSString *desc;

// 此坐标是 CoreText 的坐标系，而不是UIKit的坐标系
@property (nonatomic) CGRect imagePosition;



@end
