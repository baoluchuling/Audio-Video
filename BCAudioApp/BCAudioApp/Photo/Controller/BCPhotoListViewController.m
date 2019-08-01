//
//  BCPhotoListViewController.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/7/9.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCPhotoListViewController.h"
#import "BCGridViewCell.h"

#import "BCAsset.h"
#import "BCAssetManager.h"
#import "BCPhotoAuthorization.h"

#import "BCPhotoBrowserViewController.h"

static NSString *ReuseIdentifierForGridViewCell = @"BCGridViewCell";

@interface BCPhotoListViewController () <UICollectionViewDelegate, UICollectionViewDataSource, BCGridViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<BCAsset *> *photoInfos;

@property (nonatomic, strong) NSMutableArray *selectIndexs;

@end

@implementation BCPhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoInfos = [NSMutableArray array];
    self.selectIndexs = [NSMutableArray array];
    
    [self constructView];
    [self prepareData];
}

- (void)constructView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightAction:)];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(100, 107);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[BCGridViewCell class] forCellWithReuseIdentifier:ReuseIdentifierForGridViewCell];
}

- (void)prepareData
{
    [BCPhotoAuthorization authorizationWithCompleteHandler:^{
        [[BCAssetManager defaultManager] fetchAllPhotoAssetHandler:^(NSArray *array) {
            [self.photoInfos addObjectsFromArray:array];
            [self.collectionView reloadData];
        }];
    }];
}

- (void)rightAction:(id)sender
{
    NSMutableArray *selectPhotos = [NSMutableArray arrayWithCapacity:self.selectIndexs.count];
    [self.selectIndexs enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        [selectPhotos addObject:self.photoInfos[[obj integerValue]]];
    }];
    
    // 回调
    if (self.selectCompleteHandler) {
        self.selectCompleteHandler(selectPhotos);
    }
    
    if (self.presentedViewController == nil) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark delegate
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BCGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifierForGridViewCell forIndexPath:indexPath];
    cell.delegate = self;
    cell.index = indexPath.item;
    [cell updateImage:self.photoInfos[indexPath.item]];
    cell.isSelect = [self.selectIndexs containsObject:@(indexPath.item)];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoInfos.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BCGridViewCell *cell = (BCGridViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    if ([self.selectIndexs containsObject:@(indexPath.item)]) {
        cell.isSelect = NO;
        [self.selectIndexs removeObject:@(indexPath.item)];
    } else {
        if (self.limitCount > 0 && self.selectIndexs.count == self.limitCount) {
            NSLog(@"数量已达限制。");
            return;
        }
        
        cell.isSelect = YES;
        [self.selectIndexs addObject:@(indexPath.item)];
    }
}

- (void)didSelectPreviewButton:(NSInteger)index
{
    BCPhotoBrowserViewController *VC = [[BCPhotoBrowserViewController alloc] init];
    VC.curIndex = index;
    
    __weak typeof(self) weakSelf = self;
    VC.browserAssets = ^NSArray *{
        return weakSelf.photoInfos;
    };
    
    [self.navigationController pushViewController:VC animated:YES];
}

@end
