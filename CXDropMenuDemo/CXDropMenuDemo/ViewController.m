//
//  ViewController.m
//  CXDropMenuDemo
//
//  Created by Xu Chen on 2018/12/5.
//  Copyright © 2018 xu.yzl. All rights reserved.
//

#import "ViewController.h"
#import "CXDropMenuDemo-Swift.h"
#import "ChXDropMenuViewModel.h"

// 弱引用
#define MJWeakSelf __weak typeof(self) weakSelf = self;

@interface ViewController ()<ChXDropDownMenuDataSource, ChXDropMenuTableViewDelegate>
@property (nonatomic, strong) ChXDropDownMenu *dropMenu;
@property (nonatomic, strong) ChXDropMenuViewModel *viewModel;
@property (nonatomic, strong) NSArray <NSString *> *dropTitles;
@property (nonatomic, strong) NSArray <UIView *> *dropMenuColumnViews;
@property (nonatomic, strong) NSArray <NSNumber *> *dropMenucolumnViewsHeight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;
    
    self.viewModel = [[ChXDropMenuViewModel alloc] init];
    [self.viewModel chx_getDropMenuDatas:^(NSArray * dropMenuDatas) {
        [self chx_setupDropMenu:dropMenuDatas];
    }];
    
    self.dropTitles = @[@"按专业/科目",@"按排序"];
}

- (void)chx_setupDropMenu:(NSArray *)resultArray {
    NSLog(@"resultArray = \n %@", resultArray);
    
    // 1. 流式标签
    UIView *flowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.viewModel.flowTagsHeight)];
    flowView.backgroundColor = UIColor.clearColor;
    
    ChXFlowTagsView *flowTagsView = [[ChXFlowTagsView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.viewModel.flowTagsHeight - 45) collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    flowTagsView.dataArray = resultArray[0];
    MJWeakSelf
    flowTagsView.selectResultClosure = ^(NSArray<ChXFlowTagsCellViewModel *> * selectedArray) {
        ChXFlowTagsCellViewModel *model = selectedArray.firstObject;
        NSLog(@"选中了 %@", model.title);
//        weakSelf.classSubjectId = [model.iD integerValue];
        
        // 设置头部选中显示文字
        [weakSelf.dropMenu setSelectedTitleWithText:model.topShowTitle];
        [weakSelf.dropMenu hideMenu];
        
        // 刷新表格
//        [weakSelf.classTableView bl_StartRefreshing];
    };
    
    /// 底部取消按钮
    ChXFlowTagsViewFooter *flowTagsViewFootView = [[NSBundle mainBundle] loadNibNamed:@"ChXFlowTagsViewFooter" owner:nil options:nil].firstObject;
    flowTagsViewFootView.frame = CGRectMake(0, self.viewModel.flowTagsHeight - 45, flowTagsView.bounds.size.width, 45);
    [flowView addSubview:flowTagsView];
    [flowView addSubview:flowTagsViewFootView];
    
    // 2. 单行表格
    ChXDropMenuTableView *singleTable = [[ChXDropMenuTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) style:UITableViewStylePlain];
    singleTable.viewDelegate = self;
    singleTable.dataArray = resultArray[1];
    
    self.dropMenuColumnViews = @[flowTagsView, singleTable];
    self.dropMenucolumnViewsHeight = @[@(self.viewModel.flowTagsHeight), @(self.viewModel.singleTableHeight)];
    
    [self.view addSubview:self.dropMenu];
}

// MARK: - ChXDropDownMenuDataSource

- (NSInteger)chx_numberOfColumnsInDropDownMenu:(ChXDropDownMenu *)menu {
    return self.dropTitles.count;
}

- (NSString *)chx_dropDownMenu:(ChXDropDownMenu *)menu titleInColumn:(NSInteger)column {
    return self.dropTitles[column];
}

- (UIView *)chx_dropDownmenu:(ChXDropDownMenu *)menu viewInColumn:(NSInteger)column {
    return self.dropMenuColumnViews[column];
}

- (CGFloat)chx_dropDownmenu:(ChXDropDownMenu *)menu heightInColumn:(NSInteger)column {
    return [self.dropMenucolumnViewsHeight[column] floatValue];
}

// MARK: - ChXDropMenuTableViewDelegate
- (void)chx_dropMenuTableViewDidSelectedWithViewModel:(ChXDropMenuTableViewModel *)viewModel {
    //    print[("单行表格 - 选中了 \(viewModel.title)")
    // 设置头部选中显示文字
    [self.dropMenu setSelectedTitleWithText:viewModel.title];
    [self.dropMenu hideMenu];
    
    // 刷新表格
//    self.classOrder = [viewModel.ID integerValue];
//    [self.classTableView bl_StartRefreshing];
}

- (ChXDropDownMenu *)dropMenu {
    if (!_dropMenu) {
        _dropMenu = [[ChXDropDownMenu alloc] initWithFrame:CGRectMake(0, UIApplication.sharedApplication.statusBarFrame.size.height + 44, self.view.frame.size.width, 45)];
        _dropMenu.dataSource = self;
    }
    return _dropMenu;
}


@end
