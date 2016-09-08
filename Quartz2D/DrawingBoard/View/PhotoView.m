//
//  PhotoView.m
//  09-小画板
//
//  Created by Apple on 16/5/23.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "PhotoView.h"

@interface PhotoView()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation PhotoView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        // 开启用户交互, 和多点触控
        imageView.userInteractionEnabled = YES;
        imageView.multipleTouchEnabled = YES;
        
        self.imageView = imageView;
        
        [self addSubview:imageView];
        
        
        // 添加各种手势
        
        // 旋转
        UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
        
        rotate.delegate = self;
        
        [imageView addGestureRecognizer:rotate];
        
        // 缩放
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
        
        [imageView addGestureRecognizer:pinch];
        
        // pan
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        
        [imageView addGestureRecognizer:pan];
        
        // 长按
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        
        [imageView addGestureRecognizer:longPress];
        
        
        
    }
    return self;
}


- (void)rotate:(UIRotationGestureRecognizer *)rotate {
    
    rotate.view.transform = CGAffineTransformRotate(rotate.view.transform, rotate.rotation);
    
    rotate.rotation = 0;
}


- (void)pinch:(UIPinchGestureRecognizer *)pinch {
    
    pinch.view.transform = CGAffineTransformScale(pinch.view.transform, pinch.scale, pinch.scale);
    
    pinch.scale = 1;
    
}



- (void)pan:(UIPanGestureRecognizer *)pan {
    
    CGPoint panPoint = [pan translationInView:pan.view];
    
    pan.view.transform = CGAffineTransformTranslate(pan.view.transform, panPoint.x, panPoint.y);
    
    [pan setTranslation:CGPointZero inView:pan.view];
    
}



#pragma mark
#pragma mark - 实现长按手势
- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        // 开始动画
        [UIView animateWithDuration:1 animations:^{
            
            longPress.view.alpha = 0.5;
            
        } completion:^(BOOL finished) {
           
            [UIView animateWithDuration:1 animations:^{
                
                longPress.view.alpha = 1;
                
            } completion:^(BOOL finished) {
                
                // 开启图片上下文
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
                
                
                // 获取图片上下文
                CGContextRef context = UIGraphicsGetCurrentContext();
                
                // 渲染
                [self.layer renderInContext:context];
                
                // 从当前上下文中获取图片
                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                
                
                UIGraphicsEndImageContext();
                
                
                // 把图片传递给 viewController
                
                if (_tempBlock) {
                    _tempBlock(image);
                }
                
            }];
        }];
    }
    
}


// 解决手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark
#pragma mark - 取到图片
- (void)setImage:(UIImage *)image {
    
    _image = image;
    
    self.imageView.image = _image;
    
}





#pragma mark
#pragma mark - layoutSubViews
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _imageView.bounds = CGRectMake(0, 0, _image.size.width, _image.size.height);
    
    _imageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
}

@end












