//
//  GLSchoolSearchView.h
//  yunzan
//
//  Created by 温国力 on 16/12/24.
//  Copyright © 2016年 温国力. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLSchoolSearchViewDelegate <NSObject>


/**
 选中搜索到的学校       必须实现的方法
 */
- (void)selectSchool:(NSString *)text;

@end

@interface GLSchoolSearchView : UIView

/**
 搜索代理
 */
@property (nonatomic,weak) id<GLSchoolSearchViewDelegate> searchDelegate;

/** 
 接收搜索结果的数组
 */
@property (nonatomic, strong) NSArray *resultArray;


@end
