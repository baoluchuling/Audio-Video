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


/*
 launchOptions:
 
    UIApplicationLaunchOptionsAnnotationKey             来源APP参数
 
    UIApplicationLaunchOptionsBluetoothCentralsKey      该应用程序已重新启动以处理与蓝牙相关的事件。
 
    UIApplicationLaunchOptionsBluetoothPeripheralsKey   应用程序应继续与其蓝牙外围设备对象关联的操作。

    UIApplicationLaunchOptionsCloudKitShareMetadataKey  应用程序收到了CloudKit共享邀请。
 
    UIApplicationLaunchOptionsLocationKey               应用程序启动以处理传入的位置事件。
 
    UIApplicationLaunchOptionsNewsstandDownloadsKey      已启动应用程序以处理新下载的报亭资产。
 
    UIApplicationLaunchOptionsRemoteNotificationKey      应用程序处理远程通知。
 
    UIApplicationLaunchOptionsShortcutItemKey            应用程序是为响应用户选择主屏幕快速操作而启动的。
 
    UIApplicationLaunchOptionsSourceApplicationKey       另一个应用程序请求启动您的应用程序。
 
    UIApplicationLaunchOptionsURLKey                     应用程序已启动，以便可以打开指定的URL。
 
    UIApplicationLaunchOptionsUserActivityDictionaryKey  指示与用户想要继续的活动相关联的数据。
 
    UIApplicationLaunchOptionsUserActivityTypeKey        指示用户想要继续的用户活动的类型。
 
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [[BCCatonMonitor shareInstance] startMonitor];
//    [[BCFPSMonitor shareInstance] start];
    
    [BCAudioPlayer setAudioSession];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"1");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
//    [[BCCatonMonitor shareInstance] stopMonitor];
    
    NSLog(@"2");
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"3");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
//    [[BCCatonMonitor shareInstance] startMonitor];
    NSLog(@"4");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"5");
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
//    [[BCImageCache defaultCache] clearAllCaches];
}


- (BOOL)canBecomeFirstResponder
{
    return YES;

}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        [[NSNotificationCenter defaultCenter] postNotificationName:AppDelegateReceiveRemoteEventsNotification object:event];
    }
}


@end
