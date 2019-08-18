//
//  BaseViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/18.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setUI() {
        setNavigationBar(title: nil)
    }
    
    func setNavigationBar(title: String?) {
        navigationItem.title = title
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = primaryColor
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22), NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func setNavigationBarTitle(title: String?) {
        navigationItem.title = title
    }
    
    func makeConstraints() {
        
    }
    
    /// 控件正常的颜色
    func normalViewColor(view: UIView) {
        view.backgroundColor = primaryColor
    }
    
    /// 控件点击时的颜色
    func clickViewColor(view: UIView) {
        view.backgroundColor = primaryColor_0_8
    }
    
    /// 控件禁用时的颜色
    func disabledViewColor(view: UIView) {
        
    }
    
}
