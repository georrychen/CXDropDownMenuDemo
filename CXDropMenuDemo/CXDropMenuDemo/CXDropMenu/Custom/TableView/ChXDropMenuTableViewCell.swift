//
//  ChXDropMenuTableViewCell.swift
//  ChXDropdownMenuDemo
//
//  Created by Xu Chen on 2018/10/29.
//  Copyright © 2018 xu.yzl. All rights reserved.
//

import UIKit

class ChXDropMenuTableViewCell: UITableViewCell {
    
    var cellContentFrame: CGRect!
    let checkmarkIconWidth: CGFloat = 10
    let horizontalMargin: CGFloat = 20
    var checkmarkIcon: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        cellContentFrame = CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.bounds.width)!, height: 45)

        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        selectionStyle = .none
        textLabel?.font = UIFont.systemFont(ofSize: 14)
        textLabel?.frame = CGRect(x: horizontalMargin, y: 0, width: cellContentFrame.width, height: cellContentFrame.height)
        
        // 选中图标
        checkmarkIcon = UIImageView(frame: CGRect(x: cellContentFrame.width - checkmarkIconWidth - horizontalMargin, y: (cellContentFrame.height - checkmarkIconWidth) / 2.0, width: checkmarkIconWidth, height: checkmarkIconWidth))
        checkmarkIcon.image = UIImage(named: "checkmark_icon")
        checkmarkIcon.contentMode = .scaleAspectFill
        contentView.addSubview(checkmarkIcon)
        
        checkmarkIcon.isHidden = true
    }
    
    override func layoutSubviews() {
        self.bounds = cellContentFrame
        self.contentView.frame = self.bounds
    }
    
    class func identifier() -> String {
        return String(describing: ChXDropMenuTableViewCell.self)
    }
    
}

extension ChXDropMenuTableViewCell {
    
    func bindViewModel(model: ChXDropMenuTableViewModel) {
        textLabel?.text = model.title
        
        if model.selected == true {
            checkmarkIcon.isHidden = false
            textLabel?.textColor = model.selectedTextColor
        } else {
            checkmarkIcon.isHidden = true
            textLabel?.textColor = model.textColor
        }
    }
    
}
