//
//  ViewController.m
//  TestGestureLock
//  手势密码锁
//  Created by 杰铭 on 17/1/22.
//  Copyright © 2017年 杰铭. All rights reserved.
//

#import "ViewController.h"
#import "LockView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    LockView *lockView = [[LockView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:lockView];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
