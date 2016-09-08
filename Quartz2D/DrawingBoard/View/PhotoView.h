//
//  PhotoView.h
//  09-小画板
//
//  Created by Apple on 16/5/23.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TempBlock)(UIImage *);


@interface PhotoView : UIView


@property (nonatomic, strong) UIImage *image;


// 用来传递 image
@property (nonatomic, copy) TempBlock tempBlock;

@end
