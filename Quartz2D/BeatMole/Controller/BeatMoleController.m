//
//  BeatMoleController.m
//  Quartz2D
//
//  Created by 舒超 on 16/5/22.
//  Copyright © 2016年 sc. All rights reserved.
//

#import "BeatMoleController.h"
#import "BeatMoleView.h"
@interface BeatMoleController ()

@end

@implementation BeatMoleController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    [self setupUI];
}

#pragma mark
#pragma mark - 设置界面
-(void)setupUI{
    CGSize viewSize = self.view.bounds.size;
    BeatMoleView * moleView = [[BeatMoleView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.width)];
    //设置moleView的中心点
    moleView.center = CGPointMake(viewSize.width/2, viewSize.height/2);
    [self.view addSubview:moleView];

    

}

@end
