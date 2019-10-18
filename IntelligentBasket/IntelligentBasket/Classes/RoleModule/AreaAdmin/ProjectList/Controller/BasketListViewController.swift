//
//  BasketListViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/10/17.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

private let kItemW = kScreenW
private let kItemH: CGFloat = kItemW / 3 + 10

class BasketListViewController: RefreshBaseViewController {

    // MARK: - 自定义属性
    var projectId: String?
    
    // MARK: - 懒加载属性
    private lazy var usingBasketVM = UsingBasketViewModel()
    
    private lazy var usingBasketGroup = [UsingBasketModel]()
    
    
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        /// 注册cell
        setItemSizeH(itemSizeH: kItemH)
        registerCollectionViewCell(nibName: "BasketListViewCell")
        
        /// 加载页面
        super.viewDidLoad()
        
        // 设置上拉刷新
        setRefreshFooter()
        
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


// MARK: - 请求网络数据
extension BasketListViewController {
    private func loadData(isRefresh: Bool) {
        
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension BasketListViewController  {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return usingBasketGroup.count
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRefreshCellIID, for: indexPath) as! BasketListViewCell
        //cell.usingBasketModel = usingBasketGroup[indexPath.item]
        cell.superController = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        //let deviceId = usingBasketGroup[indexPath.item].deviceId
        //navigationController?.pushViewController(BasketDetailViewController(deviceId: deviceId), animated: true)
    }
    
}


// MARK: - 事件监听函数
extension BasketListViewController {
    /// 下拉刷新
    override func headerRefresh() {
        loadData(isRefresh: true)
    }
    
    /// 上拉刷新
    override func footerRefresh() {
        loadData(isRefresh: true)
    }
}
