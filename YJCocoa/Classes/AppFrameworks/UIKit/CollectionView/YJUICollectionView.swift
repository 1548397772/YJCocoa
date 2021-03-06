//
//  YJUICollectionView.swift
//  YJCocoa
//
//  HomePage:https://github.com/937447974/YJCocoa
//  YJ技术支持群:557445088
//
//  Created by 阳君 on 2019/5/23.
//  Copyright © 2016-现在 YJCocoa. All rights reserved.
//

import UIKit

@objcMembers
open class YJUICollectionView: UICollectionView {
    
    /// 管理器
    public lazy var manager: YJUICollectionViewManager! = {
        return YJUICollectionViewManager(collectionView: self)
    }()
    /// header 数据源
    public var dataSourceHeader: Array<YJUICollectionCellObject> {
        get {return self.manager.dataSourceHeader}
        set {self.manager.dataSourceHeader = newValue}
    }
    /// footer 数据源
    public var dataSourceFooter: Array<YJUICollectionCellObject> {
        get {return self.manager.dataSourceFooter}
        set {self.manager.dataSourceFooter = newValue}
    }
    /// cell 数据源
    public var dataSourceCell: Array<Array<YJUICollectionCellObject>> {
        get {return self.manager.dataSourceCell}
        set {self.manager.dataSourceCell = newValue}
    }
    /// cell 第一组数据源
    public var dataSourceCellFirst: Array<YJUICollectionCellObject> {
        get {return self.manager.dataSourceCellFirst}
        set {self.manager.dataSourceCellFirst = newValue}
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self.manager
        self.dataSource = self.manager
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
