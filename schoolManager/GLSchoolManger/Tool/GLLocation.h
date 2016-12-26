//
//  GLLocation.h
//  yunzan
//
//  Created by 温国力 on 16/12/24.
//  Copyright © 2016年 温国力. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^ResultBlock)(CLLocation *location,CLPlacemark *placemark,NSString *errorMessage);

@interface GLLocation : NSObject
/**
 *  实现单利
 *
 *  @return 当前类
 */
+ (instancetype)defaultWGLLocationTool;
/**
 *  直接获取当前位置信息, 然后通过代码块告诉外界
 *
 *  @param block 代码块
 */
- (void)getCurrentLocation:(ResultBlock)block;

@end
