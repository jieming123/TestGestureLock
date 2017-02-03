//
//  LockView.m
//  TestGestureLock
//
//  Created by 杰铭 on 17/1/22.
//  Copyright © 2017年 杰铭. All rights reserved.
//

#import "LockView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

static const CGFloat Space = 30.0;              //圆的间距
static const NSInteger BoxCount = 4;            // 连接圆的虽小个数
static const NSInteger ShakeCount = 3;          // 错误时震动的次数
static const CGFloat AnimationDuration = 0.1;   // 错误时震动的时间
static const CGFloat RadiusMultiple = 8;        // 大圆比小圆点的半径倍数

static NSString * const NoSelected = @"noselected";  //没选中
static NSString * const Selected = @"selected";      //选中

static NSString * const SmallNoSelected = @"smallnoselect";
static NSString * const SmallSelected = @"smallselect";

@implementation LockView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor purpleColor];
        self.isVerify = NO;
        self.errorSecretCount = 0;
        [self addSubview:self.titleLabel];
        [self addSmallGestureBox];
        [self addGesturesBox];
        [self addSubview:self.forgetSecretBtn];
    }
    return self;
}


#pragma mark - lazy loading
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, kScreenWidth, 25)];
        _titleLabel.text = @"绘制手势密码";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UIButton *)forgetSecretBtn {
    
    if (!_forgetSecretBtn) {
        
        _forgetSecretBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetSecretBtn.frame = CGRectMake(kScreenWidth - 64, 0, 64, 64);
        [_forgetSecretBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetSecretBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_forgetSecretBtn addTarget:self action:@selector(forgrtSecret:) forControlEvents:UIControlEventTouchUpInside];
        _forgetSecretBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _forgetSecretBtn.hidden = YES;
    }
    return _forgetSecretBtn;
}

- (NSMutableArray *)boxsArray {
    
    if (!_boxsArray) {
        
        _boxsArray = [NSMutableArray array];
    }
    return _boxsArray;
}

- (NSMutableArray *)selectedArray {
    
    if (!_selectedArray) {
        
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

- (NSMutableArray *)secretArray {
    
    if (!_secretArray) {
        
        _secretArray = [NSMutableArray array];
    }
    return _secretArray;
}

- (NSMutableArray *)smallBoxsArray {
    
    if (!_smallBoxsArray) {
        
        _smallBoxsArray = [NSMutableArray arrayWithCapacity:9];
    }
    return _smallBoxsArray;
}

#pragma mark - btn action
- (void)forgrtSecret:(UIButton *)btn {
    
    NSLog(@"忘记密码！");
}

#pragma mark - add view
- (void)addSmallGestureBox {
    
    CGFloat width = 10;
    CGFloat space = 5;
    CGFloat height = width;
    CGFloat originX = (kScreenWidth - (width * 3 + 2 * space)) / 2;
    CGFloat originY = 100;
    for (int i = 0; i < 9; i ++) {
        
        int col = i % 3;
        int row = i / 3;
        
        CAShapeLayer *boxLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width, height) cornerRadius:width / 2];
        boxLayer.position = CGPointMake(originX + (width + space) * col, originY + (space + height) * row);
        boxLayer.path = path.CGPath;
        
        boxLayer.fillColor = [UIColor clearColor].CGColor;
        boxLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        boxLayer.borderWidth = 2.0;

        if (self.isVerify) {
            CAShapeLayer *smallLayer = self.smallBoxsArray[i];
            
            if ([smallLayer.name isEqualToString:SmallSelected]) {
                NSLog(@"i == %d", i);
                boxLayer.fillColor = [UIColor whiteColor].CGColor;
                boxLayer.strokeColor = [UIColor clearColor].CGColor;
                boxLayer.borderWidth = 0.0;
            }
        } else {
            boxLayer.name = SmallNoSelected;
            
        }
    
        [self.smallBoxsArray addObject: boxLayer];
        [self.layer addSublayer:boxLayer];
    }
}

- (void)addGesturesBox {
    
    CGFloat width = (kScreenWidth - Space * 4) / 3;
    CGFloat height = width;
    CGFloat originY = kScreenHeight - (height * 3 + 4 * Space);
    for (int i = 0; i < 9; i ++) {
        
        int col = i % 3;
        int row = i / 3;
        
        CAShapeLayer *boxLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width, height) cornerRadius:width / 2];
        boxLayer.position = CGPointMake(Space + (width + Space) * col, originY + (Space + height) * row);
        boxLayer.path = path.CGPath;
        boxLayer.fillColor = [UIColor clearColor].CGColor;
        boxLayer.strokeColor = [UIColor whiteColor].CGColor;
        boxLayer.borderWidth = 2.0;
        boxLayer.name = NoSelected;
        [self.layer addSublayer:boxLayer];
        
        [self.boxsArray addObject:boxLayer];
    }
}

#pragma mark - touch delegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    //绘制手势密码
    CGFloat width = (kScreenWidth - Space * 4) / 3;

    for (int i = 0; i < self.boxsArray.count; i ++) {
        
        CAShapeLayer *layer = self.boxsArray[i];
        CGRect layerFrame = CGRectMake(layer.position.x, layer.position.y, width, width);
        //CGRectContainsPoint 判断当前点是否在这个范围内
        if (CGRectContainsPoint(layerFrame, point) && [layer.name isEqualToString:NoSelected]) {
            
            [self drawDotWithRadius:width / RadiusMultiple center:layer.position];
            
            if (!self.isVerify) {
                CAShapeLayer *smallLayer = self.smallBoxsArray[i];
                smallLayer.name = SmallSelected;
            }

            layer.name = Selected;
            [self.selectedArray addObject:layer];
            self.lastPoint = CGPointMake(layer.position.x + width / 2, layer.position.y + width / 2);
            return;

        }
    }
    NSLog(@"begin = %ld", self.selectedArray.count);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];

//    self.currentPoint = point;
    //绘制密码
    CGFloat width = (kScreenWidth - Space * 4) / 3;


    for (int i = 0; i < self.boxsArray.count; i ++) {
        
        CAShapeLayer *layer = self.boxsArray[i];
        CGRect layerFrame = CGRectMake(layer.position.x, layer.position.y, width, width);
        //CGRectContainsPoint 判断当前点是否在这个范围内
        if (CGRectContainsPoint(layerFrame, point) && [layer.name isEqualToString:NoSelected]) {
            [self drawDotWithRadius:width / RadiusMultiple center:layer.position];
            if (!self.isVerify) {
                CAShapeLayer *smallLayer = self.smallBoxsArray[i];
                smallLayer.name = SmallSelected;
            }
            
            layer.name = Selected;
            [self.selectedArray addObject:layer];
            [self drawLineWidthStartPoint:self.lastPoint endPoint:CGPointMake(layer.position.x + width / 2, layer.position.y + width / 2) lineWidth:2];

            
            self.lastPoint = CGPointMake(layer.position.x + width / 2, layer.position.y + width / 2);
            return;
        }
    }
    NSLog(@"move == %ld", self.selectedArray.count);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.titleLabel.text = nil;
    
    if (!self.isVerify) {
        NSLog(@"end == %ld", self.selectedArray.count);
        if (self.selectedArray.count < BoxCount) {
            
            self.titleLabel.text = @"最少连接四个点，请重新输入";
            self.titleLabel.textColor = [UIColor redColor];
            [self shakeAnimationWithLayer:self.titleLabel.layer];
            
        } else {
            
            //绘制成功,清空layer
            self.titleLabel.text = @"再次绘制解锁图案";
            self.titleLabel.textColor = [UIColor whiteColor];
            [self.secretArray addObjectsFromArray:self.selectedArray];
            //若绘制成功，进入验证！
            self.isVerify = YES;
        }
    } else {
        //验证密码
        if (self.selectedArray.count != self.secretArray.count) {
            self.errorSecretCount += 1;
            self.titleLabel.text = @"与上次绘制不一致，请重新绘制";
            self.titleLabel.textColor = [UIColor redColor];
            [self shakeAnimationWithLayer:self.titleLabel.layer];
            [self restartView];
            return;
        }
        for (int i = 0; i < self.secretArray.count; i ++) {
            CAShapeLayer *selectLayer = self.selectedArray[i];
            CAShapeLayer *secretLayer = self.secretArray[i];
            if (selectLayer.position.x == secretLayer.position.x && selectLayer.position.y == secretLayer.position.y) {
                
                //若没个数都一样，则密码验证通过,将密码保存在数据库中
                //把坐标按顺序存到数据库中，调用
                if (i == self.secretArray.count - 1) {
                    
                    self.titleLabel.text = @"验证成功";
                    self.titleLabel.textColor = [UIColor whiteColor];
                    self.errorSecretCount = 0;
                }
            } else {
                
                //若其中有一个点坐标不一样，则密码验证失败
                self.errorSecretCount += 1;
                self.titleLabel.text = @"与上次绘制不一致，请重新绘制";
                self.titleLabel.textColor = [UIColor redColor];
                [self shakeAnimationWithLayer:self.titleLabel.layer];
                break;
            }
        }
    }
    [self restartView];
}

- (void)restartView {
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.selectedArray removeAllObjects];
    [self.boxsArray removeAllObjects];
    [self addSubview:self.titleLabel];
    [self addSubview:self.forgetSecretBtn];
    [self addSmallGestureBox];
    [self addGesturesBox];
    if (self.errorSecretCount == 2) {
        self.forgetSecretBtn.hidden = NO;
    }
}

#pragma mark - draw dot and line
- (void)drawDotWithRadius:(CGFloat)radius center:(CGPoint)center {
    
    self.dotLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(center.x + radius * (RadiusMultiple / 2 - 1), center.y + radius * (RadiusMultiple / 2 - 1), radius * 2, radius * 2) cornerRadius:radius];
    
    self.dotLayer.path = path.CGPath;
    self.dotLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:self.dotLayer];
}

- (void)drawLineWidthStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineWidth:(CGFloat)lineWidth {
    
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
//    if (self.selectedArray.count == 1) {
//        
//    } else {
//        [path addLineToPoint:CGPointMake(self.newDotPoint.x, self.newDotPoint.y)];
//    }
    [path moveToPoint:CGPointMake(startPoint.x, startPoint.y)];

    [path addLineToPoint:CGPointMake(endPoint.x, endPoint.y)];
//    [path closePath];
    lineLayer.path = path.CGPath;
    lineLayer.lineWidth = lineWidth;
    lineLayer.strokeColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8].CGColor;
    [self.layer addSublayer:lineLayer];
}

//- (void)drawRect:(CGRect)rect {
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    
//    [[UIColor blueColor] set];
//    [path moveToPoint:CGPointMake(self.lastPoint.x, self.lastPoint.y)];
//    [path addLineToPoint:CGPointMake(self.currentPoint.x, self.currentPoint.y)];
//    [path stroke];
//}

- (void)shakeAnimationWithLayer:(CALayer *)layer {
    
    //获取layer的position
    CGPoint position = layer.position;
    CGPoint leftPosition = CGPointMake(position.x - 5, position.y);
    CGPoint rightPosition = CGPointMake(position.x + 5, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:leftPosition];
    animation.toValue = [NSValue valueWithCGPoint:rightPosition];
    animation.repeatCount = ShakeCount;
    animation.duration = AnimationDuration;
    [layer addAnimation:animation forKey:nil];
}



@end
