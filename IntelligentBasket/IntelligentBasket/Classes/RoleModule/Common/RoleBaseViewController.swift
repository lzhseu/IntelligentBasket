//
//  RoleBaseViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/22.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import SnapKit

private let NoBasketImageName = "ic_no_avaliable_basket"
private let kNoBaksetImageViewWH: CGFloat = 64
let kNoBasketPageViewTag: Int = 11404

class RoleBaseViewController: BaseViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = contentBgColor
    }
    
}

extension RoleBaseViewController{
    
    /// 加载没有吊篮数据页面
    func LoadNoBasketPage(){
        
        removeNoBasketPage() //load 之前最好先 remove 一下
        
        let imageView = CommonViewFactory.createImageView(image: NoBasketImageName)
        let tipLabel = CommonViewFactory.createLabel(title: "您还没有相关的吊篮", font: UIFont.systemFont(ofSize: 16), textColor: normalTitleColor)
        let bgView = UIView()
        bgView.backgroundColor = contentBgColor
        bgView.tag = kNoBasketPageViewTag
        
        view.addSubview(bgView)
        bgView.addSubview(imageView)
        bgView.addSubview(tipLabel)
        
        bgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(90)
            make.width.equalToSuperview()
        }
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(kNoBaksetImageViewWH)
        }
        tipLabel.snp.makeConstraints { (make) in
            make.centerX.bottom.equalToSuperview()
        }
    }
    
    func removeNoBasketPage() {
        let noBasketPageView = view.viewWithTag(kNoBasketPageViewTag)
        noBasketPageView?.removeFromSuperview()
    }
}

