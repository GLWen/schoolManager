//
//  GLSelectSchoolViewController.m
//  yunzan
//
//  Created by 温国力 on 16/12/25.
//  Copyright © 2016年 温国力. All rights reserved.
//

#import "GLSelectSchoolViewController.h"
#import "GLTool.h"
#import "GLSchoolSearchBar.h"                   /// 自定义搜索框
#import "GLSchoolSearchView.h"                  /// 搜索结果的view

@interface GLSelectSchoolViewController ()<UITableViewDelegate,UITableViewDataSource,GLSchoolSearchBarDelegate,GLSchoolSearchViewDelegate>

/**
 自定义搜索框
 */
@property (nonatomic, strong) GLSchoolSearchBar *schoolSearchBar;

/**
 创建tableView
 */
@property(strong,nonatomic) UITableView *tableView;

/**
 加载plist文件所有数据
 */
@property (nonatomic,strong) NSArray *addressArray;

/**
 存放学校的数组
 */
@property (nonatomic,strong) NSArray *schoolArray;

/**
 存放搜索结果的数组
 */
@property (nonatomic,strong) NSMutableArray *resultArray;

/**
 搜索结果的view
 */
@property(strong,nonatomic) GLSchoolSearchView *schoolSearchView;


@end

@implementation GLSelectSchoolViewController
#pragma mark - 重写记录器
- (void)setIndex:(NSInteger)index
{
    if (index) {
       _index = index;
    }else {
        _index = 0;
    }
    
}
#pragma mark - 重写省份
- (void)setProvince:(NSString *)province
{
    _province = province;
}
#pragma mark - 重写索引
- (void)setIndex1:(NSInteger)index1
{
    _index1 = index1;
}
#pragma mark - 懒加载
- (NSArray *)addressArray
{
    if (_addressArray == nil) {
        _addressArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"schoolName.plist" ofType:nil]];
    }
    return _addressArray;
}
- (NSArray *)schoolArray
{
    NSArray *array = [self.addressArray objectAtIndex:self.index1][@"sub"];
    return array;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"选择学校";
    /// 自定义搜索框
    [self setupSearchBar];
    /// 添加tableView
    [self setupTableView];
    /// 添加搜索结果的view 一定要放后面，不然会被tableView覆盖
    [self setupSearchView];
}
#pragma mark - 搜索框
- (void)setupSearchBar
{
    self.schoolSearchBar = [[GLSchoolSearchBar alloc] init];
    self.schoolSearchBar.searchDelegate = self;
    [self.view addSubview:self.schoolSearchBar];
}
#pragma mark - setupSearchView
- (void)setupSearchView
{
    // 存放搜索的结果数组
    self.resultArray = [NSMutableArray array];
    
    /// 一开始就在最底部创建一个看不到的searchView，目的做动画向上出现
    self.schoolSearchView = [[GLSchoolSearchView alloc] init];
    self.schoolSearchView.searchDelegate = self;
    [self.view addSubview:self.schoolSearchView];
}
#pragma mark - 设置tableView的属性
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, gl_searchBarHeight, [UIScreen mainScreen].bounds.size.width  , [UIScreen mainScreen].bounds.size.height - 64 - gl_searchBarHeight) style:(UITableViewStylePlain)];
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
    return self.schoolArray.count;
}

/**
 *  告诉tableView第indexPath行显示怎样的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.schoolArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; /// 右边指示器
    cell.textLabel.textColor = gl_textColor;
    cell.textLabel.font = gl_textFont;
    cell.selectionStyle = UITableViewCellSelectionStyleNone; /// 选中不显示效果
    return cell;
}
/**
 *  告诉tableView第section组的头部标题
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30);
    headerView.backgroundColor = gl_headerBgColor;
    
    /// 头部标题文字
    UILabel *text = [[UILabel alloc] init];
    text.text = self.province;
    text.frame = CGRectMake(gl_headerLeftMargin, headerView.bounds.size.height - gl_headerTextHeight - gl_headerBottomMargin, headerView.bounds.size.width, gl_headerTextHeight);
    text.textColor = gl_headerExpandColor;
    text.font = gl_headerTextFont;
    [headerView addSubview:text];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = gl_lineColor;
    bottomLine.frame = CGRectMake(0, headerView.bounds.size.height - 1, headerView.bounds.size.width, 1);
    [headerView addSubview:bottomLine];
    
    
    return headerView;
}

#pragma mark - tableView代理方法
/**
 *  头部标题高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return gl_headerHeight;
}

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
    NSString *schoolName = self.schoolArray[indexPath.row];
    if ([self.schoolDelegate respondsToSelector:@selector(selectSchoolTextPopViewController:didFinishSchoolText:)]) {
        [self.schoolDelegate selectSchoolTextPopViewController:self didFinishSchoolText:schoolName];
        UIViewController *popVC = self.navigationController.viewControllers[self.index];
        [self.navigationController popToViewController:popVC animated:YES];
    }
}
#pragma mark - GLSchoolSearchBarDelegate
- (void)gl_whenTextFieldDidBeginEditing
{
    if (self.schoolSearchView.frame.origin.y == [UIScreen mainScreen].bounds.size.height) {
        self.schoolSearchView.frame = CGRectMake(0, gl_searchBarHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - gl_searchBarHeight);
    }
    
}
- (void)gl_searchText:(NSString *)text
{
    /// 如果搜索结果数组有数据，先移除
    if (self.resultArray.count > 0) {
        [self.resultArray removeAllObjects];
    }
    
    if (text.length > 0) {
        GLLog(@"输入的文字：%@---%zd",text,text.length);
        /// 遍历所有的学校
        for (NSString *schoolStr in self.schoolArray) {
            /// 判断所有学校是否包含有搜索的文字 加到搜索结果数组中
            if ([schoolStr containsString:text]) {
                [self.resultArray addObject:schoolStr];
            }
        }
        /// 如果有匹配的结果，就将结果传递进去，否则就返回 其他学校
        if (self.resultArray.count > 0) {
            GLLog(@"%@",self.resultArray[0]);
            self.schoolSearchView.resultArray = self.resultArray;
        }else {
            self.schoolSearchView.resultArray = @[@"其他学校"];
        }
        
    }else {
        GLLog(@"请输入需要搜索的文字");
    }
    
}
#pragma mark - GLSchoolSearchViewDelegate
- (void)selectSchool:(NSString *)text
{
    if ([self.schoolDelegate respondsToSelector:@selector(selectSchoolTextPopViewController:didFinishSchoolText:)]) {
        [self.schoolDelegate selectSchoolTextPopViewController:self didFinishSchoolText:text];
        UIViewController *popVC = self.navigationController.viewControllers[self.index];
        [self.navigationController popToViewController:popVC animated:YES];
    }
}
#pragma mark - tableView即将滚动的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:gl_textFieldResignFirstResponder object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}




@end
