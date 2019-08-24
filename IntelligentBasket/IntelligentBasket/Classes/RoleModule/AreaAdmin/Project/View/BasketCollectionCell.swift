//
//  BasketCollectionCell.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/22.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

protocol BasketCollectionCellDelegate: class {
    func BasketCollectionCell(cell: BasketCollectionCell)
}

class BasketCollectionCell: UICollectionViewCell {
    
    // MARK: - 控件属性
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var basketNumLabel: UILabel!
    @IBOutlet weak var isUsingLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    // MARK: - 自定义属性
    weak var delegate: BasketCollectionCellDelegate?
    
    var usingBasketModel: UsingBasketModel? {
        didSet {
            if let workState = usingBasketModel?.workingState {
                switch workState {
                case 0:
                    isUsingLabel.text = "未使用"
                    isUsingLabel.textColor = UIColor.red
                case 1:
                    isUsingLabel.text = "使用中"
                    isUsingLabel.textColor = primaryColor
                default:
                    isUsingLabel.text = "吊篮状态未知"
                    isUsingLabel.textColor = UIColor.yellow
                }
            } else {
                isUsingLabel.text = "吊篮状态未知"
                isUsingLabel.textColor = UIColor.yellow
            }
            basketNumLabel.text = usingBasketModel?.deviceId
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

