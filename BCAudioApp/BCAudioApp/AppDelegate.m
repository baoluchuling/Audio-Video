//
//  AppDelegate.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/5/17.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "AppDelegate.h"
#import "BCCatonMonitor.h"
#import "BCFPSMonitor.h"
#import "BCAudioPlayer.h"

NSString *const AppDelegateReceiveRemoteEventsNotification = @"AppDelegateReceiveRemoteEventsNotification";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [[BCCatonMonitor shareInstance] startMonitor];
//    [[BCFPSMonitor shareInstance] start];
    
    [BCAudioPlayer setAudioSession];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
//    [[BCCatonMonitor shareInstance] stopMonitor];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
//    [[BCCatonMonitor shareInstance] startMonitor];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {

}


- (BOOL)canBecomeFirstResponder
{
    return YES;

}
/// 锁屏页面的控制事件(必须在这里重写该方法，在播放页面重写不起作用)
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        // 发送通知给音频播放界面 进行某些处理
        [[NSNotificationCenter defaultCenter] postNotificationName:AppDelegateReceiveRemoteEventsNotification object:event];
    }
}


@end
