//
//  ProfileViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/20.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var logoutItem: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoutItemTapped)))
    }
    
    override func setUI() {
        setNavigationBar(title: "")
        view.backgroundColor = contentBgColor
    }
    
}

// MARK: - 事件监听函数
extension ProfileViewController {
    
    @objc private func logoutItemTapped() {
        UserDefaultStorage.removeToken()
        self.dismiss(animated: false, completion: nil)
    }
}
