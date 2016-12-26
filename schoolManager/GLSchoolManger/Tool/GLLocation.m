//
//  GLLocation.m
//  yunzan
//
//  Created by 温国力 on 16/12/24.
//  Copyright © 2016年 温国力. All rights reserved.
//
#ifdef DEBUG
#define WGLLog(...) NSLog(__VA_ARGS__)
#else
#define WGLLog(...)
#endif
#define WGLLogFunc WGLLog(@"%s", __func__);

#import <UIKit/UIKit.h>

#import "GLLocation.h"

@interface GLLocation ()<CLLocationManagerDelegate>


/** 记录要执行的代码块 */
@property (nonatomic, copy) ResultBlock block;

/** 位置管理者 */
@property (nonatomic, strong) CLLocationManager *locationM;

/** 地理编码管理器 */
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation GLLocation
#define isIOS(version) ([[UIDevice currentDevice].systemVersion floatValue] >= version)
+ (instancetype)defaultWGLLocationTool//单例模式
{
    static GLLocation *locationTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationTool = [[self alloc] init];
    });
    return locationTool;
}
#pragma mark - 懒加载
- (CLLocationManager *)locationM
{
    if (!_locationM) {
        _locationM = [[CLLocationManager alloc]init];
        _locationM.delegate = self;
        if (isIOS(8.0)) {
            
            // 要在此处, 请求授权, 但是请求哪个权限, 没法确定, 靠其他开发者确定;
            
            // 1. 获取info.plist 文件内容
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            
            //            NSLog(@"%@", infoDic);
            
            // 2. 获取其他开发人员, 填写的key
            NSString *always = infoDic[@"NSLocationAlwaysUsageDescription"];
            
            NSString *whenInUse = infoDic[@"NSLocationWhenInUseUsageDescription"];
            
            
            if ([always length] > 0)
            {
                [_locationM requestAlwaysAuthorization];
            }
            else if ([whenInUse length] > 0)
            {
                [_locationM requestWhenInUseAuthorization];
                // 在前台定位授权状态下, 必须勾选后台模式location udpates才能获取用户位置信息
                NSArray *services = infoDic[@"UIBackgroundModes"];
                
                if (![services containsObject:@"location"]) {
                    WGLLog(@"提示: 当前状态是前台定位授权状态, 如果想要在后台获取用户位置信息, 必须勾选后台模式 location updates");
                }
                else
                {
                    if (isIOS(9.0)) {
                        _locationM.allowsBackgroundLocationUpdates = YES;
                    }
                }
            }else
            {
                WGLLog(@"错误：如果在iOS8.0之后定位, 必须在info.plist, 配置NSLocationWhenInUseUsageDescription 或者 NSLocationAlwaysUsageDescription");
            }
        }
    }
    return _locationM;
}
#pragma mark - 地里编码管理器
- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
#pragma mark - 实现位置定位方法
- (void)getCurrentLocation:(ResultBlock)block
{
    // 先记录代码块, 然后在合适的位置调用这个代码块
    self.block = block;
    // 在此处, 并不能直接获取当前的用户位置, 还有地标
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationM startUpdatingLocation];
    }
    else
    {
        self.block(nil, nil, @"定位服务没有开启");
    }
}
#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray <CLLocation *>*)locations
{
    CLLocation *location = [locations lastObject];
    if (location.horizontalAccuracy < 0) {
        return;
    }
    // 在这里, 可以获取到位置信息
    // 在这里, 还没发, 获取到地标对象, 所以, 在此处, 要进一步进行反地理编码
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil) {
            // 获取地标对象
            CLPlacemark *pl = [placemarks firstObject];
            // 在此处, 最适合, 执行存储的代码块
            self.block(location, pl, nil);
        }
        else
        {
            self.block(location, nil, error.localizedDescription);
        }
    }];
    // 关闭定位服务
    [manager stopUpdatingLocation];
    
}
#pragma mark - 定位失败时调用
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    WGLLog(@"定位失败");
}
/**
 *  当前定位授权状态发生改变时调用
 *
 *  @param manager 位置管理者
 *  @param status  状态
 */
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            WGLLog(@"用户未决定");
            break;
        }
        case kCLAuthorizationStatusDenied:
        {
            
            // 判断当前设备是否支持定位, 定位服务是否开启
            if([CLLocationManager locationServicesEnabled])
            {
                WGLLog(@"真正被拒绝");
            }
            else
            {
                WGLLog(@"定位服务被关闭");
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL: url];
                }
            }
            break;
        }
            // 系统预留字段
        case kCLAuthorizationStatusRestricted:
        {
            WGLLog(@"受限制");
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            WGLLog(@"前后台定位授权");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            WGLLog(@"前台定位授权");
            break;
        }
        default:
            break;
    }
}


@end
