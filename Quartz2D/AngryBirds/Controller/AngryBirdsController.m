//
//  Controller AngryBirdsController.m
//  Dome实例
//
//  Created by 云卷云舒丶 on 16/6/6.
//  Copyright © 2016年 sc. All rights reserved.
//

#import "AngryBirdsController.h"

@interface AngryBirdsController ()<UICollisionBehaviorDelegate, UIDynamicAnimatorDelegate>
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) UIPushBehavior *push;
@property (nonatomic, strong) UICollisionBehavior *collistion;
@property (nonatomic, strong) UIView *birdView;

@property (nonatomic, weak) UIView *startPointView;
@property (nonatomic, weak) UIView *pigView;
@end

@implementation AngryBirdsController



- (UIDynamicAnimator *)animator {
    if (_animator == nil) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        
        // 为仿真器设置代理
        _animator.delegate = self;
    }
    return _animator;
}

- (UIGravityBehavior *)gravity {
    if (_gravity == nil) {
        _gravity = [[UIGravityBehavior alloc] init];
    }
    return _gravity;
}

- (UIPushBehavior *)push {
    if (_push == nil) {
        _push = [[UIPushBehavior alloc] initWithItems:@[self.birdView] mode:UIPushBehaviorModeInstantaneous];
    }
    return _push;
}

- (UICollisionBehavior *)collistion {
    if (_collistion == nil) {
        _collistion = [[UICollisionBehavior alloc] init];
        _collistion.translatesReferenceBoundsIntoBoundary = YES;
        _collistion.collisionDelegate = self;
    }
    return _collistion;
}

// 碰撞行为的代理方法
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2 atPoint:(CGPoint)p {
    
    // 当小鸟碰到小猪以后, 立刻让小猪具有重力行为
    [self.gravity addItem:self.pigView];
}


- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    // 全部重新初始化
    self.animator = nil;
    self.push = nil;
    self.gravity = nil;
    self.collistion = nil;
    
    for (UIView *vw in self.view.subviews) {
        [vw removeFromSuperview];
    }
    
    [self viewDidLoad];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//  设置view旋转90度。
    self.view.transform = CGAffineTransformMakeRotation(M_PI_2);

    // 设置背景
    self.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"bg"].CGImage);
    
    // 创建原点
    UIView *startPointView = [[UIView alloc] init];
//    startPointView.backgroundColor = [UIColor blackColor];
    startPointView.bounds = CGRectMake(0, 0, 2, 2);
    startPointView.center = CGPointMake(100, 200);
    [self.view addSubview:startPointView];
    self.startPointView = startPointView;
    
    
    // 创建小鸟
    UIView *birdView = [[UIView alloc] init];
    birdView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"bird"].CGImage);
    birdView.bounds = CGRectMake(0, 0, 30, 30);
    birdView.center = startPointView.center;
    birdView.layer.cornerRadius = 15;
    birdView.layer.masksToBounds = YES;
    birdView.alpha = 0.7;
    [self.view addSubview:birdView];
    self.birdView = birdView;
    // 为小鸟添加拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [birdView addGestureRecognizer:pan];
    
    
    
    
    
    
    // 创建小猪445,240
    UIView *pigView = [[UIView alloc] init];
    pigView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"pig"].CGImage);
    pigView.bounds = CGRectMake(0, 0, 50, 50);
    pigView.center = CGPointMake(445, 240);
    [self.view addSubview:pigView];
    self.pigView = pigView;
    
    
}

- (void)panAction:(UIPanGestureRecognizer *)recognizer {
    
    // 手指抬起
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // recognizer.view.transform = CGAffineTransformIdentity;
        
        
        
        
        // 1. 添加重力行为
        [self.gravity addItem:self.birdView];
        [self.animator addBehavior:self.gravity];
        
        
        // 2. 添加碰撞行为
        [self.collistion addItem:self.birdView];
        [self.collistion addItem:self.pigView];
        [self.animator addBehavior:self.collistion];
        
        // 2. 添加推力行为
        // 2.1 计算偏移
        // 获取拖拽手势的相对偏移值
        //        // 手指抬起是 offset 始终是0
        //        CGPoint offset = [recognizer translationInView:recognizer.view];
        //        NSLog(@"%@", NSStringFromCGPoint(offset));
        
        // 获取小鸟的当前位置（手指的位置）
        CGPoint loc = [recognizer locationInView:self.view];
        
        // 计算手指的位置相对于小黑点的偏移
        CGPoint offset = CGPointMake(loc.x - self.startPointView.center.x, loc.y - self.startPointView.center.y);
        
        // 设置推力方向和力量
        self.push.pushDirection = CGVectorMake(-offset.x, -offset.y);
        
        // 根据手指和"小黑点"的偏移, 计算距离（直角三角形的斜边）
        CGFloat distance = sqrtf(powf(offset.x, 2) + powf(offset.y, 2));
        // 根据距离重新设置力量
        self.push.magnitude = distance * 0.01;
        // 添加推力行为
        [self.animator addBehavior:self.push];
        
        
        
        
        
    } else {
        
        
        // 获取拖拽手势的相对偏移值
        CGPoint offset = [recognizer translationInView:recognizer.view];
        
        // 设置小鸟的位置
        recognizer.view.transform = CGAffineTransformTranslate(recognizer.view.transform, offset.x, offset.y);
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
    }

}


//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    //viewController所支持的全部旋转方向
//    return UIInterfaceOrientationMaskLandscapeLeft ;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    //viewController初始显示的方向
//    return UIInterfaceOrientationLandscapeLeft;
//}
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
//}

@end
