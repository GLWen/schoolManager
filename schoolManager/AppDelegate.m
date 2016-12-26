//
//  AppDelegate.m
//  schoolManager
//
//  Created by 温国力 on 16/12/26.
//  Copyright © 2016年 wenguoli. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    DemoViewController *demoVC = [[DemoViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:demoVC];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];

    
    
    [self globalSetting];
    return YES;
}
#pragma mark - 设置全局变量
- (void)globalSetting
{
    /// 导航栏两侧按钮颜色
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    // 设置状态栏顶部字体颜色
    [[UINavigationBar appearance] setBarStyle:(UIBarStyleBlack)];
    // 设置状态栏样式
    [UINavigationBar appearance].translucent = NO;
    // 先自定义view
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    /// 绘制渐变颜色
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:60.0/255.0 green:186.0/255.0 blue:249.0/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:28.0/255.0 green:140.0/255.0 blue:245.0/255.0 alpha:1.0].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(tmpView.frame), CGRectGetHeight(tmpView.frame));
    [tmpView.layer addSublayer:gradientLayer];
    /// 再转换成背景图
    UIGraphicsBeginImageContext(tmpView.bounds.size);
    [tmpView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *tmpImage = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
    [[UINavigationBar appearance] setBackgroundImage:tmpImage forBarMetrics:UIBarMetricsDefault];
    // 去除分割线
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    //设置全局导航栏标题颜色与字体大小
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
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
