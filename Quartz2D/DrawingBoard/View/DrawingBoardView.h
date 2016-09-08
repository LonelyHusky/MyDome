//
//  DrawingBoardView.h
//  Dome实例
//
//  Created by 舒超 on 16/5/23.
//  Copyright © 2016年 sc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawingBoardView : UIView

@property(nonatomic,assign)CGFloat  lineWidth;
@property(nonatomic,strong)UIColor * lineColor;
@property (nonatomic, strong) UIImage *image;


// 回退按钮
-(void)didClickHuiTuiButton;
// 清理按钮
-(void)didClickTidyUpButton;
// 添加文字
-(void)didClickLableButton;


@end
