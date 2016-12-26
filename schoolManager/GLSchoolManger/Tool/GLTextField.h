//
//  GLTextField.h
//  yunzan
//
//  Created by 温国力 on 16/12/23.
//  Copyright © 2016年 温国力. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLTextFieldDelegate <NSObject>

@optional

/**
 文本框即将编辑的时候
 */
- (void)gl_textFieldDidBeginEditing;

/**
 点击键盘return按钮
 */
- (void)gl_clickKeyboardReturnButtonGetValue:(NSString *)text;

/**
 当输入值结束时候，获得输入的数据 （该代理方法用的比较少）

 @param text 输入的文本
 */
- (void)gl_whenInputTextFieldEndValue:(NSString *)text;

/**
 当输入值发生改变的时候立即调用   （该代理方法用的比较多⭐️⭐️⭐️）

 @param text 输入的文本
 */
- (void)gl_whenInputTextFieldValueChange:(NSString *)text;

/**
 输入的值需要修改的或者替换的时候，调用该方法

 @param textField 当前的textField
 @param range     文本需要改变的范围
 @param string    需要替换的文本
 */
- (void)gl_whenInputTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;


@end

@interface GLTextField : UITextField

/**
 代理方法
 */
@property (nonatomic,weak) id<GLTextFieldDelegate> glDelegate;

/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
/**
 *  限制文字输入个数
 */
@property (nonatomic)  int  limitCount;
/**
 *  抓取文本框的数字
 */
@property(nonatomic,strong) UITextField *textFiled;

@end
