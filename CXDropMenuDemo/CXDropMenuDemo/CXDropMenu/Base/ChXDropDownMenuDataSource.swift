//
//  CXDropDownMenuDataSource.swift
//  ChXDropdownMenuDemo
//
//  Created by Xu Chen on 2018/10/29.
//  Copyright © 2018 xu.yzl. All rights reserved.
//

import UIKit

// DropDownMenu 数据源，参照 UITableView 的 DataSource 方法
@objc protocol ChXDropDownMenuDataSource: class {
    
    /// 列数
    func chx_numberOfColumnsInDropDownMenu(_ menu: ChXDropDownMenu) -> Int
    
    /// 每列的标题
    func chx_dropDownMenu(_ menu: ChXDropDownMenu, titleInColumn column: Int) -> String
    
    /// 每列要显示的列表视图
    func chx_dropDownmenu(_ menu: ChXDropDownMenu, viewInColumn column: Int) -> UIView
    
    /// 每列要显示的列表视图高度
    func chx_dropDownmenu(_ menu: ChXDropDownMenu, heightInColumn column: Int) -> CGFloat
}


