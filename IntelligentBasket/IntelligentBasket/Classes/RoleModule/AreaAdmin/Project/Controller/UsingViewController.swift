//
//  UsingViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/22.
//  Copyright © 2019 zhineng. All rights reserved.
//

/*
 * “使用中”标签页
 */

import UIKit

private let kItemW = kScreenW
private let kItemH: CGFloat = kItemW / 3

class UsingViewController: RefreshBaseViewController {
    
    // MARK: - 懒加载属性
    private lazy var usingBasketVM = UsingBasketViewModel()
    
    private lazy var currentProject = UsingBasketModel()
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        /// 注册cell
        setItemSizeH(itemSizeH: kItemH)
        registerCollectionViewCell(nibName: "BasketCollectionCell")
        
        /// 加载页面
        super.viewDidLoad()
        
        /// 请求数据
        loadData()
    }
}


// MARK: - 请求和加载网络数据
extension UsingViewController {
    
    private func loadData() {
        let userId = UserDefaultStorage.getUserId() ?? ""
        usingBasketVM.requestAllProject(userId: userId, viewController: self, finishedCallBack: {
            /// 拿到数据
            let modelGroup = self.usingBasketVM.usingBasketGroup
            
            /// 拿到当前项目名称
            /// 若系统中存在当前项目
            if let currentProjectId = UserDefaultStorage.getCurrentProjectId() {
                for project in modelGroup {
                    if project.projectId == currentProjectId {
                        /// 若请求的数据中也有当前项目，则显示当前项目
                        self.currentProject = project
                        break
                    }
                }
            } else {
                /// 若不存在当前项目
                if modelGroup.count > 0 {
                    self.currentProject = modelGroup[0]  /// 使用请求到的数据的第一个作为当前项目
                    UserDefaultStorage.storeCurrentProjectId(projectId: self.currentProject.projectId!)
                }
            }
            
            /// 设置导航栏标题
            let parentVC = self.parent as! ProjectViewController
            parentVC.setNavigationBarTitle(title: self.currentProject.projectName)
            
            /// 刷新表格数据
            self.collectionView.reloadData()
        }) {
            self.view.showTip(tip: kNetWorkErrorTip, position: .bottomCenter)
        }
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension UsingViewController  {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return currentProject.basketNum?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRefreshCellIID, for: indexPath) as! BasketCollectionCell        
        cell.basketNum = currentProject.basketNum?[indexPath.item]
        return cell
    }
    
    
}
