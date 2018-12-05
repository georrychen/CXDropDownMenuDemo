//
//  ChXFlowTagsCellViewModel.swift
//  ChXFlowTagsViewDemo
//
//  Created by Xu Chen on 2018/11/14.
//  Copyright © 2018 xu.yzl. All rights reserved.
//

import UIKit

class ChXFlowTagsCellViewModel: NSObject {
    
    /// cell 尺寸
    @objc var cellSize: CGSize = CGSize.zero
    /// 是否选中
    @objc var selected = false
    /// 子数组
    @objc var subTitles = [ChXFlowTagsCellViewModel]()
    /// 标题
    @objc var title = ""
    /// 用于头部菜单显示的标题
    @objc var topShowTitle = ""
    /// id
    @objc var iD = "0"
    /// 分区
    @objc var section: Int = 0
    /// 行数
    @objc var row: Int = 0

}
