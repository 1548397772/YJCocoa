//
//  YJUIPageViewCell.swift
//  YJCocoa
//
//  HomePage:https://github.com/937447974/YJCocoa
//  YJ技术支持群:557445088
//
//  Created by 阳君 on 2019/5/24.
//  Copyright © 2016-现在 YJCocoa. All rights reserved.
//

import UIKit

/// 点击cell的回调
typealias YJUIPageViewCellDidAppear = (_ index: Int) -> Void

/// PageView 的 cell 基类
@objcMembers
open class YJUIPageViewCell: UIViewController {
    
    public private(set) var cellObject: YJUIPageViewCellObject!
    public private(set) var pageViewManager: YJUIPageViewManager!
    var cellDidAppear: YJUIPageViewCellDidAppear!
    
    // MARK: override
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.cellDidAppear(self.cellObject.index)
    }
    
    // MARK: YJCocoa
    /// 获取 YJUITableCellObject
    public class func cellObject() -> YJUIPageViewCellObject {
        return YJUIPageViewCellObject(cellClass: self)
    }
    
    /// 获取 YJUITableCellObject 并自动填充模型
    public class func cellObject(withCellModel cellModel:AnyObject) -> YJUIPageViewCellObject {
        let co = self.cellObject()
        co.cellModel = cellModel
        return co
    }
    
    /// 刷新 UITableViewCell
    open func pageViewManager(_ pageViewManager: YJUIPageViewManager, reloadWith cellObject: YJUIPageViewCellObject) {
        self.pageViewManager = pageViewManager
        self.cellObject = cellObject
    }
    
}
