//
//  GesturePassword.h
//  Quartz2D
//
//  Created by 舒超 on 16/5/22.
//  Copyright © 2016年 sc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GesturePassword;
@protocol GesturePasswordDelegate <NSObject>

- (void)GesturePassword:(GesturePassword *)GesturePassword didFinishDrawWithPassword:(NSString *)password;


@end

@interface GesturePassword : UIView

@property (nonatomic, weak) id<GesturePasswordDelegate> delegate;

@property (nonatomic, copy) NSString *errorPassword;

@end
