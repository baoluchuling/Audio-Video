//
//  BCAudioPlayerViewController.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/5/17.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCAudioPlayerViewController.h"
#import "BCAudioPlayer.h"
#import "BCAudioInfo.h"
#import "BCSlider.h"
#import "BCCircleDiscView.h"
#import "BCControlView.h"

#import "BCAudioRemoteCenter.h"

#import "Masonry.h"

@interface BCAudioPlayerViewController ()

@property (nonatomic, strong) BCSlider *sliderView;
@property (nonatomic, strong) UITableView *lyricsView;
@property (nonatomic, strong) BCCircleDiscView *discView;
@property (nonatomic, strong) BCControlView *controlView;

@end

@implementation BCAudioPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = self.info.title;
    
    [self constructSliderView];
    
    [self constructMiddleView];
    
    [self constructBottomView];

    [self remoteControlView];
    
    [[BCAudioPlayer shareInstance] playWithFile:self.info.filePath];

    [[BCAudioRemoteCenter defaultCenter] setAudioRemotePlayingInfo:self.info.remoteInfo];
}

- (void)constructSliderView {
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(108);
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.height.mas_equalTo(50);
    }];
    
    [self changeSliderShow:0.5];
}

- (void)constructMiddleView
{
    [self.discView setImageData:self.info.artwork];
    [self.discView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sliderView.mas_bottom).with.offset(40);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(300);
    }];
}

- (void)constructBottomView
{
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
}

- (void)remoteControlView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDelegateReceiveRemoteEventsNotification:) name:@"AppDelegateReceiveRemoteEventsNotification" object:nil];
}

#pragma mark - event
- (void)playOrPauseAudio
{
    [self.discView refreshAnimation];
    [[BCAudioPlayer shareInstance] changePlayStatus];
}

- (void)appDelegateReceiveRemoteEventsNotification:(NSNotification *)notify
{
    UIEvent *event = notify.object;
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay: // 播放
            [self.discView start];
            break;
        case UIEventSubtypeRemoteControlPause:
        case UIEventSubtypeRemoteControlStop: // 暂停
            [self.discView stop];
            break;
        default:
            break;
    }
}

- (void)sliderValueChange:(UISlider *)sender {
    [self changeSliderShow:sender.value];
}

- (void)changeSliderShow:(float)value
{
    [[BCAudioPlayer shareInstance] setVolume:value];
    
    self.sliderView.minimumValueImage = [UIImage imageNamed:(value <= 0) ? @"volume_mute" : @"volume_unmute"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - setter & getter
- (UISlider *)sliderView
{
    if (!_sliderView) {
        _sliderView = [[BCSlider alloc] initWithFrame:CGRectMake(40, 98, 500, 50)];
        _sliderView.continuous = YES;
        _sliderView.minimumValue = 0;
        _sliderView.maximumValue = 2;
        _sliderView.value = 0.5;
        [self.view addSubview:_sliderView];
        
        [_sliderView addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _sliderView;
}

- (UIView *)discView
{
    if (!_discView) {
        _discView = [[BCCircleDiscView alloc] init];
        _discView.backgroundColor = [UIColor whiteColor];
        _discView.cornerRadius = 150;
        [self.view addSubview:_discView];
    }
    
    return _discView;
}

- (BCControlView *)controlView
{
    if (!_controlView) {
        _controlView = [[BCControlView alloc] init];
        _controlView.backgroundColor = [UIColor greenColor];
        [self.view addSubview:_controlView];
    }
    
    return _controlView;
}
@end
