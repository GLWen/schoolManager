//
//  GLSchoolSearchView.m
//  yunzan
//
//  Created by 温国力 on 16/12/24.
//  Copyright © 2016年 温国力. All rights reserved.
//

#import "GLSchoolSearchView.h"
#import "GLTool.h"

@interface GLSchoolSearchView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UITableView *tableView;

@end

@implementation GLSchoolSearchView

#pragma mark - 重写set方法
- (void)setResultArray:(NSArray *)resultArray
{
    _resultArray = resultArray;
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    
    NSLog(@"%@",resultArray);
}
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0/255.0 alpha:0.35];
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width  , [UIScreen mainScreen].bounds.size.height - 64 - gl_searchBarHeight) style:(UITableViewStylePlain)];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorColor = gl_lineColor;
        // 设置端距，这里表示separator离左边和右边均0像素
        tableView.separatorInset = UIEdgeInsetsMake(0,0, 0, 0);
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.delegate =self;
        tableView.dataSource = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        tableView.hidden = YES;
        [self addSubview:tableView];
        self.tableView = tableView;
        
        //获取通知中心单例对象
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
        [center addObserver:self selector:@selector(noticeTableViewDismiss) name:gl_noticeTableViewDismiss object:nil];
        
    }
    return self;
}
#pragma mark layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
}
#pragma mark - <UITableViewDataSource>

/**
 *  告诉tableView第section组有多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return self.resultArray.count;
}

/**
 *  告诉tableView第indexPath行显示怎样的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.resultArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; /// 右边指示器
    cell.textLabel.textColor = gl_textColor;
    cell.textLabel.font = gl_textFont;
    cell.selectionStyle = UITableViewCellSelectionStyleNone; /// 选中不显示效果
    
    return cell;
}
#pragma mark - tableView代理方法

/**
 *  cell高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return gl_cellHeight;
}

#pragma mark - cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *schoolName = self.resultArray[indexPath.row];
    if ([self.searchDelegate respondsToSelector:@selector(selectSchool:)]) {
        [self.searchDelegate selectSchool:schoolName];
        [self noticeTableViewDismiss];
    }
    GLLog(@"点击搜索结果：%@",schoolName);
}
#pragma mark - tableView即将滚动的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:gl_textFieldResignFirstResponder object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}

#pragma mark - noticeTableViewDismiss
- (void)noticeTableViewDismiss
{
    
    if (self.tableView.hidden == NO || self.frame.origin.y == gl_searchBarHeight ) {
        self.tableView.hidden = YES;
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }
}

#pragma mark - 如果没搜索内容，点击屏幕让自己消失
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.resultArray.count > 0) {
        GLLog(@"收到：%zd个数组",self.resultArray.count);
    }else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        });
    }
    
}
@end
