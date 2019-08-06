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

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        [[NSNotificationCenter defaultCenter] postNotificationName:AppDelegateReceiveRemoteEventsNotification object:event];
    }
}


@end
