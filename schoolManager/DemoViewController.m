//
//  DemoViewController.m
//  schoolManager
//
//  Created by 温国力 on 16/12/26.
//  Copyright © 2016年 wenguoli. All rights reserved.
//

#import "DemoViewController.h"
#import "GLTool.h"
#import "GLSchoolViewController.h"

@interface DemoViewController ()<UITableViewDelegate,UITableViewDataSource,GLSchoolViewControllerDelegate>
/**
 创建tableView
 */
@property(strong,nonatomic) UITableView *tableView;

/**
 记录回调回来的数据
 */
@property (nonatomic,strong) NSString *schoolText;

@end

@implementation DemoViewController
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Demo";
    [self setupTableView];
}
#pragma mark - 设置tableView的属性
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height - 64) style:(UITableViewStylePlain)];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorColor = gl_lineColor;
    // 设置端距，这里表示separator离左边和右边均0像素
    tableView.separatorInset = UIEdgeInsetsMake(0,0, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.delegate =self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}
#pragma mark - <UITableViewDataSource>
/**
 *  告诉tableView第section组有多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /// 多加一行，就是第一行头部定位的行数
    return 1;
}

/**
 *  告诉tableView第indexPath行显示怎样的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"选择学校";
    if (self.schoolText != nil) {
        cell.textLabel.text = self.schoolText;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; /// 右边指示器
    cell.textLabel.textColor = gl_textColor;
    cell.textLabel.font = gl_textFont;
    cell.selectionStyle = UITableViewCellSelectionStyleNone; /// 选中不显示效果
    return cell;
}

#pragma mark - tableView代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return gl_cellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GLSchoolViewController *selectSchoolVC = [[GLSchoolViewController alloc] init];
    selectSchoolVC.schoolDelegate = self;
    [self.navigationController pushViewController:selectSchoolVC animated:YES];
    
}

#pragma mark - GLSchoolViewControllerDelegate 必须实现回调数据
- (void)selectSchoolTextPopViewController:(GLSchoolViewController *)controller didFinishUserProvence:(NSString *)userProvence userCity:(NSString *)userCity schoolText:(NSString *)text
{
    self.schoolText = text;
    [self.tableView reloadData];
}


@end
