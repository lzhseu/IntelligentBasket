//
//  UsingViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/22.
//  Copyright © 2019 zhineng. All rights reserved.
//

/*
 * “使用中”标签页所对应的控制器
 */

import UIKit

private let kItemW = kScreenW
private let kItemH: CGFloat = kItemW / 3

class UsingViewController: RefreshBaseViewController {
    
    // MARK: - 自定义属性
    var projectId: String?
    
    // MARK: - 懒加载属性
    private lazy var usingBasketVM = UsingBasketViewModel()
    
    private lazy var usingBasketGroup = [UsingBasketModel]()
    
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        /// 注册cell
        setItemSizeH(itemSizeH: kItemH)
        registerCollectionViewCell(nibName: "BasketCollectionCell")
        
        /// 加载页面
        super.viewDidLoad()
        
        /// 请求数据
        loadData(isRefresh: false)
    }
    
    init(projectId: String?) {
        super.init(nibName: nil, bundle: nil)
        self.projectId = projectId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - 请求和加载网络数据
extension UsingViewController {
    
    private func loadData(isRefresh: Bool) {
        
        guard let projectId = projectId else {
            //self.view.showTip(tip: "百胜吊篮：获取不到项目ID", position: .bottomCenter)
            self.LoadNoBasketPage()
            return
        }
        
        usingBasketVM.requestAllBasket(projectId: projectId, viewController: self, finishedCallBack: {
            ///拿到数据
            self.usingBasketGroup = self.usingBasketVM.usingBasketGroup
            
            if self.usingBasketGroup.count == 0 {
                self.LoadNoBasketPage()
            } else {
                self.removeNoBasketPage()
            }
            
            /// 刷新表格数据
            self.collectionView.reloadData()
            
            if isRefresh {
                self.headerEndRefreshing()  //如果是刷新数据（不是第一次请求），那么刷新后要手动停止刷新
            }
        }) {
            self.view.showTip(tip: kNetWorkErrorTip, position: .bottomCenter)
        }
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension UsingViewController  {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usingBasketGroup.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRefreshCellIID, for: indexPath) as! BasketCollectionCell        
        cell.usingBasketModel = usingBasketGroup[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let deviceId = usingBasketGroup[indexPath.item].deviceId
        navigationController?.pushViewController(BasketDetailViewController(deviceId: deviceId), animated: true)
    }
    
}


// MARK: - 事件监听函数
extension UsingViewController {
    /// 下拉刷新
    override func headerRefresh() {
        loadData(isRefresh: true)
    }
}
