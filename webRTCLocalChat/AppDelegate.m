//  Created by Alexander Skorulis on 12/03/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "AppDelegate.h"
#import "ChatWindowViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ChatWindowViewController* chat1 = [[ChatWindowViewController alloc] initWithName:@"chat1"];
    ChatWindowViewController* chat2 = [[ChatWindowViewController alloc] initWithName:@"chat2"];
    
    UITabBarController* tabController = [[UITabBarController alloc] init];
    tabController.viewControllers = @[chat1,chat2];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tabController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
