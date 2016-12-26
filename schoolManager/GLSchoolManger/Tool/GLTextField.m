//
//  GLTextField.m
//  yunzan
//
//  Created by 温国力 on 16/12/23.
//  Copyright © 2016年 温国力. All rights reserved.
//

#import "GLTextField.h"
static NSString * const GLPlacerholderColorKeyPath = @"placeholderLabel.textColor";

@interface GLTextField()<UITextFieldDelegate>


@end
@implementation GLTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.tintColor = [UIColor colorWithWhite:51.0/255.0 alpha:1.0];
        self.textColor = [UIColor colorWithWhite:51.0/255.0 alpha:1.0];
        self.placeholderColor = [UIColor colorWithWhite:224.0/255.0 alpha:1.0];
        self.alpha = 1.0;
        self.font = [UIFont systemFontOfSize:12];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.delegate = self;
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}
#pragma mark - awakeFromNib
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.delegate = self;
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}
#pragma mark - setPlaceholderColor
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    if (!placeholderColor) {
        return;
    }
    
    _placeholderColor = placeholderColor;
    [self setValue:placeholderColor forKeyPath:GLPlacerholderColorKeyPath];
}
#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.delegate = self;
    [self setValue:self.placeholderColor forKeyPath:GLPlacerholderColorKeyPath];
    
}
#pragma mark - textFieldShouldChangeCharactersInRange
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL textChange  = YES;
    if (textField.text.length >= self.limitCount) textChange = NO;
    if (range.length == 1) {
        textChange = YES;
    }
    if ([self.glDelegate respondsToSelector:@selector(gl_whenInputTextField:shouldChangeCharactersInRange:replacementString:)]) {
        [self.glDelegate gl_whenInputTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return textChange;
    
}
#pragma mark - 文本即将编辑的时候调用
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.glDelegate respondsToSelector:@selector(gl_textFieldDidBeginEditing)]) {
        [self.glDelegate gl_textFieldDidBeginEditing];
    }
}
#pragma mark - textFieldShouldReturn
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if ([self.glDelegate respondsToSelector:@selector(gl_clickKeyboardReturnButtonGetValue:)]) {
        [self.glDelegate gl_clickKeyboardReturnButtonGetValue:textField.text];
    }
    return YES;
}
#pragma mark - textFieldDidChange
- (void)textFieldDidChange:(UITextField *)textField
{
 
    if ([self.glDelegate respondsToSelector:@selector(gl_whenInputTextFieldValueChange:)]) {
        [self.glDelegate gl_whenInputTextFieldValueChange:textField.text];
    }
    
    if (textField.text.length > self.limitCount) {
        textField.text = [textField.text substringToIndex:self.limitCount];
    }
}
#pragma mark - 编辑结束
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if ([self.glDelegate respondsToSelector:@selector(gl_whenInputTextFieldEndValue:)]) {
        [self.glDelegate gl_whenInputTextFieldEndValue:textField.text];
    }
}


@end
