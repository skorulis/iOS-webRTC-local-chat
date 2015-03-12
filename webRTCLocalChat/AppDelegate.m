//  Created by Alexander Skorulis on 12/03/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "AppDelegate.h"
#import "ChatWindowViewController.h"

@interface AppDelegate () {
    RTCService* _rtcService;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _rtcService = [[RTCService alloc] init];
    
    ChatWindowViewController* chat1 = [[ChatWindowViewController alloc] initWithService:_rtcService name:@"chat1"];
    ChatWindowViewController* chat2 = [[ChatWindowViewController alloc] initWithService:_rtcService name:@"chat2"];
    
    [chat1 view];
    [chat2 view];
    
    [chat1.peerConnection connectTo:chat2.peerConnection];
    
    UITabBarController* tabController = [[UITabBarController alloc] init];
    tabController.viewControllers = @[chat1,chat2];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tabController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
