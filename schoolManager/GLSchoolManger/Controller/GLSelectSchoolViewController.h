//
//  GLSelectSchoolViewController.h
//  yunzan
//
//  Created by 温国力 on 16/12/25.
//  Copyright © 2016年 温国力. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLSelectSchoolViewController;

@protocol GLSelectSchoolViewControllerDelegate <NSObject>

/**
 将值回调到上个界面  该代理必须实现（⭐️⭐️⭐️）
 
 */
- (void)selectSchoolTextPopViewController:(GLSelectSchoolViewController *)controller didFinishSchoolText:(NSString *)text;;

@end


@interface GLSelectSchoolViewController : UIViewController

/**
 遵循该代理 ⭐️⭐️⭐️
 */
@property (nonatomic,weak) id<GLSelectSchoolViewControllerDelegate> schoolDelegate;

/**
 上个界面传入稍后需要pop回第几层控制器 默认pop到最顶层
 */
@property (nonatomic, assign) NSInteger index;

/** 
 上个界面传入的省份
 */
@property(strong,nonatomic) NSString *province;

/**
 点击省份对应学校数组的索引
 */
@property (nonatomic,assign) NSInteger index1;

@end
