//
//  GLSchoolSearchBar.m
//  yunzan
//
//  Created by 温国力 on 16/12/23.
//  Copyright © 2016年 温国力. All rights reserved.
//

#import "GLSchoolSearchBar.h"
#import "GLTool.h"
#import "GLTextField.h"

@interface GLSchoolSearchBar()<GLTextFieldDelegate>

/**
 背景白色的框
 */
@property (nonatomic,weak) UIView *whiteView;

/**
 占位的文本
 */
@property (nonatomic,weak) UILabel *placeholderLabel;

/**
 搜索文本框
 */
@property (nonatomic,weak) GLTextField *searchText;

/**
 取消按钮
 */
@property (nonatomic,weak) UIButton *cancelBtn;

@end

@implementation GLSchoolSearchBar

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = gl_searchBarBgColor;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, gl_searchBarHeight);
        
        /// 自定义搜索框背景白色
        UIView *whiteView = [[UIView alloc] init];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.frame = CGRectMake(gl_cellMargin, (gl_searchBarHeight - gl_searchHeight)*0.5, self.bounds.size.width - 2*gl_cellMargin - 20, gl_searchHeight);
        /// 绘制圆角
        whiteView.layer.cornerRadius = 3;
        whiteView.layer.masksToBounds = YES;
        [self addSubview:whiteView];
        self.whiteView = whiteView;
        
        /// 文本框
        GLTextField *searchText = [[GLTextField alloc]init];
        searchText.glDelegate = self;
        searchText.limitCount = 20;                 /// 这边限制输入20个字以内
        searchText.placeholder = @"请输入学校全称或者简称";
        searchText.textAlignment = NSTextAlignmentLeft;
        searchText.keyboardType = UIKeyboardTypeDefault;
        searchText.returnKeyType = UIReturnKeySearch;
        [whiteView addSubview:searchText];
        self.searchText = searchText;
        
        /// 取消按钮
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [cancelBtn addTarget:self action:@selector(clickCancelButton) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:cancelBtn];
        self.cancelBtn = cancelBtn;
        
    
        //获取通知中心单例对象
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
        [center addObserver:self selector:@selector(noticeTextFieldResignFirstResponder) name:gl_textFieldResignFirstResponder object:nil];

    }
    return self;
}

#pragma mark - 界面布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat whiteWidth = self.whiteView.bounds.size.width;
    CGFloat whiteHeight =self.whiteView.bounds.size.height;
    
    self.searchText.frame = CGRectMake(whiteWidth*0.25, 0, whiteWidth*0.75,whiteHeight);
    self.cancelBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 40, 0, 40, self.bounds.size.height);
}
#pragma mark - GLTextFieldDelegate
- (void)gl_textFieldDidBeginEditing
{
    /// 当文本触发的时候调用
    if ([self.searchDelegate respondsToSelector:@selector(gl_whenTextFieldDidBeginEditing)]) {
        [self.searchDelegate gl_whenTextFieldDidBeginEditing];
    }
    
    [UIView animateWithDuration:0.75 animations:^{
        self.searchText.frame = CGRectMake(5, 0, self.whiteView.bounds.size.width - 10 , self.whiteView.bounds.size.height);
    }];
}
- (void)gl_whenInputTextFieldEndValue:(NSString *)text
{
    if (text.length > 0 ) {
       
    }else {
        [UIView animateWithDuration:0.75 animations:^{
            self.searchText.frame = CGRectMake(self.whiteView.bounds.size.width*0.25, 0, self.whiteView.bounds.size.width*0.75, self.whiteView.bounds.size.height);
        }];
    }
}
- (void)gl_whenInputTextFieldValueChange:(NSString *)text
{
    
    if ([self.searchDelegate respondsToSelector:@selector(gl_searchText:)]) {
        [self.searchDelegate gl_searchText:text];
    }
}
- (void)gl_clickKeyboardReturnButtonGetValue:(NSString *)text
{
    if ([self.searchDelegate respondsToSelector:@selector(gl_searchText:)]) {
        [self.searchDelegate gl_searchText:text];
    }
}

#pragma mark - 点击取消按钮
- (void)clickCancelButton
{
    [self.searchText setText:@""];
    [self.searchText resignFirstResponder];
    
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:gl_noticeTableViewDismiss object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}

#pragma mark - 通知键盘收起来
- (void)noticeTextFieldResignFirstResponder
{
    if ([self.searchText isFirstResponder]) {
        [self.searchText resignFirstResponder];
        GLLog(@"收到通知,退下键盘");
    }
}

@end
