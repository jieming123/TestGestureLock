//
//  LockView.h
//  TestGestureLock
//
//  Created by 杰铭 on 17/1/22.
//  Copyright © 2017年 杰铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LockView : UIView

/**
 九宫格点
 */
@property (nonatomic, strong) NSMutableArray *boxsArray;

/**
 经过密码点时显示中间白色圆点
 */
@property (nonatomic, strong) CAShapeLayer *dotLayer;

/**
 手势经过的点，即完整密码锁
 */
@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (nonatomic, strong) NSMutableArray *smallBoxsArray;

/**
 上一次经过的九宫格点的中心
 */
@property (nonatomic, assign) CGPoint lastPoint;

/**
 手势密码
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 判断已经划过圆点了
 */
@property (nonatomic, assign) BOOL isDot;

/**
 判断是否划过直线了
 */
@property (nonatomic, assign) BOOL isLine;

/**
 判断是不是在验证
 */
@property (nonatomic, assign) BOOL isVerify;

/**
 存放密码
 */
@property (nonatomic, strong) NSMutableArray *secretArray;

/**
 忘记密码按钮
 */
@property (nonatomic, strong) UIButton *forgetSecretBtn;

/**
 密码错误次数
 */
@property (nonatomic, assign) NSInteger errorSecretCount;

- (instancetype)initWithFrame:(CGRect)frame;



@end
