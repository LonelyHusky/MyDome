//
//  BeatMoleView.m
//  Quartz2D
//
//  Created by 舒超 on 16/5/22.
//  Copyright © 2016年 sc. All rights reserved.
//

#import "BeatMoleView.h"

// 表示按钮的宽高
#define kButtonWidth 80

// 表示有3列
#define kColumn 3

// 表示有9个按钮
#define kCount 9

#define kViewSize (self.frame.size)

@interface BeatMoleView ()

// 存放所有的button , 9个按钮
@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation BeatMoleView

#pragma mark
#pragma mark - 初始化 array
- (NSMutableArray *)buttonArray {
    
    if (nil == _buttonArray) {
        
        _buttonArray = [NSMutableArray array];
        
    }
    return _buttonArray;
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];

        [self setButton];
    }
    
    return self;
}

#pragma mark
#pragma mark - 添加Button
-(void)setButton{
    
    //计算按钮之间的间隙
    CGFloat margin = (kViewSize.width - kColumn * kButtonWidth) / (kColumn + 1);
    
    for (int i = 0 ; i<kCount; i++) {
        
        //计算列索引和行索引
        NSInteger rowIndex = i / kColumn;
        NSInteger columnIndex = i % kColumn;
        
        //计算 x 和 y
        CGFloat buttonX =  (columnIndex + 1) * margin + columnIndex * kButtonWidth;
        
        CGFloat buttonY = (rowIndex + 1) * margin + rowIndex * kButtonWidth;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, kButtonWidth, kButtonWidth)];
        
        //禁止高亮状态
//        button.adjustsImageWhenHighlighted = NO;
        
        //设置背景图片
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        
        // 选中背景图片
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        
        // 为button 设置tag , 用来作为 密码
        button.tag = i;
        
        button.userInteractionEnabled = NO;
        
        // 把按钮添加到数组
        [self.buttonArray addObject:button];
        [self addSubview:button];
        
    }
    
    
    
}


@end

