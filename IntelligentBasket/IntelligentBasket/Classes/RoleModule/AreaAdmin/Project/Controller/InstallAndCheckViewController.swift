//
//  InstallAndCheckViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/22.
//  Copyright © 2019 zhineng. All rights reserved.
//

/*
 * “安装审核”标签页
 */

import UIKit

class InstallAndCheckViewController: RefreshBaseViewController {

    override func viewDidLoad() {
        let itemSizeH = kScreenH - kStatusBarH - getNavigationBarH() - kPageMenuH -  (tabBarController?.tabBar.frame.height ?? 0)
        setItemSizeH(itemSizeH: itemSizeH)
        //registerCollectionViewCell(nibName: "BasketCollectionCell", identifier: kRefreshCellIID)
        registerCollectoinViewCell(cellClass: testView.self)
        super.viewDidLoad()
    }
    
    
    
    

}

class testView: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let label = UILabel()
        label.text = "hhhhh"
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
