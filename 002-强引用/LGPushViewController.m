//
//  LGPushViewController.m
//  003---强引用问题
//
//  Created by cooci on 2019/1/16.
//  Copyright © 2019 cooci. All rights reserved.
//

#import "LGPushViewController.h"
#import "LGProxy.h"

@interface LGPushViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (nonatomic, strong) LGProxy *proxy;
@property (nonatomic, strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *lgImageView;

@end

@implementation LGPushViewController


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tf resignFirstResponder];
    self.proxy = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self.proxy name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // self -> proxy -> self
    
    [[NSNotificationCenter defaultCenter] addObserver:self.proxy selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       [self manyVaribersDemo];
    });
    
    self.proxy = [LGProxy proxyWithTransformObject:self];

    NSTimer* timer = [NSTimer timerWithTimeInterval:1 target:self.proxy selector:@selector(RepeatNslog) userInfo:nil repeats:YES];
    
    
}

- (void)RepeatNslog
{
    NSLog(@"timer repeat");
}


- (void)keyboardWillShow:(NSNotification *)note{
    NSLog(@"note == %@ --- %@",note,self);
}

- (void)imageDemo{
    CIImage *beginImage = [[CIImage alloc]initWithImage:[UIImage imageNamed:@"image"]];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:beginImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:.1] forKey:@"inputBrightness"];//亮度-1~1
    CIImage *outputImage = [filter outputImage];
    
    //GPU优化
    
    EAGLContext * eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    eaglContext.multiThreaded = YES;
    CIContext *context = [CIContext contextWithEAGLContext:eaglContext];
    [EAGLContext setCurrentContext:eaglContext];
    CGImageRef ref = [context createCGImage:outputImage fromRect:outputImage.extent];
    UIImage *endImg = [UIImage imageWithCGImage:ref];
    self.lgImageView.image = endImg;
    CGImageRelease(ref);//非OC对象需要手动内存释放
    
}

- (void)manyVaribersDemo{
//    for (int i = 0; i < 100000; i++) {
//        NSString *string = @"Abc";
//        string = [string lowercaseString];
//        string = [string stringByAppendingString:@"xyz"];
//        NSLog(@"%@", string);
//    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.tf resignFirstResponder];
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
