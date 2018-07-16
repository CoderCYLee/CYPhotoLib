//
//  CYPhotoPicker.m
//  MkmyIOS
//
//  Created by Cyrill on 2016/10/11.
//  Copyright © 2016年 Cyrill. All rights reserved.
//

#import "CYPhotoPicker.h"
#import "CYPhotoHeader.h"
#import "CYAlbum.h"
#import "CYPhotoNavigationViewController.h"
#import "CYPhotoCommon.h"
#import "CYPhotoAlbumsController.h"
#import "CYPhotoAssetsController.h"
#import "CYPhotoCenter.h"
#import "CYPhotoManager.h"
#import "CYAsset.h"

#import "CYPhotoConfig.h"

@interface CYPhotoPicker()

//显示选择器的控制器
@property (nonatomic, weak) UIViewController * sender;

@end

@implementation CYPhotoPicker 

#pragma mark - public
- (void)showInSender:(__kindof UIViewController *)sender handle:(void(^)(NSArray<UIImage *> *photos, NSArray<CYAsset *> *assets))handle {
    [self showInSender:sender config:[self setupConfig] handle:handle];
}

- (void)showInSender:(__kindof UIViewController *)sender config:(CYPhotoConfig *)config handle:(void(^)(NSArray<UIImage *> *photos, NSArray<CYAsset *> *assets))handle {
    [CYPhotoCenter shareCenter].maxSelectedCount = self.maxSelectedCount;
    [CYPhotoCenter shareCenter].minSelectedCount = self.minSelectedCount;
    
    
    [CYPhotoCenter shareCenter].config = config;
    
    
    self.sender = sender;
    
    [[CYPhotoCenter shareCenter] requestPhotoLibaryAuthorizationValidAuthorized:^{
        
        // 相册列表
        CYPhotoAlbumsController * albumsList = [[CYPhotoAlbumsController alloc] init];
        albumsList.isSingleSel = CYPhotoCenter.config.isSinglePick;
        albumsList.sortByModificationDate = self.sortByModificationDate;
        albumsList.ascending = self.ascending;
        albumsList.columnNumber = self.columnNumber;
        
        CYPhotoNavigationViewController *nav = [[CYPhotoNavigationViewController alloc] initWithRootViewController:albumsList];
        nav.navigationBar.barTintColor = CYPHOTOLIB_NAV_BAR_COLOR;
        [nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor blackColor]}];
        nav.navigationBar.tintColor = [UIColor blackColor];
        nav.navigationItem.backBarButtonItem.title = @"照片";
        
        if (CYPhotoCenter.config.isPushToCameraRoll) {
            // 所有照片
            CYPhotoAssetsController *browser = [[CYPhotoAssetsController alloc] init];
            browser.isSingleSel = CYPhotoCenter.config.isSinglePick;
            browser.sortByModificationDate = self.sortByModificationDate;
            browser.ascending = self.ascending;
            browser.columnNumber = self.columnNumber;
            [albumsList.navigationController pushViewController:browser animated:NO];
        }
        
        [self.sender presentViewController:nav animated:YES completion:nil];
    } denied:^{
        [self deined];
    } restricted:^{
        [self restricted];
    } elseBlock:^{
        
    }];
    
    [[CYPhotoCenter shareCenter] setHandle:^(NSArray<UIImage *> * photos) {
        
        // FIX： 如果是单张 清除信息，下次进来就没有了
        if (CYPhotoCenter.config.isSinglePick) {
            [self clearInfo];
        }
        
        NSMutableArray *assetArray = [CYPhotoCenter shareCenter].selectedPhotos;
        
        handle(photos, assetArray);
    }];
}

- (void)clearInfo {
    [[CYPhotoCenter shareCenter] clearInfos];
}

#pragma mark - private
- (CYPhotoConfig *)setupConfig {
    CYPhotoConfig *config = [[CYPhotoConfig alloc] init];
    config.allowPickingVideo = self.isAllowPickingVideo;
    config.allowPickingImage = self.isAllowPickingImage;
    config.pushToCameraRoll = self.isPushToCameraRoll;
    config.singlePick = self.isSinglePick;
    config.sortByModificationDate = self.isSortByModificationDate;
    config.ascending = self.isAscending;
    config.defaultImageWidth = self.defaultImageWidth;
    config.maxSelectedCount = self.maxSelectedCount;
    config.minSelectedCount = self.minSelectedCount;
    config.edgeInset = self.edgeInset;
    config.columnNumber = self.columnNumber;
    config.minimumLineSpacing = self.minimumLineSpacing;
    config.minimumInteritemSpacing = self.minimumInteritemSpacing;
    
    return config;
}

- (void)deined {
    // 无权限
    [self setAlertControllerWithTitle:CY_DeinedPhotoLibirayText message:CY_GotoPhotoLibararySettingText];
    return;
}

- (void)restricted {
    // 家长模式
    [self setAlertControllerWithTitle:CY_RestrictedPhotoLibirayText message:CY_GotoPhotoLibararySettingText];
    return;
}

- (void)setAlertControllerWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (@available(iOS 10, *)) {
            // 跳转到 “设置\"-\"隐私\"-\"照片”
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:CY_GotoPhotoLibrarySettingPath] options:[NSDictionary dictionary] completionHandler:^(BOOL success) {
                NSLog(@"%@", success ? @"success" : @"failure");
            }];
        } else {
            // 跳转到 “设置\"-\"隐私\"-\"照片”
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:CY_GotoPhotoLibrarySettingPath]];
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    [self.sender presentViewController:alert animated:YES completion:nil];
}

@end
