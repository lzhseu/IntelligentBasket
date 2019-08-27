//
//  PhotoBrowserViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/27.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit


class PhotoBrowserViewController: RefreshBaseViewController {
    
    weak var delegate: PhotoBrowserViewCellDelegate?
    
    override func viewDidLoad() {
        
        setItemSizeH(itemSizeH: kScreenH - kStatusBarH - getNavigationBarH())
        registerCollectoinViewCell(cellClass: PhotoBrowserViewCell.self)
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
}

