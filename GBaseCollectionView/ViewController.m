//
//  ViewController.m
//  GBaseCollectionView
//
//  Created by zlq002 on 2017/7/19.
//  Copyright © 2017年 zlq002. All rights reserved.
//

#import "ViewController.h"
#import "GBaseCollectionView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //调用示例
    GBaseCollectionView *banner2 = [[GBaseCollectionView alloc]initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 140)];
    
    banner2.isScorll = YES;
    banner2.images = @[
                       @"1",
                       @"2",
                       @"3"
                       ];
    banner2.returnValueBlock = ^(NSString *passedValue){
        
        NSLog(@"回调：%@",passedValue);
        
    };
    [self.view addSubview:banner2];
    
    GBaseCollectionView *banner = [[GBaseCollectionView alloc]initWithFrame:CGRectMake(0, 400, [UIScreen mainScreen].bounds.size.width, 140)];
    
    banner.isScorll = YES;
    banner.isNormal = YES;
    banner.images = @[
                       @"1",
                       @"2",
                       @"3"
                       ];
    banner2.returnValueBlock = ^(NSString *passedValue){
        
        NSLog(@"回调：%@",passedValue);
        
    };
    [self.view addSubview:banner];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
