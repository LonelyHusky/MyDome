//
//  GesturePassword.m
//  Quartz2D
//
//  Created by 舒超 on 16/5/22.
//  Copyright © 2016年 sc. All rights reserved.
//

#import "GesturePassword.h"

// 表示按钮的宽高
#define kButtonWidth 80

// 表示有3列
#define kColumn 3

// 表示有9个按钮
#define kCount 9

#define kViewSize (self.frame.size)

#define kRightColor ([[UIColor blueColor] set])

#define kWrongColor ([[UIColor redColor] set])
@interface GesturePassword()

// 存放所有的button , 9个按钮
@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, strong) NSMutableArray *selectedArray;

// 是用来记录当前手指的位置
@property (nonatomic, assign) CGPoint  currentPoint;

// 记录当前密码是否是正确状态
@property (nonatomic, assign) BOOL right;

@end

@implementation GesturePassword

#pragma mark
#pragma mark - 初始化 被选中按钮的数组
- (NSMutableArray *)selectedArray {
    
    if (nil == _selectedArray) {
        
        _selectedArray = [NSMutableArray array];
        
    }
    return _selectedArray;
}

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
        
        // 把right bool 默认设置为YES
        _right = YES;
        
        [self setupUI];
    }
    return self;

}
#pragma mark
#pragma mark - 添加按钮
-(void)setupUI{

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
        button.adjustsImageWhenHighlighted = NO;
        
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

#pragma mark
#pragma mark - 绘制 错误的密码
- (void)setErrorPassword:(NSString *)errorPassword {
    _errorPassword = errorPassword;
    
    NSInteger length = errorPassword.length;
    
    for (int i = 0; i < length; i++) {
        
        // 创建range 也就是截取的范围
        NSRange range = NSMakeRange(i, 1);
        
        NSInteger index =  [[errorPassword substringWithRange:range] integerValue];
        
        UIButton *button = self.buttonArray[index];
        
        button.selected = YES;
        
        // 修改按钮的 选中的背景图片
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_error"] forState:UIControlStateSelected];
        
        // 把按钮放入 selectedArray 中
        [self.selectedArray addObject:button];
        
    }
    
    // 修改 颜色标记
    _right = NO;
    
    // 重绘
    [self setNeedsDisplay];
    
    
    // 延迟执行 清空 lockView 操作
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 清空lockView
        [self resetLockView];
    });
    
}


#pragma mark
#pragma mark - 绘制线条
- (void)drawRect:(CGRect)rect {
    
    if (self.selectedArray.count != 0) {
        // 开始绘制
        // 获取图形上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // 设置线宽
        CGContextSetLineWidth(context, 10);
        
        // 设置颜色
        _right ?  kRightColor : kWrongColor;

        
        // 声明一个c语言数组
        CGPoint point[9];
        // 定义一个索引
        int index = 0;
        
        
        for (UIButton *button in self.selectedArray) {
            
            // 取出button的中心点
            CGPoint buttonCenter = button.center;
            
            // 把中心点放到 数组中
            point[index++] = buttonCenter;
            
        }
        
        
        /**
         第一个参数: 上下文
         第二个参数: 数组, 存放的是 CGPoint
         第三个参数: 数组的个数
         */
        CGContextAddLines(context, point, index);
        
        
        // 渲染
        CGContextStrokePath(context);
        
        // 绘制 跟随 手指移动的线
        // 取出 在 selectedArray 中 最后一个按钮
        UIButton *lastButton = self.selectedArray.lastObject;
        
        // 取出 最后一个按钮的 中心点
        CGPoint lastPoint = lastButton.center;
        
        // 拼接路径
        CGContextMoveToPoint(context, lastPoint.x, lastPoint.y);
        
        CGContextAddLineToPoint(context, _currentPoint.x, _currentPoint.y);
        
        // 设置 线头样式
        CGContextSetLineCap(context, kCGLineCapRound);
        
        // 渲染
        CGContextStrokePath(context);
        
    }
    
}


#pragma mark
#pragma mark - 开始点击
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self checkPointInsideWith:touches];

}
#pragma mark
#pragma mark - 手指移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self checkPointInsideWith:touches];
    
    
}

#pragma mark
#pragma mark - 手指离开屏幕
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 先取出密码
    NSMutableString *password = [NSMutableString string];
    
    for (UIButton *button in self.selectedArray) {
        
        [password appendFormat:@"%ld", button.tag];
    }

    // 恢复界面
    // 按钮的状态
    // 清空lockView
    [self resetLockView];
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(GesturePassword:didFinishDrawWithPassword:)]) {
        [self.delegate GesturePassword:self didFinishDrawWithPassword:password];
    }
}

    


#pragma mark
#pragma mark - 检测手指所在的位置是否在 button 的半径之中
-(void)checkPointInsideWith:(NSSet* )touches{
    
    // 获取当前点击的位置
    UITouch *touch = touches.anyObject;
    
    CGPoint touchPoint = [touch locationInView:self];
    
    // 和button的中心点进行比对 , 如果 x和y 的差值 小于button宽度的一半, 就表示 这个点在button内部
    for (UIButton *button in self.buttonArray) {
        
        // 取出button的中心点
        CGPoint buttonCenter = button.center;
        
        // 计算x和y 之间的差值
        CGFloat deltaX = ABS(buttonCenter.x - touchPoint.x);
        
        CGFloat deltaY = ABS(buttonCenter.y - touchPoint.y);
        
        // 对间距进行判断
        if (deltaX < kButtonWidth/2 && deltaY < kButtonWidth/2) {
            
            if (!button.isSelected) {
                
                button.selected = YES;
                
                // 把这个被选中按钮添加到 被选择数组中
                [self.selectedArray addObject:button];
            }
        }
        
    }
    
    // 为 当前点进行赋值
    _currentPoint = touchPoint;
    
    // 重绘
    [self setNeedsDisplay];
    
}

#pragma mark
#pragma mark - 清空lockView
- (void)resetLockView {
    
    // 恢复界面
    // 按钮的状态
    for (UIButton *button in self.selectedArray) {
        
        button.selected = NO;
        
        

        // 把背景图片换成蓝色的 (如果绘制错误的时候, 会切换背景图片 为 红色的)
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
    }
    
    // 线条也要清除掉 (清空数组)
    [self.selectedArray removeAllObjects];
    
    // 把线条的颜色恢复成蓝色
    _right = YES;
    
    // 重绘
    [self setNeedsDisplay];
}
@end




























