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

#import "UIViewController+BCTransitionAnimation.h"

@interface BCPhotoBrowserViewController ()

@property (nonatomic, strong) NSArray<BCAsset *> *photoInfos;
@property (nonatomic, strong) UIImageView *imageview;

@end

@implementation BCPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageview = [[UIImageView alloc] init];
    self.imageview.contentMode = UIViewContentModeScaleAspectFill;
    self.imageview.clipsToBounds = YES;
    self.imageview.frame = CGRectMake(100, 100, 200, 200);
    [self.view addSubview:self.imageview];
    
    if (self.curIndex < self.photoInfos.count) {
        BCAsset *info = self.photoInfos[self.curIndex];
        [self.imageview bc_setImageAsset:info.asset];
    }
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:ges];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.transitioningDelegate = self;
}

- (void)tap:(UITapGestureRecognizer *)ges
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark -- transition
- (BOOL)needCustomTransition
{
    return YES;
}

- (UIView *)targetViewForViewController
{
    return self.imageview;
}

@end
