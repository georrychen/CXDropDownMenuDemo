//
//  ChXFlowTagsCell.swift
//  ChXFlowTagsViewDemo
//
//  Created by Xu Chen on 2018/11/14.
//  Copyright © 2018 xu.yzl. All rights reserved.
//

import UIKit

protocol ChXFlowTagsCellDelegate {
    func ChXFlowTagsCellDidSelected(_ viewModel: ChXFlowTagsCellViewModel) -> Void
}

class ChXFlowTagsCell: UICollectionViewCell {

    @IBOutlet weak var showButton: UIButton!
    
    var normalImage = UIImage(named: "课程列表_未选")!
    var selectedImage = UIImage(named: "课程列表_选中1")!
    
    var currentViewModel = ChXFlowTagsCellViewModel()
    var delegate: ChXFlowTagsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // 圆角图片拉升不变形
        normalImage = normalImage.stretchableImage(withLeftCapWidth: Int(normalImage.size.width * 0.5), topCapHeight: Int(normalImage.size.height * 0.5))
//        normalImage = normalImage.resizableImage(withCapInsets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), resizingMode: .stretch)
        
        selectedImage = selectedImage.stretchableImage(withLeftCapWidth: Int(selectedImage.size.width * 0.5), topCapHeight: Int(selectedImage.size.height * 0.5))

        showButton.setBackgroundImage(normalImage, for: .normal)
      
        showButton.setBackgroundImage(selectedImage, for: .selected)
        showButton.setBackgroundImage(selectedImage, for: .highlighted)

    }
    
    func bindViewModel(viewModel: ChXFlowTagsCellViewModel) {
        currentViewModel = viewModel
        
        showButton.setTitle(viewModel.title, for: .normal)
        showButton.isSelected = currentViewModel.selected
        
        // FIXME: chenxu - 如果需要修改文字颜色，可使用 "课程列表_选中" 这个背景图来配合使用
        // var selectedImage = UIImage(named: "课程列表_选中1")!

//        if showButton.isSelected {
//            showButton.setTitleColor(UIColor.white, for: .normal)
//        } else {
//            showButton.setTitleColor(UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1), for: .normal)
//        }
    }
    
    
    class func identifier() -> String {
       let str = String(describing: ChXFlowTagsCell.self)
       return str
    }

    @IBAction func buttonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
   
        currentViewModel.selected = sender.isSelected
        delegate?.ChXFlowTagsCellDidSelected(currentViewModel)
    }
    
}
