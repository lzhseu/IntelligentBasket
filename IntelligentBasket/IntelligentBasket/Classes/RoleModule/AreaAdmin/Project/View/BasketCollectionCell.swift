//
//  BasketCollectionCell.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/22.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class BasketCollectionCell: UICollectionViewCell {
    
    // MARK: - 控件属性
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var basketNumLabel: UILabel!
    @IBOutlet weak var isUsingLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(singleTapAction)))
        
    }
    
    

    
}

// MARK: - 事件监听函数
extension BasketCollectionCell {
    @objc func singleTapAction() {
        print("tap...")
    }
}
