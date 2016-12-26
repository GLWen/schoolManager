//
//  GLSchoolViewController.m
//  yunzan
//
//  Created by 温国力 on 16/12/25.
//  Copyright © 2016年 云赞校园. All rights reserved.
//

#import "GLSchoolViewController.h"
#import "GLTool.h"
#import "GLLocation.h"
#import "GLSelectSchoolViewController.h"

@interface GLSchoolViewController ()<UITableViewDelegate,UITableViewDataSource,GLSelectSchoolViewControllerDelegate>
/**
 定位
 */
@property (nonatomic, strong) GLLocation *userLocation;
/**
 记录省份索引
 */
@property (nonatomic,assign) int index2;

/**
 用户当前省份
 */
@property (nonatomic, strong) NSString *userProvence;
/**
 用户当前城市
 */
@property (nonatomic, strong) NSString *userCity;

/** 
 将省份城市拼接显示到第一行
 */
@property (nonatomic, strong) NSString *rowOne;

/**
 创建tableView
 */
@property(strong,nonatomic) UITableView *tableView;
/**
 加载plist文件所有数据
 */
@property (nonatomic,strong) NSArray *addressArray;

/**
 存放省份的数据
 */
@property (nonatomic,strong) NSArray *addressArray1;


@end

@implementation GLSchoolViewController

#pragma mark - 重写记录器
- (void)setIndex:(NSInteger)index
{
    _index = index;
}
#pragma mark - 获取用户的当前位置
- (GLLocation *)userLocation
{
    if (!_userLocation) {
        _userLocation = [GLLocation defaultWGLLocationTool];
    }
    return _userLocation;
}

#pragma mark - 加载plist文件
- (NSArray *)addressArray
{
    if (_addressArray == nil) {
        _addressArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"schoolName.plist" ofType:nil]];
    }
    return _addressArray;
}
#pragma mark - 省份数组
- (NSArray *)addressArray1
{
    NSMutableArray *titleArry = [NSMutableArray array];
    for (NSDictionary *dict in self.addressArray) {
        [titleArry addObject:dict[@"name"]];
    }
    return titleArry;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"选择省份";
    /// 初始化tableView
    [self setupTableView];
    /// 获取用户的位置
    [self getUserLocation];
}
#pragma mark - 获取用户所在的位置
- (void)getUserLocation
{
    [self.userLocation getCurrentLocation:^(CLLocation *location, CLPlacemark *placemark, NSString *errorMessage) {
        if ([errorMessage length] > 0) {
            GLLog(@"定位失败：%@",errorMessage.description);
            self.userProvence = @"定位失败";
            [self.tableView reloadData];
        }else{
            GLLog(@"%@--%@---%@",location,placemark.administrativeArea,placemark.locality);
            self.userProvence = placemark.administrativeArea;
            self.userCity = placemark.locality;
            self.rowOne = [NSString stringWithFormat:@"当前位置：%@ %@",placemark.administrativeArea,placemark.locality];
            int index = 0;
            for (NSString *province in self.addressArray1) {
                NSString *headStr = [self.userProvence substringToIndex:2];
                if ([province containsString:headStr]) {
                    self.index2 = index;
                }
                index +=1;
            }
            [self.tableView reloadData];
        }
    }];
}
#pragma mark - 设置tableView的属性
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width  , [UIScreen mainScreen].bounds.size.height - 64) style:(UITableViewStylePlain)];
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
    return self.addressArray1.count + 1;
}

/**
 *  告诉tableView第indexPath行显示怎样的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        if (self.rowOne != nil) {
            cell.textLabel.text = self.rowOne;
        }else {
            cell.textLabel.text = @"正在定位中...";
        }
    }else { /// 因为第一行被占据，所以要减 1
        cell.textLabel.text = self.addressArray1[indexPath.row-1];
    }
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     GLSelectSchoolViewController *selectSchoolVC = [[GLSelectSchoolViewController alloc] init];
    selectSchoolVC.schoolDelegate = self;
    selectSchoolVC.index = self.index;
    
    /// 点击定位的第一行
    if (indexPath.row == 0) {
        if (self.userProvence != nil) {
            selectSchoolVC.province = self.userProvence;
            selectSchoolVC.index1 = self.index2;
            [self.navigationController pushViewController:selectSchoolVC animated:YES];
        }
    }else { /// 一定要减1，因为数组从0开始
        selectSchoolVC.province = self.addressArray1[indexPath.row-1];
        selectSchoolVC.index1 = indexPath.row - 1;
        [self.navigationController pushViewController:selectSchoolVC animated:YES];
    }
    
}
#pragma mark - GLSelectSchoolViewControllerDelegate
- (void)selectSchoolTextPopViewController:(GLSelectSchoolViewController *)controller didFinishSchoolText:(NSString *)text
{
    if ([self.schoolDelegate respondsToSelector:@selector(selectSchoolTextPopViewController:didFinishUserProvence:userCity:schoolText:)]) {
        [self.schoolDelegate selectSchoolTextPopViewController:self didFinishUserProvence:self.userProvence userCity:self.userCity schoolText:text];
    }
}
@end
