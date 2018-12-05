//
//  ChXFlowTagsSectionHeadView.swift
//  ChXFlowTagsViewDemo
//
//  Created by Xu Chen on 2018/11/14.
//  Copyright © 2018 xu.yzl. All rights reserved.
//

import UIKit

class ChXFlowTagsSectionHeadView: UICollectionReusableView {

    @IBOutlet weak var showButton: UIButton!
    
    var currentModel: ChXFlowTagsCellViewModel!
    var buttonDidSelectCallBack: ((_ viewModel: ChXFlowTagsCellViewModel)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindViewModel(viewModel: ChXFlowTagsCellViewModel) {
        currentModel = viewModel
        
        showButton.setTitle(viewModel.title, for: .normal)
    }
    
    class func identifier() -> String {
        return String(describing: ChXFlowTagsSectionHeadView.self)
    }
    
    @IBAction func buttonDidSelected(_ sender: UIButton) {
        buttonDidSelectCallBack?(currentModel)
    }
    
}
