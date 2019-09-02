//
//  ProjectDetailViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/9/2.
//  Copyright © 2019 zhineng. All rights reserved.
//

/*
 * 点击切换项目时，如果是点击的是当前项目，则显示当前项目的项目详情
 * 此为 项目详情 的控制器
 */

import UIKit

class ProjectDetailViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    override func setUI() {
        setNavigationBar(title: "")
        view.backgroundColor = contentBgColor
    }
}
