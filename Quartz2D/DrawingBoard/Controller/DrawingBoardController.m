//
//  DrawingBoardController.m
//  Dome实例
//
//  Created by 舒超 on 16/5/23.
//  Copyright © 2016年 sc. All rights reserved.
//

#import "DrawingBoardController.h"
#import "DrawingBoardView.h"
#import "PhotoView.h"
@interface DrawingBoardController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

#define kOrigin (self.view.frame.origin)
#define kSize (self.view.frame.size)
@property (nonatomic,weak) DrawingBoardView * drawingBoardView;
@property (nonatomic,weak)UISlider *screen;
@property(nonatomic,strong)UIColor * lineColor;
@property (nonatomic, weak) PhotoView *photoView;


@end

@implementation DrawingBoardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    //导航栏隐藏，
//    [self.navigationController setNavigationBarHidden:YES];
//创建绘图区域
    [self addDrawingBoard];
//创建导航栏按钮
    [self addNavigationBar];
//创建工具条
    [self addToolbar];
    
}

#pragma mark
#pragma mark - 创建绘图区域
-(void)addDrawingBoard{
    
    DrawingBoardView * drawingBoardView = [[DrawingBoardView alloc]initWithFrame:CGRectMake(0, kOrigin.y + 44 , kSize.width, kSize.height - 44 - 60 - 49)];
    drawingBoardView.backgroundColor = [UIColor whiteColor];
   
    _drawingBoardView = drawingBoardView;
    
    [self.view addSubview:drawingBoardView];
    
}

#pragma mark
#pragma mark - 创建工具条
-(void)addToolbar{
    
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake( 0,560, 375, 60)];
    
    UIBarButtonItem * redItem = [[UIBarButtonItem alloc] initWithTitle:@"红色" style:UIBarButtonItemStylePlain target:self action:@selector(didClickRedButton)];
    
    UIBarButtonItem * yellowItem = [[UIBarButtonItem alloc] initWithTitle:@"黄色" style:UIBarButtonItemStylePlain target:self action:@selector(didClickyellowButton)];
    
    UIBarButtonItem * greenItem = [[UIBarButtonItem alloc] initWithTitle:@"绿色" style:UIBarButtonItemStylePlain target:self action:@selector(didClickGreenButton)];
     UIBarButtonItem * LableItem = [[UIBarButtonItem alloc] initWithTitle:@"添加文字" style:UIBarButtonItemStylePlain target:self action:@selector(didClickLableButton)];
    
    toolbar.items = @[redItem,yellowItem,greenItem,LableItem];
    
    
    [self.view addSubview:toolbar];
    
    UISlider * screen = [[UISlider alloc]initWithFrame:CGRectMake(75/2, 0, 300, 30)];
    _screen = screen;
    //  需要监听他。否则只在创建时调用一次，之后将不掉用啦。
    [screen addTarget:self action:@selector(moveScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    screen.minimumValue = 1;
    screen.maximumValue = 50;
    
    _drawingBoardView.lineWidth = screen.value;
    
    [toolbar addSubview:screen];


}

#pragma mark
#pragma mark - Color点击方法
//红色
-(void)didClickRedButton{
    
    _drawingBoardView.lineColor = [UIColor redColor];

    
}
//黄色Color点击方法
-(void)didClickyellowButton{
    
    
    _drawingBoardView.lineColor = [UIColor yellowColor];
}
// 绿色Color点击方法
-(void)didClickGreenButton{
    _drawingBoardView.lineColor = [UIColor greenColor];

    
    
}

#pragma mark
#pragma mark - 移动Screen
-(void)moveScreen:(UISlider *)value{

    _drawingBoardView.lineWidth = self.screen.value;


}

#pragma mark
#pragma mark - 创建导航条按钮
-(void)addNavigationBar{
    
    
    UIBarButtonItem * tidyUpButton = [[UIBarButtonItem alloc]initWithTitle:@"清理" style:UIBarButtonItemStylePlain target:self action:@selector(didClickTidyUpButton)];
    UIBarButtonItem * huituiButton = [[UIBarButtonItem alloc]initWithTitle:@"回退" style:UIBarButtonItemStylePlain target:self action:@selector(didClickHuiTuiButton)];
    UIBarButtonItem * eraserButton = [[UIBarButtonItem alloc]initWithTitle:@"橡皮擦" style:UIBarButtonItemStylePlain target:self action:@selector(didiClickEraserButton)];
    UIBarButtonItem * addPictureButton = [[UIBarButtonItem alloc]initWithTitle:@"添加照片" style:UIBarButtonItemStylePlain target:self action:@selector(addPicture)];
    UIBarButtonItem * preserveButton = [[UIBarButtonItem alloc]initWithTitle:@"保存照片" style:UIBarButtonItemStylePlain target:self action:@selector(didClickPreserveButton)];
    UIBarButtonItem * didClickLeaveButton = [[UIBarButtonItem alloc]initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeave)];

    
    NSArray * arr =@[huituiButton,tidyUpButton,eraserButton,addPictureButton,preserveButton,didClickLeaveButton];
    self.navigationItem.leftBarButtonItems = arr;
    
}


//隐藏导航状态栏
-(BOOL)prefersStatusBarHidden{
    
    return YES;
}

#pragma mark
#pragma mark - 添加文字按钮
-(void)didClickLableButton{
    
    [_drawingBoardView didClickLableButton];

}

#pragma mark
#pragma mark - 回退按钮
-(void)didClickHuiTuiButton{
    [_drawingBoardView didClickHuiTuiButton];
    
}

#pragma mark
#pragma mark - 清理按钮
-(void)didClickTidyUpButton{
    
    [_drawingBoardView didClickTidyUpButton];
}

#pragma mark
#pragma mark - 橡皮擦
-(void)didiClickEraserButton{
    
    
    _drawingBoardView.lineColor = [UIColor whiteColor];
}

#pragma mark
#pragma mark - 添加图片
-(void)addPicture{
    UIImagePickerController * pickerController = [[UIImagePickerController alloc]init];
    // 资源类型
    // UIImagePickerControllerSourceTypeSavedPhotosAlbum 时刻
    // UIImagePickerControllerSourceTypeCamera 相机
    // UIImagePickerControllerSourceTypePhotoLibrary 图片汇总
    pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    设置代理
    pickerController.delegate =self;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}


#pragma mark
#pragma mark - imagePicker的 代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // 取出被选择的照片
    UIImage *selectImage = info[UIImagePickerControllerOriginalImage];
    
    
    // 创建一个view, 用来展示 用户选择的图片
    PhotoView *photoView = [[PhotoView alloc] initWithFrame:_drawingBoardView.frame];
    
    self.photoView = photoView;
    
    
    
    // 为 photoView 的 image 赋值
    photoView.image = selectImage;
    
    
    __weak DrawingBoardController *weakSelf = self;
    
    // 为tempBlock 赋值
    photoView.tempBlock = ^(UIImage *image){
        
        // 把image 传递给  
        weakSelf.drawingBoardView.image = image;
        
        // 把photoView 给移除掉
        [weakSelf.photoView removeFromSuperview];
        
    };
    
    
    [self.view addSubview:photoView];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    


}


#pragma mark
#pragma mark - 保存到相册
-(void)didClickPreserveButton{
    
    //  开启图片上下文
    UIGraphicsBeginImageContextWithOptions(_drawingBoardView.frame.size, NO, 0);
    
    //    获取当前上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //    把drawView的layer渲染到当前上下文
    [_drawingBoardView.layer renderInContext:context];
    
    // 4. 从当前的图片上下文中获取图片
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5. 关闭上下文
    UIGraphicsEndImageContext();
    
    // 6. 保存到相册
    UIImageWriteToSavedPhotosAlbum(image,nil, nil, nil);
    
}

#pragma mark
#pragma mark -  退出方法
-(void)didClickLeave{
    //创建提示
    UIAlertController * alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"你确定不保存退出吗？" preferredStyle:UIAlertControllerStyleActionSheet];
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




@end
















