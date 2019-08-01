//
//  BCPhotoBrowserViewController.h
//  BCAudioApp
//
//  Created by boluchuling on 2019/7/22.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BCPhotoBrowserViewDataSource;

@interface BCPhotoBrowserViewController : UIViewController

@property (nonatomic, weak) BCPhotoBrowserViewDataSource *dataSource;
@property (nonatomic, strong) NSArray *(^browserAssets)(void);
@property (nonatomic, assign) NSInteger curIndex;

@end


@protocol BCPhotoBrowserViewDataSource <NSObject>

- (NSArray *)assetsInBrowserWith:(BCPhotoBrowserViewController *)viewController;

@end
