//
//  BeatAeroplaneController.m
//  Quartz2D
//
//  Created by 舒超 on 16/5/22.
//  Copyright © 2016年 sc. All rights reserved.
//

#import "BeatAeroplaneController.h"

@interface BeatAeroplaneController ()

@property(nonatomic,strong)UIView * aperoplane;

@property(nonatomic,strong)UIImageView * backgroundImageView;

@property(nonatomic,strong)NSMutableArray * setenemyAperoplaneArray;

@end

@implementation BeatAeroplaneController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _setenemyAperoplaneArray = [[NSMutableArray alloc]init];

    self.navigationItem.title = @"打灰机";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

    [self setAperoplane];
    [self setenemyAperoplane];

}

//隐藏导航状态栏
-(BOOL)prefersStatusBarHidden{
    return YES;
}
//添加
-(void)setAperoplane{
    
    UIView * aperoplane = [[UIView alloc]initWithFrame:CGRectMake(50, 550, 50, 50)];
    
    aperoplane.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"hero1"]];
    _aperoplane =aperoplane;
    
    
    
    [self.view addSubview:_aperoplane];

}
-(void)setenemyAperoplane{
    //创建敌机
    for (int i = 0; i<10; i++) {
        UIImageView *enemyAperoplane = [[UIImageView alloc]init];
        
        enemyAperoplane.frame = CGRectMake(10, i*25, 20, 20);
        
        enemyAperoplane.image = [UIImage imageNamed:@"diji"];
        
        [self.view addSubview:enemyAperoplane];
        
        [_setenemyAperoplaneArray addObject:enemyAperoplane];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  
    
   
    
    UITouch * touch  = touches.anyObject;
    
    //获取移动中的点
    CGPoint movePoint = [touch locationInView:self.view];
    
    CGPoint prePoint = [touch previousLocationInView:self.view];
    
    //计算两个点之间的差值
    CGFloat deltaX = movePoint.x - prePoint.x;
    
    
    // 修改yellowView的 transForm属性
    _aperoplane.transform = CGAffineTransformTranslate(_aperoplane.transform, deltaX, 0);
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{


}
@end
