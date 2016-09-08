//
//  DemoTableViewController.m
//  Quartz2D
//
//  Created by 舒超 on 16/5/22.
//  Copyright © 2016年 sc. All rights reserved.
//

#import "DemoTableViewController.h"
#import "DrawingBoardController.h"
#import "BeatMoleController.h"
#import "BeatAeroplaneController.h"
#import "FillSkyStarController.h"
#import "AngryBirdsController.h"
#import "CaterpillarController.h"
@interface DemoTableViewController ()
@property(nonatomic,strong)NSArray * dataArray;


@end

@implementation DemoTableViewController

- (NSArray *)dataArray{
    
    if (_dataArray == nil) {
        
        
        NSString * path = [[NSBundle mainBundle]pathForResource:@"Cell.plist" ofType:nil];
        
        
        _dataArray = [NSArray arrayWithContentsOfFile:path];
        
    }
    
    return _dataArray;
    
}

//重写init方法，改变tableView的样式
-(instancetype)initWithStyle:(UITableViewStyle)style{
    
    return [super initWithStyle:UITableViewStyleGrouped];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * button = [[UIBarButtonItem alloc]initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(didfanhui)];
    
    self.navigationItem.leftBarButtonItem = button;
    
    self.navigationItem.title = @"Demo列表";
}
#pragma mark
#pragma mark - 点击注销按钮
-(void)didfanhui{
//创建提示
    UIAlertController * alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"你确定要注销吗？" preferredStyle:UIAlertControllerStyleActionSheet];
//   添加按钮
    UIAlertAction * done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//      返回上层控制器
        [self.navigationController popViewControllerAnimated:YES];
    
    }];
    
    [alert addAction:done];
   
    UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
   
    [alert addAction:cancle];
    //弹出(模态)
    [self presentViewController:alert animated:YES completion:nil];
    

}

// 在tableView中有多少组数据
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count ;
}
// 每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 1.取出该组的所有数据
    NSDictionary *group = self.dataArray[section];
    // 2.取出改组内所有的行组成的数组
    NSArray *items = group[@"Items"];
    
    // 3.返回行数
    return items.count;
}
    


// 每一行要显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    
    // 1.取出该组的所有数据
    NSDictionary *group = self.dataArray[indexPath.section];
    // 2.取出改组内所有的行组成的数组
    NSArray *items = group[@"Items"];
    // 3 取出这一行的数据
    NSDictionary *item = items[indexPath.row];
    
    cell.textLabel.text = item[@"title"];
    

    return cell;
}

#pragma mark -
#pragma mark  设置组头文本
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headerString = @"";
    
    if (section == 0) {
        // 第1 组
        
        headerString = @"AppDemo";
        
    } else if (section == 1) {
        // 第2组
        headerString = @"小游戏";
    }
    
    return headerString;
}
#pragma mark
#pragma mark - 跳转cell中的控制器
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //第一组
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            // 第1行 : 满天星";
            FillSkyStarController * fillSkyStarController = [FillSkyStarController alloc];
            [self.navigationController pushViewController:fillSkyStarController animated:YES];
            
            
        } else if (indexPath.row == 1) {
//          第二行：保存图片
            DrawingBoardController * drawingBoardController = [DrawingBoardController alloc];
            [self.navigationController pushViewController:drawingBoardController animated:YES];
            
            //通过sb文件加载
            /*          通过sb文件加载
             UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             
             DrawingBoardController * view = [sb instantiateViewControllerWithIdentifier:@"image"];
             
             [self.navigationController pushViewController:view animated:YES];
             */
            
        }else if (indexPath.row == 2){
            
            CaterpillarController * caterpillarController = [CaterpillarController alloc];
            [self.navigationController pushViewController:caterpillarController animated:YES];
        
        }
        
        
        
    }
    else if (indexPath.section == 1) {
        // 第2组
        
        // 判断第2组的第几行
        if (indexPath.row == 0) {
            
            // 第1行 : 打飞机
            BeatAeroplaneController * beatAeroplaneController = [BeatAeroplaneController alloc];
            [self.navigationController pushViewController:beatAeroplaneController animated:YES];
            
            
        } else if(indexPath.row == 1){
            
            //  第二组 ： 第2行 打地鼠
            BeatMoleController * beatMoleController = [BeatMoleController alloc];
            [self.navigationController pushViewController:beatMoleController animated:YES];
    

        }else if(indexPath.row == 2){
            
            
            
        }else if(indexPath.row == 3){
            
            //  第二组 ： 第4行 打地鼠
            AngryBirdsController * angryBirdsController = [AngryBirdsController alloc];
            [self.navigationController pushViewController:angryBirdsController animated:YES];
            
            
        }


    }
    

}


@end
