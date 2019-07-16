//
//  LGTimerViewController.m
//  003---强引用问题
//
//  Created by cooci on 2019/1/16.
//  Copyright © 2019 cooci. All rights reserved.
//

#import "LGTimerViewController.h"
#import "LGTimerWapper.h"
#import "LGProxy.h"
#import <objc/runtime.h>

static int num = 0;

@interface LGTimerViewController ()
@property (nonatomic, strong) NSTimer       *timer;
@property (nonatomic, strong) LGTimerWapper *timerWapper;
@property (nonatomic, strong) id            target;
@property (nonatomic, strong) LGProxy       *proxy;
@end

@implementation LGTimerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // 循环引用 -- 中间变量
    // runloop -> timer -> target -> self
    // self - taget 
//    self.target = [[NSObject alloc] init];
////    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self.target selector:@selector(fireHomeFunc) userInfo:nil repeats:YES];
//
//    // 中间层(RACKVOWapper)
//    // self -> timerWapper(释放不了) </-/> timer <- runloop
//    self.timerWapper = [[LGTimerWapper alloc] lg_initWithTimeInterval:1 target:self selector:@selector(fireHome) userInfo:nil repeats:YES];
    
    // 第三种
//     [self testTimerBlock];
    
    // 第四种 - 只要你想要有中间层 你都可以
    self.proxy = [LGProxy proxyWithTransformObject:self];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self.proxy selector:@selector(fireHome) userInfo:nil repeats:YES];

    
}
//
//- (void)didMoveToParentViewController:(UIViewController *)parent{
//    if (parent == nil) {
//        [self.timer invalidate];
//        self.timer = nil;
//    }
//    NSLog(@"我走了");
//}

void fireHomeFunc(){
    NSLog(@"%s",__func__);
}

- (void)fireHome{
    num++;
    NSLog(@"hello word - %d",num);
}

- (void)dealloc{
//    [self.timerWapper lg_invalidate];
//    [self.timer invalidate];
//    self.timer = nil;
    NSLog(@"%s",__func__);
    [self.timer invalidate];
    self.timer = nil;
}

- (void)testTimerBlock{
    // block 为什么没有强引用
    // self -> timer -> block
    // runloop -> timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"hello word - ");
    }];
}


@end
