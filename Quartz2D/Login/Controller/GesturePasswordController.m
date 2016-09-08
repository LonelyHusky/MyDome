//
//  GesturePasswordController.m
//  Quartz2D
//
//  Created by 舒超 on 16/5/22.
//  Copyright © 2016年 sc. All rights reserved.
//

#import "GesturePasswordController.h"
#import "GesturePassword.h"
#import "DemoTableViewController.h"

@interface GesturePasswordController ()<GesturePasswordDelegate>

// 用来记录密码的
@property (nonatomic, strong) NSString *lastPassword;

@property (nonatomic, weak) UILabel *noticeLabel;

@end

@implementation GesturePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置颜色
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];

}

#pragma mark
#pragma mark - 设置界面
-(void)setupUI{
    
    //添加提醒的Lable
    UILabel * noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 375, 40)];
    
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    self.noticeLabel = noticeLabel;
    
    //设置文本
    noticeLabel.text = @"请绘制你的解锁密码";

    [self.view addSubview:noticeLabel];
    
    CGSize viewSize = self.view.bounds.size;
    
    //添加GesturePassword
    GesturePassword * gesturePassword = [[GesturePassword alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.width)];

    //设置GesturePassword的中心点
    gesturePassword.center= CGPointMake(viewSize.width/2, viewSize.height/2);
    
    gesturePassword.delegate =self;
    
    [self.view addSubview:gesturePassword];

}
#pragma mark
#pragma mark - GesturePassword的代理方法
-(void)GesturePassword:(GesturePassword *)GesturePassword didFinishDrawWithPassword:(NSString *)password{
    
    if (_lastPassword == nil ) {
        //是第一次输入
        _lastPassword = password;
        
        //修改lable文字显示
        [self showNoticeMessageWith:@"请再次绘制一次" success:YES];
        
    }else{
        // 表示 第二次绘制
        if ([_lastPassword isEqualToString:password]) {
            // 密码正确
            // 保存密码
            // 修改label文本显示
            //            _noticeLabel.text = @"两次绘制相同, 即将返回首页";
            [self showNoticeMessageWith:@"两次绘制相同, 即将登陆" success:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                

                
                DemoTableViewController * demoTableViewController =[[DemoTableViewController alloc]init];
                [self.navigationController pushViewController:demoTableViewController animated:YES];
                
                
            });
            
            
        } else {
            // 密码错误
        
            [self showNoticeMessageWith:@"密码错误" success:NO];
             GesturePassword.errorPassword = password;
        }
    }


}

#pragma mark
#pragma mark - 修改noticeLabel的显示效果
- (void)showNoticeMessageWith:(NSString *)text success:(BOOL)success {
    
    _noticeLabel.text = text;
    
    UIColor *color = success ? [UIColor blackColor] : [UIColor redColor];
    
    _noticeLabel.textColor = color;

    
    _noticeLabel.transform = CGAffineTransformMakeTranslation(20, 0);
    
    if (!success) {
        // 颤抖吧
        
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.2
              initialSpringVelocity:0.8
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             _noticeLabel.transform = CGAffineTransformIdentity;
                             
                         }
                         completion:^(BOOL finished) {
                             _noticeLabel.transform = CGAffineTransformIdentity;
                             
                         }];
    }
    
}
@end



























