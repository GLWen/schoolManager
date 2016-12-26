//
//  GLSchoolViewController.h
//  yunzan
//
//  Created by 温国力 on 16/12/25.
//  Copyright © 2016年 云赞校园. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GLSchoolViewController;
@protocol GLSchoolViewControllerDelegate <NSObject>

/**
 将省份城市学校值回调到上个界面  该代理必须实现（⭐️⭐️⭐️）
 
 */
- (void)selectSchoolTextPopViewController:(GLSchoolViewController *)controller didFinishUserProvence:(NSString *)userProvence userCity:(NSString *)userCity schoolText:(NSString *)text;

@end

@interface GLSchoolViewController : UIViewController

/** 
 传入稍后需要pop回第几层控制器 默认pop到最顶层
 */
@property (nonatomic, assign) NSInteger index;

/**
 遵循该代理 ⭐️⭐️⭐️
 */
@property (nonatomic,weak) id<GLSchoolViewControllerDelegate> schoolDelegate;

@end
