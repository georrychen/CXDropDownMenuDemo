//
//  ChXDropMenuViewModel.m
//  CXDropMenuDemo
//
//  Created by Xu Chen on 2018/12/5.
//  Copyright © 2018 xu.yzl. All rights reserved.
//

#import "ChXDropMenuViewModel.h"
#import "CXDropMenuDemo-Swift.h" // 替换成对应项目的 swift 文件

// 弱引用
#define MJWeakSelf __weak typeof(self) weakSelf = self;

@interface ChXDropMenuViewModel()
@property (nonatomic, strong) NSArray <ChXFlowTagsCellViewModel *> *subjectListDatas;
@property (nonatomic, strong) NSMutableArray <ChXDropMenuTableViewModel *> *sortListDatas;
@property (nonatomic, strong) NSMutableArray *dropMenuDataArray;
@property (nonatomic, strong) dispatch_group_t group;

@end

@implementation ChXDropMenuViewModel

- (void)chx_getDropMenuDatas:(void(^)(NSArray *))completion {
    _group = dispatch_group_create();
    
    [self chx_loadSortData];
    [self chx_loadSubjectData];
    
    MJWeakSelf
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        weakSelf.dropMenuDataArray = @[weakSelf.subjectListDatas, weakSelf.sortListDatas].mutableCopy;
        completion(weakSelf.dropMenuDataArray);
    });
}

- (void)chx_loadSortData {
    dispatch_group_enter(_group);
    
    NSArray *originSortArr = @[
                               @{@"title":@"全部", @"id":@"0"},
                               @{@"title":@"热门", @"id":@"1"},
                               @{@"title":@"最新", @"id":@"2"},
                               @{@"title":@"价格", @"id":@"3"}
                               ];
    MJWeakSelf
    [originSortArr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        ChXDropMenuTableViewModel *model = [[ChXDropMenuTableViewModel alloc] init];
        model.cellHeight = 42;
        model.ID = dict[@"id"];
        model.title = dict[@"title"];
        model.selected = (idx == 0) ? YES : NO;
        
        [weakSelf.sortListDatas addObject:model];
    }];
    
    self.singleTableHeight = 42 * self.sortListDatas.count;
    
    dispatch_group_leave(_group);
}

- (void)chx_loadSubjectData {
    dispatch_group_enter(_group);
    
    self.flowTagsHeight = 400;
    
    // 1. 替换成想要的网络请求，获取服务器数据
//    BLRequestConfig *config = [BLRequestConfig new];
//    config.url = [HTTPInterface subjectList];
//    MJWeakSelf
//    [BLNetRequestModel request:config success:^(id responseData) {
//        if ([responseData isKindOfClass:[NSDictionary class]]) {
//            if ([responseData[@"success"] boolValue]) {
//                NSArray *tmpArr = responseData[@"entity"];
//                NSArray *flowTagsViewModels = [weakSelf filtFlowTagsViewModels:tmpArr];
//
//                weakSelf.subjectListDatas = flowTagsViewModels;
//            }
//        }
//        dispatch_group_leave(weakSelf.group);
//    } failure:^(NSError *error) {
//        dispatch_group_leave(weakSelf.group);
//    }];
    
    // 2. 这里先采用模拟本地数据源
    NSArray *tmpArr = [self loadLocalJsonDatas:@"ChXDropMenuData"];
    if (!tmpArr.count) {
        NSLog(@"本地json 解析失败");
    }
    NSArray *flowTagsViewModels = [self filtFlowTagsViewModels:tmpArr];
    self.subjectListDatas = flowTagsViewModels;
    
    dispatch_group_leave(self.group);
}

- (NSArray *)loadLocalJsonDatas:(NSString *)jsonFileName {
    NSString *jsonDataPath = [[NSBundle mainBundle] pathForResource:jsonFileName ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonDataPath];
    NSArray *jsonArray = [[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONWritingPrettyPrinted |kNilOptions error:nil] mutableCopy];
    return jsonArray;
}

- (NSArray *)filtFlowTagsViewModels:(NSArray *)dictDatas {
    NSMutableArray *viewModels = @[].mutableCopy;
    // 头部添加一个全部的按钮
    NSMutableArray *mDictDatas = dictDatas.mutableCopy;
    NSDictionary *zeroDict = @{@"subjectId":@"0",
                               @"subjectName": @"全部",
                               @"topSubjectName": @"全部",
                               @"childSubjectList": @[]
                               };
    [mDictDatas insertObject:zeroDict atIndex:0];
    
    [mDictDatas enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        ChXFlowTagsCellViewModel *viewModel = [[ChXFlowTagsCellViewModel alloc] init];
        viewModel.iD = [NSString stringWithFormat:@"%@",dict[@"subjectId"]];
        viewModel.title = dict[@"subjectName"];
        viewModel.topShowTitle = dict[@"subjectName"];
        viewModel.cellSize = [self calculateFlowTagStringSize:viewModel.title];
        viewModel.section = idx;
        
        NSArray *childSubjectList = dict[@"childSubjectList"];
        NSMutableArray *subviewModels = @[].mutableCopy;
        
        // 每个分区下面添加一个全部的按钮
        ChXFlowTagsCellViewModel *allModel = [[ChXFlowTagsCellViewModel alloc] init];
        allModel.iD = [NSString stringWithFormat:@"%@",dict[@"subjectId"]];
        allModel.title = @"全部";
        allModel.topShowTitle = viewModel.title;
        allModel.cellSize = [self calculateFlowTagStringSize:allModel.title];
        allModel.row = 0;
        allModel.section = idx;
        [subviewModels addObject:allModel];
        
        [childSubjectList enumerateObjectsUsingBlock:^(NSDictionary *subDict, NSUInteger subIdx, BOOL * _Nonnull stop) {
            ChXFlowTagsCellViewModel *viewModel = [[ChXFlowTagsCellViewModel alloc] init];
            viewModel.iD = [NSString stringWithFormat:@"%@",subDict[@"subjectId"]];
            viewModel.title = subDict[@"subjectName"];
            viewModel.topShowTitle = viewModel.title;
            viewModel.section = idx;
            viewModel.row = subIdx + 1;
            viewModel.cellSize = [self calculateFlowTagStringSize:viewModel.title];
            
            [subviewModels addObject:viewModel];
        }];
        viewModel.subTitles = subviewModels;
        
        [viewModels addObject:viewModel];
    }];
    
    return viewModels;
}

/**
 计算流式标签文字的尺寸
 */
- (CGSize )calculateFlowTagStringSize:(NSString *)string {
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size;
    return CGSizeMake(ceil(size.width) + 26, 34);
}

// MARK: -  Lazy load

- (NSArray<ChXFlowTagsCellViewModel *> *)subjectListDatas {
    if (!_subjectListDatas) {
        _subjectListDatas = @[];
    }
    return _subjectListDatas;
}

- (NSMutableArray<ChXDropMenuTableViewModel *> *)sortListDatas {
    if (!_sortListDatas) {
        _sortListDatas = @[].mutableCopy;
    }
    return _sortListDatas;
}

- (NSMutableArray *)dropMenuDataArray {
    if (!_dropMenuDataArray) {
        _dropMenuDataArray = @[].mutableCopy;
    }
    return _dropMenuDataArray;
}



@end
