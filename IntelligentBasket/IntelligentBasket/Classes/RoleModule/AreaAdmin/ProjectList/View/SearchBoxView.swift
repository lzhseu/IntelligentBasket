//
//  SearchBoxView.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/10/20.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class SearchBoxView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = []
        
    }

}

// MARK: - 提供快速创建的类方法
extension SearchBoxView {
    class func searchBoxView() -> SearchBoxView{
        return Bundle.main.loadNibNamed("SearchBoxView", owner: nil, options: nil)?.first as! SearchBoxView
    }
}
