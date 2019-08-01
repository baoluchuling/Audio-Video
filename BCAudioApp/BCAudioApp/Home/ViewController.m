//
//  ViewController.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/5/17.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "ViewController.h"
#import "BCAudioListCell.h"
#import "BCAudioInfo.h"
#import "BCAudioManager.h"
#import "BCImageOptions.h"

#import "UIImageView+NetImg.h"

#import "BCAudioPlayerViewController.h"
#import "BCPhotoListViewController.h"

@interface ViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (nonatomic, strong) NSMutableArray *musicArray;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.hidden = YES;
    
    self.musicArray = [NSMutableArray array];
}

- (IBAction)leftAction:(id)sender {
    BCPhotoListViewController *VC = [[BCPhotoListViewController alloc] init];
    VC.limitCount = 9;
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)rightAction:(id)sender {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *pathArray = [BCAudioManager fetchBundleAudioInfoWithType:@"mp3"];
        
        [BCAudioInfo batchObtainAudioInfoWithPaths:pathArray complete:^(NSArray *array) {
            [self.musicArray addObjectsFromArray:array];
            self.emptyView.hidden = YES;
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }];
        
    });
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BCAudioListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BCAudioListCell" forIndexPath:indexPath];
    
    BCAudioInfo *info = self.musicArray[indexPath.row];
    cell.titleLabel.text = info.title;
    
    BCImageOptions *options = [[BCImageOptions alloc] init];
    options.cornerRadius = @[@5];
    
    [cell.coverImage bc_setImageData:info.artwork options:options];
     
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musicArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BCAudioPlayerViewController *VC = [[BCAudioPlayerViewController alloc] init];
    VC.info = self.musicArray[indexPath.row];
//    VC.info.filePath = @"http://www.170mv.com/kw/sd-sycdn.kuwo.cn/resource/n2/43/36/2800514873.mp3";
    [self.navigationController pushViewController:VC animated:YES];
}

@end
