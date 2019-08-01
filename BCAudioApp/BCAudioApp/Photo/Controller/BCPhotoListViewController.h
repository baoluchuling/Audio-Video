//
//  BCPhotoListViewController.h
//  BCAudioApp
//
//  Created by boluchuling on 2019/7/9.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCPhotoListViewController : UIViewController

@property (nonatomic, strong) void(^selectCompleteHandler)(NSArray *);
@property (nonatomic, assign) NSInteger limitCount;

@end
