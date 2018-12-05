//
//  ChXDropDownMenuConfiguration.swift
//  ChXDropdownMenuDemo
//
//  Created by Xu Chen on 2018/10/29.
//  Copyright © 2018 xu.yzl. All rights reserved.
//  ChXDropDownMenu 的配置信息

import UIKit

class ChXDropDownMenuConfiguration {
    
    /// 菜单标题文字颜色
    var menuTitleColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
    /// 菜单标题文字选中颜色
    var seletedMenuTitleColor = UIColor(red: 62/255.0, green: 131/255.0, blue: 229/255.0, alpha: 1)
    /// cell 宽度
    var cellWidth: CGFloat = UIScreen.main.bounds.width
    /// cell 高度
    var cellHeight: CGFloat = 45
    /// cell 文字颜色
    var cellTextLabelColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
    /// cell 选中文字颜色
    var selectedCellTextLabelColor = UIColor(red: 62/255.0, green: 131/255.0, blue: 229/255.0, alpha: 1)
    /// cell 文字字体
    var cellTextLabelFont = UIFont.systemFont(ofSize: 15)
    /// 图标边距
    var arrowPadding = 15
    /// 动画时长
    var animationDuration = 0.3
    /// 是否选中
    var isSelected = false
    
    var tableViewHeight: CGFloat = 300
    var fontSize:CGFloat = 15
    var separatorColor = UIColor(red: 219/255.0, green: 219/255.0, blue: 219/255.0, alpha: 1)

    /// 选中
//    var checkMarkImage: UIImage? = {
//        let bundle = Bundle(for: ChXDropDownMenuConfiguration.self)
//        let imageBundleUrl = bundle.url(forResource: "ChXDropDownMenu", withExtension: "bundle")
//        let imageBundle = Bundle(url: imageBundleUrl!)
//        let checkMarkImagePath = imageBundle?.path(forResource: "checkmark_icon", ofType: "png")
//        
//        return UIImage(contentsOfFile: checkMarkImagePath!)
//    }()

}
