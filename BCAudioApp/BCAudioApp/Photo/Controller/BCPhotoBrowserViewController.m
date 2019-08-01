//
//  BCPhotoBrowserViewController.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/7/22.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCPhotoBrowserViewController.h"
#import "BCAsset.h"
#import "UIImageView+Photo.h"

@interface BCPhotoBrowserViewController ()

@property (nonatomic, strong) NSArray<BCAsset *> *photoInfos;

@end

@implementation BCPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.frame = CGRectMake(100, 100, 200, 200);
    [self.view addSubview:imageview];
    
    if (self.curIndex < self.photoInfos.count) {
        BCAsset *info = self.photoInfos[self.curIndex];
        [imageview bc_setImageAsset:info.asset];
    }
}

#pragma mark -- getter & setter
- (NSArray<BCAsset *> *)photoInfos
{
    if (!_photoInfos) {
        if (self.browserAssets) {
            _photoInfos = self.browserAssets();
        } else {
            _photoInfos = [NSArray array];
        }
    }
    
    return _photoInfos;
}

@end
