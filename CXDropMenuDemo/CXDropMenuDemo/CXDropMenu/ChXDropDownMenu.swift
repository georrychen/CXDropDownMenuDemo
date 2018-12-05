//
//  ChXDropDownMenu.swift
//  ChXDropdownMenuDemo
//
//  Created by Xu Chen on 2018/10/29.
//  Copyright © 2018 xu.yzl. All rights reserved.
//  下拉筛选菜单


import UIKit

private let kScreenWidth = UIScreen.main.bounds.width
private let kScreenHeight = UIScreen.main.bounds.height
private let kScreenScale = UIScreen.main.scale

private let kAnimationDuration = 0.2

class ChXDropDownMenu: UIView {
   
    /// 配置信息类
    private var configuration = ChXDropDownMenuConfiguration()

    /// 菜单起点
    private var menuOrigin = CGPoint(x: 0, y: 0)
    /// 菜单高度
    private var menuHeight: CGFloat = 0.0
    /// 菜单宽度
    private var menuWidth: CGFloat = 0.0
    /// 菜单列数
    private var numberOfColumn = 0
    
    /// 标题 layer 数组
    private var currentTitleLayers = [CATextLayer]()
    /// 箭头 layer 数组
    private var currentIndicatorLayers = [CAShapeLayer]()
    /// 背景 layer
    private var currentBgLayers = [CALayer]()
    
    /// 显示的列表数组
    private var currrentListViews = [UIView]()
    /// 显示的列表的高度数组
    private var currrentListViewsHeight = [CGFloat]()

    /// 当前选中的列
    private var currentSelectedColumn = -1
    /// 是否展开
    private var isShow: Bool = false
 
    /// 数据源
    @objc var dataSource: ChXDropDownMenuDataSource? {
        didSet {
            configureDatas(with: dataSource!)
        }
    }
    
    /// 底部分割线
    private lazy var bottomLine: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: menuHeight - (1 / kScreenScale), width: kScreenWidth, height: 1 / kScreenScale))
        view.backgroundColor = self.configuration.separatorColor
        return view
    }()
    
    /// 透明背景图
    private lazy var backGroundView: UIView = {
        let view = UIView(frame: CGRect(x: menuOrigin.x, y: menuOrigin.y, width: kScreenWidth, height: kScreenHeight))
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        view.isOpaque = false
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backTapped(sender:))))
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 初始化数据
    func initData() {
        backgroundColor = UIColor.white
        
        // 设置 menu 尺寸
        menuHeight = frame.height
        menuWidth = frame.width
        menuOrigin = frame.origin
        
        // 整体菜单view 添加点击手势
        let menuTapGesture = UITapGestureRecognizer(target: self, action: #selector(menuTapped))
        self.addGestureRecognizer(menuTapGesture)
    }
}


// MARK: - 创建 UI
extension ChXDropDownMenu {
    
    /// 配置数据
    private func configureDatas(with dataSource: ChXDropDownMenuDataSource) {
        // 获取一共有多少列
        numberOfColumn = dataSource.chx_numberOfColumnsInDropDownMenu(self)
        // 每列宽度
        let backgroundLayerWidth = kScreenWidth / CGFloat(numberOfColumn)
        
        currentBgLayers.removeAll()
        currentTitleLayers.removeAll()
        currentBgLayers.removeAll()
        
        // 绘制菜单
        for i in 0 ..< numberOfColumn {
            let index = CGFloat(i)
            
            // 1. backgroundLayer - 背景layer
            let backgroundLayerPosition = CGPoint(x: (index + 0.5) * backgroundLayerWidth, y: menuHeight * 0.5)
            let backgroundLayer = creatBackgroundLayer(position: backgroundLayerPosition, backgroundColor: UIColor.white)
            layer.addSublayer(backgroundLayer)
            currentBgLayers.append(backgroundLayer)
            
            // 2. titleLayer - 标题layer
            let titleStr = dataSource.chx_dropDownMenu(self, titleInColumn: i)
            let titleLayerPosition = CGPoint(x: (index + 0.5) * backgroundLayerWidth, y: menuHeight * 0.5)
            let titleLayer = creatTitleLayer(text: titleStr, position: titleLayerPosition, textColor: self.configuration.menuTitleColor)
            layer.addSublayer(titleLayer)
            currentTitleLayers.append(titleLayer)
            
            // 3. indicatorLayer - 箭头layer
            let textSize = calculateStringSize(titleStr)
            let indicatorLayerPosition = CGPoint(x: titleLayerPosition.x + (textSize.width / 2) + 10, y: menuHeight / 2 + 2)
            let indicatorLayer = creatIndicatorLayer(position: indicatorLayerPosition, color: self.configuration.menuTitleColor)
            layer.addSublayer(indicatorLayer)
            currentIndicatorLayers.append(indicatorLayer)
            
            // 4. separatorLayer - 竖直分割线layer
            if i != numberOfColumn - 1 {
                let separatorLayerPosition = CGPoint(x: ceil((index + 1) * backgroundLayerWidth) - 1, y: menuHeight / 2)
                let separatorLayer = creatSeparatorLayer(position: separatorLayerPosition, color: self.configuration.separatorColor)
                layer.addSublayer(separatorLayer)
            }
    
            // 5. currrentListViews - 显示的列表
            let view = dataSource.chx_dropDownmenu(self, viewInColumn: i)
            currrentListViews.append(view)
            
            // 6. currrentListViewsHeight - 要显示列表视图的源高度
            let viewHeight = dataSource.chx_dropDownmenu(self, heightInColumn: i)
            currrentListViewsHeight.append(viewHeight)
        }
        addSubview(bottomLine)
    }
    
    /// 标题背景 layer
    func creatBackgroundLayer(position: CGPoint, backgroundColor: UIColor) -> CALayer {
        let layer = CALayer()
        layer.position = position
        layer.backgroundColor = backgroundColor.cgColor
        layer.bounds = CGRect(x: 0, y: 0, width: kScreenWidth / CGFloat(numberOfColumn), height: menuHeight - 1)
        return layer
    }
    
    /// 标题Layer
    func creatTitleLayer(text: String, position: CGPoint, textColor: UIColor) -> CATextLayer {
        // size
        let textSize = calculateStringSize(text)
        let maxWidth = kScreenWidth / CGFloat(numberOfColumn) - 25
        let textLayerWidth = (textSize.width < maxWidth) ? textSize.width : maxWidth
        // textLayer
        let textLayer = CATextLayer()
        textLayer.bounds = CGRect(x: 0, y: 0, width: textLayerWidth, height: textSize.height)
        textLayer.fontSize = self.configuration.fontSize
        textLayer.string = text
        textLayer.alignmentMode = .center
        textLayer.truncationMode = .end
        textLayer.foregroundColor = textColor.cgColor
        textLayer.contentsScale = kScreenScale
        textLayer.position = position
        return textLayer
    }
    
    ///箭头
    func creatIndicatorLayer(position: CGPoint, color: UIColor) -> CAShapeLayer {
        // path
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: 5, y: 5))
        bezierPath.move(to: CGPoint(x: 5, y: 5))
        bezierPath.addLine(to: CGPoint(x: 10, y: 0))
        bezierPath.close()
        // shapeLayer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.lineWidth = 0.8
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.bounds = shapeLayer.path!.boundingBox
        shapeLayer.position = position
        return shapeLayer
    }
    
    /// 竖直分割线
    func creatSeparatorLayer(position: CGPoint, color: UIColor) -> CAShapeLayer {
        // path
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 4))
        bezierPath.addLine(to: CGPoint(x: 0, y: menuHeight - 20))
        bezierPath.close()
        
        // separatorLayer
        let separatorLayer = CAShapeLayer()
        separatorLayer.path = bezierPath.cgPath
        separatorLayer.strokeColor = color.cgColor
        separatorLayer.lineWidth = 0.5
        separatorLayer.bounds = separatorLayer.path!.boundingBox
        separatorLayer.position = position
        return separatorLayer
    }
    
    /// 计算文字的尺寸
    func calculateStringSize(_ string: String) -> CGSize {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: self.configuration.fontSize)]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let size = string.boundingRect(with: CGSize(width: 280, height: 0), options: option, attributes: attributes, context: nil).size
        return CGSize(width: ceil(size.width) + 2, height: size.height)
    }
    
}


// MARK: - 响应事件
extension ChXDropDownMenu {
    
    /// 设置选中的文字
   @objc func setSelectedTitle(text: String) {
        let titleLayer = currentTitleLayers[currentSelectedColumn]
        titleLayer.string = text
        animateFor(titleLayer: titleLayer, indicator: currentIndicatorLayers[currentSelectedColumn], show: true) {
        }
    }
    
    /// 收回menu - 供外部调用
   @objc func hideMenu() {
        animateFor(all: currentIndicatorLayers[currentSelectedColumn], title: currentTitleLayers[currentSelectedColumn], show: false) {
            isShow = false
        }
    }
    
    /// 点击透明背景图
    @objc private func backTapped(sender: UITapGestureRecognizer) {
        // 收回menu
        animateFor(all: currentIndicatorLayers[currentSelectedColumn], title: currentTitleLayers[currentSelectedColumn], show: false) {
            isShow = false
        }
    }
    
    /// 点击菜单
    @objc func menuTapped(sender: UITapGestureRecognizer) -> Void {
        // 1. 后去点击点位置，和点击的行号，点击的 index ， x/（屏幕宽度/几等分）： 先计算出每个等分的宽度，再用点击点的x除以这个等分宽度
        let tapPoint = sender.location(in: self)
        let tapIndex: Int = Int(tapPoint.x / (kScreenWidth / CGFloat(numberOfColumn)))
//        print("点击点位置 \(tapPoint), 点击index = \(tapIndex)")

        // 2. 收起其它列的 menu
        for index in 0..<numberOfColumn {
            if index != tapIndex {
                // 收起 箭头指示符和其它页面菜单
                animateFor(indicator: currentIndicatorLayers[index], reverse: false) {
                    animateFor(titleLayer: currentTitleLayers[index], indicator: nil, show: false, completion: {
                        animatelListShowView(show: false, index, complete: {
                            print("收起菜单")
                        })
                        
                    })
                }
            }
        }
        
        // 3. 弹出当前的列对应的 menu
        if currentSelectedColumn == tapIndex && isShow {
            // 收回menu
            animateFor(all: currentIndicatorLayers[tapIndex], title: currentTitleLayers[tapIndex], show: false) {
                 isShow = false
            }

        } else {
            // 弹出 menu
            currentSelectedColumn = tapIndex
            animateFor(all: currentIndicatorLayers[currentSelectedColumn], title: currentTitleLayers[currentSelectedColumn], show: true) {
                isShow = true
            }
        }

    }
    
}


// FIXME: chenxu -  更改标题文字的方法

//// MARK: - 表格代理方法 ChXDropMenuTableViewDelegate
//extension ChXDropDownMenu {
//
//    func chx_dropMenuTableViewDidSelected(title: String) {
//
//        let titleLayer = currentTitleLayers[currentSelectedColumn]
//        titleLayer.string = title
//        animateFor(titleLayer: titleLayer, indicator: currentIndicatorLayers[currentSelectedColumn], show: true) {
//        }

//        // 收回menu
//        animateFor(indicator: currentIndicatorLayers[currentSelectedColumn], title: currentTitleLayers[currentSelectedColumn], show: false, style: currentDropMenuStyle) {
//            isShow = false
//        }
//
//        delegate?.chxDropDownMenu(self, didSelectRowAtIndexPath: title)
//
//    }
//
//}


// MARK: - 动画相关
extension ChXDropDownMenu {
    
    /// 整体动画
    func animateFor(all indicator: CAShapeLayer, title: CATextLayer, show: Bool, complete: ()->Void) {
        // 1. 箭头动画
        animateFor(indicator: indicator, reverse: show) {
            // 2. 标题动画
            animateFor(titleLayer: title, indicator: indicator, show: show, completion: {
               // 3. 背景图动画
                animateForBackgroundView(show: show, complete: {
                    // 4. 列表视图动画
                    animatelListShowView(show: show, currentSelectedColumn, complete: {
                        print("收缩/展开菜单")
                    })
                })
            })
        }
     
        complete()
    }
    
    /// 箭头指示符旋转动画
    func animateFor(indicator: CAShapeLayer, reverse: Bool, complete: () -> Void) -> Void {
        if reverse {
            indicator.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1)
            indicator.strokeColor = self.configuration.seletedMenuTitleColor.cgColor
        } else {
            indicator.transform = CATransform3DIdentity
            indicator.strokeColor = self.configuration.menuTitleColor.cgColor
        }
        complete()
    }
    
    /// 标题动画
    func animateFor(titleLayer textLayer: CATextLayer, indicator: CAShapeLayer?, show: Bool, completion: ()->Void) -> Void {
        // 重新计算 文字 的尺寸
        let textSize = calculateStringSize((textLayer.string as! String?) ?? "")
        let maxWidth = kScreenWidth / CGFloat(numberOfColumn) - 25
        let textLayerWidth = (textSize.width < maxWidth) ? textSize.width : maxWidth
        
        textLayer.bounds.size.width = textLayerWidth
        textLayer.bounds.size.height = textSize.height
        
        if let indicatorR = indicator {
            indicatorR.position.x = textLayer.position.x + textLayerWidth / 2 + 10
        }
        
        if show {
            textLayer.foregroundColor = self.configuration.seletedMenuTitleColor.cgColor
        } else {
            textLayer.foregroundColor = self.configuration.menuTitleColor.cgColor
        }
        completion()
    }
    
    /// 背景图动画
    func animateForBackgroundView(show: Bool, complete: ()->Void) -> Void {
        if show {
            superview?.addSubview(backGroundView)
            superview?.addSubview(self)
            
            UIView.animate(withDuration: kAnimationDuration) {
                self.backGroundView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            }
        } else {
            UIView.animate(withDuration: kAnimationDuration, animations: {
                self.backGroundView.backgroundColor = UIColor(white: 0, alpha: 0)
            }) { (finished) in
                if finished {
                    self.backGroundView.removeFromSuperview()
                }
            }
        }
        
        complete()
    }
    
    /// 显示列表视图动画
    func animatelListShowView(show: Bool, _ viewIndex: Int = 0, complete: ()->Void) -> Void {
        // 首次进来时，不显示菜单
        if currentSelectedColumn < 0 {
            return
        }
        
        // 1. 当前显示的 视图
        let showView = currrentListViews[viewIndex]
        let originHeight = currrentListViewsHeight[viewIndex]
        
//        print("显示列表高度： \(originHeight)")
        
        // 2. 动画展示\收起
        if show {
            // 展开
            
            showView.frame = CGRect(x: 0, y: menuOrigin.y + menuHeight, width: kScreenWidth, height: 0)
            superview?.addSubview(showView)

            UIView.animate(withDuration: 0.8,
                           delay: 0.1,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 1,
                           options: .curveEaseInOut,
                           animations: {
                        showView.frame.size.height = originHeight + 20
            }, completion: nil)
        }else {
            
            // 收起
            UIView.animate(withDuration: 0.2, animations: {
                showView.frame.size.height = 0
            }, completion: { (finished) in
                showView.removeFromSuperview()
            })
        }
        
        complete()
    }
    
}




