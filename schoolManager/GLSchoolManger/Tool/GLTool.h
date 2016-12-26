//
//  GLTool.h
//  yunzan
//
//  Created by 温国力 on 16/12/23.
//  Copyright © 2016年 温国力. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifdef __OBJC__


///log打印
#ifdef DEBUG
///分别是方法地址，文件名，在文件的第几行，自定义输出内容
#define GLLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define GLLog( s, ... )
#endif

/***************** 工程用到的颜色 ****************/
/**
 搜索框 占位文本颜色
 */
#define gl_placeholderColor [UIColor colorWithWhite:244.0/255.0 alpha:1.0]

/**
 cell 搜索框背景颜色
 */
#define gl_searchBarBgColor [UIColor colorWithWhite:225.0/255.0 alpha:1.0]

/**
 cell 分组头部背景颜色
 */
#define gl_headerBgColor [UIColor colorWithRed:243.0/255.0 green:246.0/255.0 blue:248.0/255.0 alpha:1.0]

/**
 cell 分组展开字体颜色
 */
#define gl_headerExpandColor [UIColor colorWithRed:179.0/255.0 green:196.0/255.0 blue:205.0/255.0 alpha:1.0]

/**
 cell 分组头部字体颜色
 */
#define gl_headerTextColor [UIColor colorWithWhite:34.0/255.0 alpha:1.0]

/**
 cell 文本颜色
 */
#define gl_textColor [UIColor colorWithWhite:51.0/255.0 alpha:1.0]

/**
 分割线的颜色
 */
#define gl_lineColor [UIColor colorWithWhite:215.0/255.0 alpha:0.34]

/***************** 工程用到的字体大小 ****************/
/**
 搜索框 占位文本大小
 */
#define gl_placeholderFont [UIFont systemFontOfSize:12]

/**
 cell 分组头部字体大小
 */
#define gl_headerTextFont [UIFont systemFontOfSize:11]

/**
 cell 文本字体大小
 */
#define gl_textFont [UIFont systemFontOfSize:14]

/***************** 工程用到的一些常量 ****************/
/**
 cell 搜索框的高度 开发规范 44
 */
UIKIT_EXTERN CGFloat const gl_searchBarHeight;

/**
 cell 搜索框里边文本框高度  30
 */
UIKIT_EXTERN CGFloat const gl_searchHeight;

/**
 cell 分组头部高度  30
 */
UIKIT_EXTERN CGFloat const gl_headerHeight;

/**
 cell 分组头部文本高度 12
 */
UIKIT_EXTERN CGFloat const gl_headerTextHeight;

/**
 cell 分组头部文本距离左边的间距 10
 */
UIKIT_EXTERN CGFloat const gl_headerLeftMargin;

/**
 cell 分组头部文本距离底部的间距 3
 */
UIKIT_EXTERN CGFloat const gl_headerBottomMargin;

/**
 cell 内容高度 44
 */
UIKIT_EXTERN CGFloat const gl_cellHeight;

/**
 cell 内容距离旁边的间距 24
 */
UIKIT_EXTERN CGFloat const gl_cellMargin;


/***************** 工程用到的通知 ****************/

/**
 键盘收齐
 */
#define gl_textFieldResignFirstResponder @"gl_textFieldResignFirstResponder"
/**
 让搜索的tableView消失
 */
#define gl_noticeTableViewDismiss @"gl_noticeTableViewDismiss"

#endif
