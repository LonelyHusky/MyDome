//
//  ViewController.m
//  毛毛虫
//
//  Created by steve zhao on 15/12/21.
//  Copyright © 2015年 itheima. All rights reserved.
//

#import "CaterpillarController.h"
#define SHCZViewCount 9

@interface CaterpillarController ()

// 创建一个用来保存"毛毛虫"身体的数组
@property (nonatomic, strong) NSArray *bodies;

// 创建一个动画者, 用来执行动画的对象
@property (nonatomic, strong) UIDynamicAnimator *animator;

// 创建一个重力行为
@property (nonatomic, strong) UIGravityBehavior *gravity;

// 创建一个碰撞行为
@property (nonatomic, strong) UICollisionBehavior *collision;

// 拖拽手势
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UIAttachmentBehavior *attachment;


@end

@implementation CaterpillarController

- (UIPanGestureRecognizer *)panGesture {
    if (_panGesture == nil) {
        _panGesture =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self.view addGestureRecognizer:_panGesture];
    }
    return _panGesture;
}

- (void)panAction:(UIPanGestureRecognizer *)recognizer {
    CGPoint loc = [recognizer locationInView:recognizer.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        UIAttachmentBehavior *attachment  =[[UIAttachmentBehavior alloc] initWithItem:self.headView attachedToAnchor:loc];
        [self.animator addBehavior:attachment];
        self.attachment = attachment;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        self.attachment.anchorPoint = loc;
    } else {
        [self.animator removeBehavior:self.attachment];
    }
    
}

- (NSArray *)bodies {
    if (_bodies == nil) {
        
        NSMutableArray *arrayM = [NSMutableArray array];
        
        // 设置毛毛虫身体的 frame
        CGFloat bodyW = 20;
        CGFloat bodyH = bodyW;
        CGFloat bodyY = 50;
        
        // 循环创建"毛毛虫"的身体
        for (int i = 0; i < SHCZViewCount; i++) {
            // 创建 view
            UIView *vw = [[UIView alloc] init];
            
            // 判断是要作为身体还是头部
            if (i == SHCZViewCount - 1) {
                // "毛毛虫"的头部
                vw.layer.cornerRadius = 10 * 2;
                vw.layer.masksToBounds = YES;
                vw.backgroundColor = [UIColor greenColor];
                
                // 先重新计算 x 和 y
                bodyY = bodyY - bodyH * 0.5;
                CGFloat bodyX = i * bodyW;
                // 再重新计算 w 和 h
                bodyW *= 2;
                bodyH *= 2;
                vw.frame = CGRectMake(bodyX, bodyY, bodyW, bodyH);
                
                self.headView = vw;
            } else {
                
                // "毛毛虫"的身体
                vw.layer.cornerRadius = 10;
                vw.layer.masksToBounds = YES;
                vw.backgroundColor = [UIColor blueColor];
                
                CGFloat bodyX = i * bodyW;
                vw.frame = CGRectMake(bodyX, bodyY, bodyW, bodyH);
            }
            [self.view addSubview:vw];
            [arrayM addObject:vw];
        }
        _bodies = arrayM.copy;
    }
    return _bodies;
}


- (UIDynamicAnimator *)animator {
    if (_animator == nil) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

- (UIGravityBehavior *)gravity {
    if (_gravity == nil) {
        _gravity = [[UIGravityBehavior alloc] initWithItems:self.bodies];
        [self.animator addBehavior:_gravity];
    }
    return _gravity;
}

- (UICollisionBehavior *)collision {
    if (_collision == nil) {
        _collision = [[UICollisionBehavior alloc] initWithItems:self.bodies];
        // 设置碰撞的边界
        _collision.translatesReferenceBoundsIntoBoundary = YES;
        [self.animator addBehavior:_collision];
    }
    return _collision;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bodies];
    
    [self gravity];
    
    [self collision];
    
    self.view.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < self.bodies.count - 1; i++) {
        UIView *vw = self.bodies[i];
        // 添加附着行为
        UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:vw attachedToItem:self.bodies[i+1]];
        attachment.length = 30;
        [self.animator addBehavior:attachment];
    }
    
    [self panGesture];
    

}

//- (void)loadBody {
//    // 创建"毛毛虫"的身体
//    CGFloat bodyW = 20;
//    CGFloat bodyH = bodyW;
//    CGFloat bodyY = 50;
//    for (int i = 0; i < SHCZViewCount; i++) {
//        // 创建 view
//        UIView *vw = [[UIView alloc] init];
//        
//        // 判断是要作为身体还是头部
//        if (i == SHCZViewCount - 1) {
//            // "毛毛虫"的头部
//            vw.layer.cornerRadius = 10 * 2;
//            vw.layer.masksToBounds = YES;
//            vw.backgroundColor = [UIColor greenColor];
//            
//            // 先重新计算 x 和 y
//            bodyY = bodyY - bodyH * 0.5;
//            CGFloat bodyX = i * bodyW;
//            // 再重新计算 w 和 h
//            bodyW *= 2;
//            bodyH *= 2;
//            vw.frame = CGRectMake(bodyX, bodyY, bodyW, bodyH);
//            
//            [self.view addSubview:vw];
//            
//            
//        } else {
//            
//            // "毛毛虫"的身体
//            vw.layer.cornerRadius = 10;
//            vw.layer.masksToBounds = YES;
//            vw.backgroundColor = [UIColor blueColor];
//            
//            CGFloat bodyX = i * bodyW;
//            vw.frame = CGRectMake(bodyX, bodyY, bodyW, bodyH);
//            
//            [self.view addSubview:vw];
//            
//            
//            // 创建一个附着行为
//            UIAttachmentBehavior *attachment = [UIAttachmentBehavior alloc] initWithItem:<#(nonnull id<UIDynamicItem>)#> attachedToItem:<#(nonnull id<UIDynamicItem>)#>
//        }
//        
//        // 为重力行为添加 "动力项"
//        [self.gravity addItem:vw];
//        
//        // 为碰撞行为添加 "动力项"
//        [self.collision addItem:vw];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
