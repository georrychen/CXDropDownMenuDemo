//
//  ChXDropMenuViewModel.h
//  CXDropMenuDemo
//
//  Created by Xu Chen on 2018/12/5.
//  Copyright © 2018 xu.yzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChXDropMenuViewModel : NSObject
/*! 单行表格高度 */
@property (nonatomic, assign) CGFloat singleTableHeight;
/*! 流式标签高度 */
@property (nonatomic, assign) CGFloat flowTagsHeight;

/**
 获取下拉菜单的数据源
 */
- (void)chx_getDropMenuDatas:(void(^)(NSArray *))completion;

@end

NS_ASSUME_NONNULL_END
