//
//  ChXDropMenuTableViewModel.swift
//  ChXFlowTagsViewDemo
//
//  Created by Xu Chen on 2018/11/15.
//  Copyright © 2018 xu.yzl. All rights reserved.
//

import UIKit

class ChXDropMenuTableViewModel: NSObject {

    @objc var selected = false
    @objc var title = "单个列表"
    @objc var ID = "0"
    @objc var cellHeight: CGFloat = 45
    @objc let textColor = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
    @objc let selectedTextColor = UIColor.init(red: 62/255.0, green: 131/255.0, blue: 229/255.0, alpha: 1)
}
