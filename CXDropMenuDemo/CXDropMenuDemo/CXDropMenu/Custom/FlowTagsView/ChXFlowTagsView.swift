//
//  ChXFlowTagsView.swift
//  ChXFlowTagsViewDemo
//
//  Created by Xu Chen on 2018/11/14.
//  Copyright © 2018 xu.yzl. All rights reserved.
//

import UIKit

class ChXFlowTagsView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ChXFlowTagsCellDelegate {
    
    /// 数据源
   @objc var dataArray = [ChXFlowTagsCellViewModel]() {
        didSet {
            reloadData()
        }
    }
    
    /// 选中的 models
    var selectedArray = [ChXFlowTagsCellViewModel]()
    
    /// 选中结果闭包
    @objc var selectResultClosure: ((_ selectArray: [ChXFlowTagsCellViewModel])->())?
    

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        // UICollectionViewLeftAlignedLayout 左对齐的一个三方库
        let flowLayout = UICollectionViewLeftAlignedLayout()
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backgroundColor = UIColor.white
        delegate = self
        dataSource = self
        
        register(UINib(nibName: "ChXFlowTagsCell", bundle: nil), forCellWithReuseIdentifier: ChXFlowTagsCell.identifier())
        register(UINib(nibName: "ChXFlowTagsSectionHeadView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: ChXFlowTagsSectionHeadView.identifier())
    }
    
}


extension ChXFlowTagsView {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let viewModel = dataArray[section]
        return viewModel.subTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChXFlowTagsCell.identifier(), for: indexPath) as! ChXFlowTagsCell
        
        let sectionViewModel = dataArray[indexPath.section]
        let viewModel = sectionViewModel.subTitles[indexPath.row]
        cell.bindViewModel(viewModel: viewModel)
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == "UICollectionElementKindSectionHeader" {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ChXFlowTagsSectionHeadView.identifier(), for: indexPath) as! ChXFlowTagsSectionHeadView
            let sectionViewModel = dataArray[indexPath.section]
            view.bindViewModel(viewModel: sectionViewModel)
            
            // 分区头添加点击事件
//            view.buttonDidSelectCallBack = { [weak self] (_ viewModel: ChXFlowTagsCellViewModel)->() in
//                self?.selectResultClosure?([viewModel])
//            }
            
            return view
        } else {
            return UICollectionReusableView()
        }
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionViewModel = dataArray[indexPath.section]
        let viewModel = sectionViewModel.subTitles[indexPath.row]
        
//        return CGSize(width: viewModel.cellSize.width, height: 35)
        return  viewModel.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: frame.width, height: 40)
    }
    
}


// MARK: - ChXFlowTagsCellDelegate
extension ChXFlowTagsView {
    
    func ChXFlowTagsCellDidSelected(_ viewModel: ChXFlowTagsCellViewModel) {
        print(viewModel)
//        print("选中按钮的 ID \(viewModel.iD)")

        // 1. 单选
        selectedArray.removeAll()
        if viewModel.selected == true {
            // 其它 cell 设置为未选中状态
            for model in dataArray {
                for childModel in model.subTitles {
                    if childModel.iD != viewModel.iD {
                        childModel.selected = false
                    }
                }
            }
            selectedArray.append(viewModel)

            print(selectedArray)
            
        } else {
            if let index = selectedArray.firstIndex(of: viewModel) {
                selectedArray.remove(at: index)
            }
        }
       
        
        // 2. 单个分区单选，其它分区也可选中
//        if viewModel.selected == true {
//            // 其它 cell 设置为未选中状态
//            for model in dataArray {
//                for childModel in model.subTitles {
//
//                    // 只在当前分区里刷新数据
//                    if childModel.section == viewModel.section {
//
//                        if childModel.iD != viewModel.iD {
//                            childModel.selected = false
//
//                            // 删除当前model
//                            if let index = selectedArray.firstIndex(of: childModel) {
//                                selectedArray.remove(at: index)
//                            }
//                        }
//
//                    }
//
//                }
//            }
//            selectedArray.append(viewModel)
//
//            print(selectedArray)
//
//            reloadData()
//        } else {
//            if let index = selectedArray.firstIndex(of: viewModel) {
//                selectedArray.remove(at: index)
//            }
//        }
        
        
        // 3. 多选
//        if viewModel.selected == true {
//            selectedArray.append(viewModel)
//        } else {
//            if let index = selectedArray.firstIndex(of: viewModel) {
//                selectedArray.remove(at: index)
//            }
//        }


        selectResultClosure?(selectedArray)
    }
    
}
