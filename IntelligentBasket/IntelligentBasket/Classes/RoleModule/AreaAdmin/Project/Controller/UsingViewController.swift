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
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        setItemSizeH(itemSizeH: kItemH)
        registerCollectionViewCell(nibName: "BasketCollectionCell")
        super.viewDidLoad()
        //view.addSubview(collectioView)
        setRefreshFooter()
    }
}


// MARK: - 请求和加载网络数据
extension UsingViewController {
    
    private func loadData() {
        
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension UsingViewController  {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRefreshCellIID, for: indexPath) as! BasketCollectionCell
        return cell
    }
    
    
}
