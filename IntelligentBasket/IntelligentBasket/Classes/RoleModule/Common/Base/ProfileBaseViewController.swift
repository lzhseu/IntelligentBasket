//
//  ProfileBaseViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/22.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class ProfileBaseViewController: RoleBaseViewController {
    
    // MARK: - 懒加载属性
    private lazy var profileBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private lazy var praiseView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    

}
