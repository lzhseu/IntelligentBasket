//
//  PhotoViewCell.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/27.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    var image: String? {
        didSet {
            imageView.image = UIImage(named: image!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.white
    }

}
