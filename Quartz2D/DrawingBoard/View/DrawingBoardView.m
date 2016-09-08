//
//  DrawingBoardView.m
//  Dome实例
//
//  Created by 舒超 on 16/5/23.
//  Copyright © 2016年 sc. All rights reserved.
//

#import "DrawingBoardView.h"
#import "SCBezierPath.h"
@interface DrawingBoardView ()<UITextViewDelegate>

@property(nonatomic,strong)UIBezierPath * bezierPath;

@property(nonatomic,strong)NSMutableArray * pathArray;

@property(nonatomic,strong)UITextView * textView;

@end


@implementation DrawingBoardView

#pragma mark
#pragma mark - 懒加载数组
-(NSMutableArray *)pathArray{

    if (nil == _pathArray) {
        _pathArray= [NSMutableArray array];
    }
    return _pathArray;
}

#pragma mark
#pragma mark - 开始触摸
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //获取点击到位置
    UITouch * touch = touches.anyObject;
    
    CGPoint touchPoint = [touch locationInView:touch.view];
    
    //创建bezierPath
    SCBezierPath * bezierPath = [SCBezierPath bezierPath];
    
    //设置线宽
    bezierPath.lineWidth = _lineWidth;
    //设置颜色
    bezierPath.lineColor = _lineColor;
    //添加点
    [bezierPath moveToPoint:touchPoint];
    
    self.bezierPath =bezierPath;
    
    //把bezierPath添加到数组
    [self.pathArray addObject:bezierPath];
    
  

}
#pragma mark
#pragma mark - 手指滑动
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    
    //获取点击的位置
    UITouch * touch = touches.anyObject;
    
    CGPoint touchPoint = [touch locationInView:touch.view];
    
    [self.bezierPath addLineToPoint:touchPoint];
    
    //重绘
    [self setNeedsDisplay];


}


#pragma mark
#pragma mark - 绘制界面
-(void)drawRect:(CGRect)rect{
    
    
    for (SCBezierPath * path in self.pathArray) {
        if (path.image) {
            
            [path.image drawAtPoint:CGPointZero];
        } else {
            // 取出path中的颜色, 进行设置
            [path.lineColor set];
            
            [path stroke];
        }
        
    }
}

#pragma mark
#pragma mark - 添加文字按钮
-(void)didClickLableButton{

    
    
    UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10,100 , 30)];
    _textView = textView;
    
    textView.layer.borderWidth = 1;
    textView.text = @"请输入文字";
    textView.textColor = [UIColor lightGrayColor];
    textView.layer.borderColor = UIColor.brownColor.CGColor;
    
    if (textView.text.length == 0) {
        textView.textColor = [UIColor blackColor];
    }else{
        textView.textColor = [UIColor lightGrayColor];
    }
    [self addSubview:textView];
}

#pragma mark
#pragma mark - 重写图片的set方法
- (void)setImage:(UIImage *)image {
    _image = image;
    
    //    _bezierPath.image = image;]
    
    // 创建一个新的bezierPath
    SCBezierPath *bezierPath = [SCBezierPath bezierPath];
    
    bezierPath.image = image;
    
    // 把path 添加到数组中
    [self.pathArray addObject:bezierPath];
    
    // 重绘
    [self setNeedsDisplay];
}




#pragma mark
#pragma mark - 点击回退按钮
-(void)didClickHuiTuiButton{

    [self.pathArray removeLastObject];
    [self setNeedsDisplay];

}

#pragma mark
#pragma mark - 点击清理按钮
-(void)didClickTidyUpButton{
    [self.textView removeFromSuperview ];
    [self.pathArray removeAllObjects];
    [self setNeedsDisplay];

}




@end




















