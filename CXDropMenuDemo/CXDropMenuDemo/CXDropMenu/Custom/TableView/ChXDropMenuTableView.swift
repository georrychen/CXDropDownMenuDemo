//
//  ChXDropMenuTableView.swift
//  ChXDropdownMenuDemo
//
//  Created by Xu Chen on 2018/10/29.
//  Copyright © 2018 xu.yzl. All rights reserved.
//  封装的单行文字表格

import UIKit

@objc protocol ChXDropMenuTableViewDelegate {
    func chx_dropMenuTableViewDidSelected(viewModel: ChXDropMenuTableViewModel) -> Void
}

class ChXDropMenuTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    /// 选中的回调
    @objc var selectedCellHandler: ((_ row: Int) -> ())?
    
    /// 标题数据源
    @objc var dataArray = [ChXDropMenuTableViewModel]() {
        didSet {
            reloadData()
        }
    }

    /// 代理
    @objc var viewDelegate: ChXDropMenuTableViewDelegate?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .plain)
        
        self.delegate = self
        self.dataSource = self
        self.separatorStyle = .none
        
        let projectName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
//        let projectName = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? ""
        let className = projectName + "." + "ChXDropMenuTableViewCell"

        // 完整类名 = 包名.类名
//        let className = "ZhiTongChe" + "." + "ChXDropMenuTableViewCell"
        
        register(NSClassFromString(className) as! ChXDropMenuTableViewCell.Type, forCellReuseIdentifier: ChXDropMenuTableViewCell.identifier())
        
        self.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension ChXDropMenuTableView {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ChXDropMenuTableViewCell.identifier(), for: indexPath) as! ChXDropMenuTableViewCell

        let viewModel = dataArray[indexPath.row]
        cell.bindViewModel(model: viewModel)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = dataArray[indexPath.row]
        return viewModel.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = dataArray[indexPath.row]
        viewModel.selected = true
        
        // 取消其它cell选中状态
        for model in dataArray {
            if model.ID != viewModel.ID {
                model.selected = false
            }
        }
        reloadSections(IndexSet(integer: 0), with: .none)
        
        viewDelegate?.chx_dropMenuTableViewDidSelected(viewModel: viewModel)
    }
    
}
