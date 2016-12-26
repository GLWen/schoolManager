//
//  GLSchoolSearchBar.h
//  yunzan
//
//  Created by 温国力 on 16/12/23.
//  Copyright © 2016年 温国力. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLSchoolSearchBarDelegate <NSObject>

@optional

/**
 当开始编辑的时候触发
 */
- (void)gl_whenTextFieldDidBeginEditing;
/**
 需要检索的文字
 */
- (void)gl_searchText:(NSString *)text;

@end

@interface GLSchoolSearchBar : UIView

/**
 搜索框代理方法
 */
@property (nonatomic,weak) id<GLSchoolSearchBarDelegate> searchDelegate;

@end
