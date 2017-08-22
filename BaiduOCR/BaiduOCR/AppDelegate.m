//
//  AppDelegate.m
//  BaiduOCR
//
//  Created by 牛新怀 on 2017/8/10.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end
static NSString * const BaiduAppID           = @"9991413";
static NSString * const BaiduApiKey          = @"E2jIt1TZqt1EVYGVdH3L1Tb3";
static NSString * const BaiduSecretKey       = @"kIf9V9BktenQCFG8EpmlWChvlTz6GKbl";
static NSString * const BaiduAccess_tokenUrl = @"https://aip.baidubce.com/oauth/2.0/token";
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    ViewController * vc = [[ViewController alloc]init];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self getBaiduAIAccessToken];
    return YES;
}
#pragma mark - 获取百度AIAccess Token。有效期为30天
- (void)getBaiduAIAccessToken{
    /*
     请求URL数据格式
     
     向授权服务地址https://aip.baidubce.com/oauth/2.0/token发送请求（推荐使用POST），并在URL中带上以下参数：
     
     grant_type： 必须参数，固定为client_credentials；
     client_id： 必须参数，应用的API Key；
     client_secret： 必须参数，应用的Secret Key；
     
     https://aip.baidubce.com/oauth/2.0/token?
     grant_type=client_credentials&
     client_id=Va5yQRHlA4Fq4eR3LT0vuXV4&
     client_secret= 0rDSjzQ20XUj5itV7WRtznPQSzr5pVw2&
     
     
     */
    //    [[AipOcrService shardService] authWithAK:@"sLdWP9rGQ7iu63Pi4hvUP3qw" andSK:@"WF2fWKb8lQ2bfGB5MAAsixIGXCUzWipX"];
    
    
    
    NSMutableDictionary * dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setObject:@"client_credentials" forKey:@"grant_type"];
    [dictionary setObject:BaiduApiKey forKey:@"client_id"];
    [dictionary setObject:BaiduSecretKey forKey:@"client_secret"];
    
    
    [NetWorkTool postNetWorkWithURL:BaiduAccess_tokenUrl paramaters:dictionary success:^(id object) {
        NSLog(@"%@",object);
        NSString * access_token = [object objectForKey:@"access_token"];
        NSString * expiresHaveTime = [NSString stringWithFormat:@"%@",[object objectForKey:@"expires_in"]];
        [[NSUserDefaults standardUserDefaults] setObject:access_token forKey:AccessTokenKey];
        [[NSUserDefaults standardUserDefaults] setObject:expiresHaveTime forKey:TokenValidity];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSInteger validityTime = [expiresHaveTime integerValue];
        if (validityTime <=0 || !validityTime) {
            UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"Warring" message:@"您使用的百度AI识别功能Access_Token已失效，请重新获取" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
                    
                    
                }];
                
            }];
            
            [alertC addAction:confirmAction];
            [self.window.rootViewController presentViewController:alertC animated:YES completion:nil];
            
            
        }
        
    } failure:^(id failure) {
        
        NSLog(@"%@",failure);
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
