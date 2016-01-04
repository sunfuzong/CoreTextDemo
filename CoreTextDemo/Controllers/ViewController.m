//
//  ViewController.m
//  CoreTextDemo
//
//  Created by fuzong on 15/11/25.
//  Copyright © 2015年 fuzong. All rights reserved.
//

#import "ViewController.h"
#import "CoreTextDisplayView.h"
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"
#import "CTFrameParser.h"
#import "HandlerData.h"

@interface ViewController ()<CoreTextDisplayViewDelegate>

@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, strong) CoreTextDisplayView *coreTextView;

@property (nonatomic, strong) UIScrollView *contentView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.contentView];
    
    /*
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    config.textColor = [UIColor blackColor];
    config.width = self.contentView.frame.size.width - 40;
    config.fontNameString = @"Heiti SC";
    config.fontSize = 18.;
    config.lineSpace = 6.;
    
    NSArray *resultArr = @[
                           @{@"content":@"来自英国的沙龙香古龙水Jo Malone London 祖玛珑一直以纯粹的香氛取胜，不是大众街香可以相提并论的。",@"type":@"txt"},
                           @{@"content":@"\n",@"type":@"txt"},
                           @{@"content":@"Jo Malone London 祖玛珑的香水不仅可以单喷，混搭也别有一番情调，可以打造自己专属的香味，这套香水套装，混搭喷不用担心撞香真心赞！英国经典沙龙香Jo Malone London祖玛珑香水 Neiman Marcus尼曼百货官网满$200-$50！优惠码：THANKFUL",@"type":@"txt"},
                           @{@"content":@"\n",@"type":@"txt"},
                           @{@"color":@"#F3281B", @"content":@"Neiman Marcus尼曼美国官网Jo Malone London祖玛珑香水专区", @"type":@"img", @"url":@"http://redirect.viglink.com?key=dd6a20bcaca9710fd1a3dff8ef71de07&u=http://www.neimanmarcus.com/Jo-Malone-London/Beauty/cat1090734/c.cat"},
                           @{@"content":@"\n",@"type":@"txt"},
                           @{@"content":@"特别推荐：Jo Malone London Cologne Collection祖玛珑5只装限量套装",@"type":@"txt"},
                           @{@"content":@"\n",@"type":@"txt"},
                           @{@"height":@"467.5",@"type":@"img", @"width":@"374", @"url":@"http://images.123haitao.com/questions/20151127/15034b97136a3fb0b9189cfc9d24ac33.jpg"},
                           @{@"content":@"\n",@"type":@"txt"},
                           @{@"content":@"这款Jo Malone London Cologne Collection祖玛珑限量套装，内含5只，每只当家经典的香型，Lime Basil & Mandarin柠檬罗勒橘、Pomegranate Noir黒石榴、English Pear & Freesia英国梨和小苍兰、Peony Blush Suede 牡丹与胭红麂绒以及Wood Sage & Sea Salt鼠尾草与海盐香味。一套售价$115.00，共5支，一支9ML。满$200-$50！优惠码：THANKFUL。",@"type":@"txt"},
                           @{@"content":@"海淘购买链接一键直达",@"color":@"#F3281B",@"type":@"img", @"url":@"http://go.redirectingat.com?id=70097X1518509&xs=1&url=http://www.neimanmarcus.com/Jo-Malone-London-Cologne-Collection-New-This-Week/prod181650124_cat18030756__/p.prod"},
                           @{@"content":@"\n",@"type":@"txt"}
                           ];
    CoreTextData *data = [CTFrameParser parseTemplateArray:resultArr config:config];
    NSLog(@"4----------%f",[NSDate date].timeIntervalSince1970);
    self.coreTextView = [[CoreTextDisplayView alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 20, data.height)];
    self.coreTextView.data = data;
    [self.contentView addSubview:self.coreTextView];
    
    NSLog(@"6----------%f",[NSDate date].timeIntervalSince1970);
    self.contentView.contentSize = CGSizeMake(self.contentView.frame.size.width, data.height+20);
    */

    NSLog(@"1----------%f",[NSDate date].timeIntervalSince1970);
    NSURL *url = [NSURL URLWithString:@"http://www.123haitao.com/api/client/get_detail/?id=70611"];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    __weak __block ViewController *weakSelf = self;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        if (error != nil) {
            NSLog(@"%@",error);
            return ;
        }
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingAllowFragments
                                                                 error:nil];
        [[NSURLSession sharedSession] finishTasksAndInvalidate];
        NSLog(@"2----------%f",[NSDate date].timeIntervalSince1970);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf handlerData:dic[@"data"]];
        });
    }];
    [task resume];
    
}

- (void)handlerData:(NSDictionary *)dic {
    self.dict = [dic copy];
    
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    config.textColor = [UIColor blackColor];
    config.width = self.contentView.frame.size.width - 40;
    config.fontNameString = @"Heiti SC";
    config.fontSize = 18.;
    config.lineSpace = 6.;
    
    HandlerData *handler = [[HandlerData alloc] init];
    NSArray *resultArr = [handler handlerData:self.dict[@"infoText"] imageArray:self.dict[@"infoImages_url"] config:config];
    NSLog(@"3----------%f",[NSDate date].timeIntervalSince1970);

    CoreTextData *data = [CTFrameParser parseTemplateArray:resultArr config:config];
    NSLog(@"4----------%f",[NSDate date].timeIntervalSince1970);
    self.coreTextView = [[CoreTextDisplayView alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 20, data.height)];
    self.coreTextView.data = data;
    self.coreTextView.delegate = self;
    self.coreTextView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.coreTextView];
    
    NSLog(@"6----------%f",[NSDate date].timeIntervalSince1970);
    self.contentView.contentSize = CGSizeMake(self.contentView.frame.size.width, data.height+20);
    
    NSLog(@"content scrollview content size %@",NSStringFromCGSize(self.contentView.contentSize));
}

- (void)coreTextDisplayView:(CoreTextDisplayView *)ctDisplayView didPressedType:(CTContentPressedType)pressType withInfo:(NSDictionary *)info {
    NSLog(@"%@",info);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
