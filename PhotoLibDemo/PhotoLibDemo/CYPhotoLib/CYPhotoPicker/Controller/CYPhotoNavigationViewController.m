//
//  CYPhotoNavigationViewController.m
//  MkmyIOS
//
//  Created by Cyrill on 2016/11/10.
//  Copyright © 2016年 Cyrill. All rights reserved.
//

#import "CYPhotoNavigationViewController.h"

@interface CYPhotoNavigationViewController ()

@end

@implementation CYPhotoNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 横屏
- (BOOL)shouldAutorotate
{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}

@end
