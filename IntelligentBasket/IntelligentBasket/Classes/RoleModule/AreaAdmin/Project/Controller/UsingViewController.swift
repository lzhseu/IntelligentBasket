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
private let kItemMargin: CGFloat = 5
private let kCellID = "kCellID"

class UsingViewController: RoleBaseViewController {
    
    private lazy var collectioView: UICollectionView = { [unowned self] in
        /// 创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        /// 创建UICollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "BasketCollectionCell", bundle: nil), forCellWithReuseIdentifier: kCellID)
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectioView)
    }
    
    
    

}


// MARK: - 请求和加载网络数据
extension UsingViewController {
    
    private func loadData() {
        
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension UsingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellID, for: indexPath) as! BasketCollectionCell
        return cell
    }
    
    
}
