//
//  FillSkyStarController.m
//  Dome实例
//
//  Created by 舒超 on 16/5/23.
//  Copyright © 2016年 sc. All rights reserved.
//

#import "FillSkyStarController.h"

@interface FillSkyStarController ()
@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation FillSkyStarController

-(NSArray *)imageArray{
    
    if (nil == _imageArray) {
        _imageArray = @[[UIImage imageNamed:@"spark_magenta"], [UIImage imageNamed:@"spark_cyan"]];
        
    }
    return _imageArray;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
        //导航栏隐藏 ， 不能隐藏，隐藏啦就不能pop
//    [self.navigationController setNavigationBarHidden:YES];

//    设置导航栏颜色   (不能这样设置，这样设置是全局的)
   self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
//    设置导航栏标题文本颜色
  self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};

    self.navigationItem.title = @"满天星";

    //开启多点触控
  self.view.multipleTouchEnabled = YES;


}

//              touch.tapCount : 点击的次数(连击)
//          UITouch *touch = touches.anyObje´ct;
//           存放的UITouch对象的个数表示 手指的个数
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    int index = 0;
    for (UITouch * touch in touches) {

        //获取点击的位置
        CGPoint touchPoint = [touch locationInView:self.view];
        
        UIImageView * imageView = [[UIImageView alloc] initWithImage:self.imageArray[index++]];
        
        //设置imageView的center
        
        imageView.center = touchPoint;
        
        // 延迟 隐藏并移除
        [UIView animateWithDuration:1 animations:^{
            imageView.alpha = 0;
        } completion:^(BOOL finished) {
            
            [imageView removeFromSuperview];
        }];
        
        
        
        
        
    }
}



//  电池栏隐藏
-(BOOL)prefersStatusBarHidden{

    return YES;
}

// 手指在屏幕上滑动的时候调用, 只要 手指不离开屏幕,就一直调用
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    int index = 0;
    
    for (UITouch *touch in touches) {
        
        // 获取UITouch 对象
        //        UITouch *touch = touches.anyObject;
        
        // 获取点击的位置
        CGPoint touchPoint = [touch locationInView:self.view];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.imageArray[index++]];
        
        // 设置imageView的center
        imageView.center = touchPoint;
        
        [self.view addSubview:imageView];
        
        // 延迟 隐藏并移除
        [UIView animateWithDuration:1 animations:^{
            imageView.alpha = 0;
        } completion:^(BOOL finished) {
            
            [imageView removeFromSuperview];
        }];
    }
    
}
#pragma mark
#pragma mark - 视图即将消失
-(void)viewWillDisappear:(BOOL)animated{
    
    //pop出来后重新给控制栏赋值颜色。 
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    
    
}


#pragma mark
#pragma mark - 视图已经消失   但是不能实现方法内功能
//-(void)viewDidDisappear:(BOOL)animated{
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
//
//}

@end
















