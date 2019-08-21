//
//  ProjectViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/20.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import SnapKit
import PagingMenuController


class ProjectViewController: BaseViewController {
    
    // MARK: - 自定义属性
    var navTitle = "暂无项目"    // 会动态改变
    let titles = ["进度", "待安装", "安装审核", "使用中", "待报停", "报停审核"]
    
    private struct MenuItem: MenuItemViewCustomizable {
        var titleText = ""
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: titleText))
        }
        
    }

    // MARK: - 懒加载属性

    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        makeConstraints()
    }

    // MARK: - 重新父类方法
    override func setUI() {
        setNavigationBar(title: navTitle)
        view.backgroundColor = contentBgColor
        
        var childVcs = [UIViewController]()
        var menuItems = [MenuItemViewCustomizable]()
        for index in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(vc)
            
            let menuItem = MenuItem(titleText: titles[index])
            menuItems.append(menuItem)
        }
        
        let pageMenuController = PageMenuController.create(childVc: childVcs, menuItems: menuItems)
        addChild(pageMenuController)
        view.addSubview(pageMenuController.view)
        let kTabBarH = self.tabBarController!.tabBar.frame.height
        pageMenuController.view.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kTabBarH)
        }
    }

    override func setNavigationBar(title: String?) {
        super.setNavigationBar(title: title)
        let btn = UIButton()
        btn.setTitle("项目", for: .normal )
        btn.titleLabel?.font = UIFont.systemFont(ofSize: kNavigationTitleSize)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        let moreItem = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(moreBtnClick))
        navigationItem.rightBarButtonItem = moreItem
    }


}


// MARK: - 事件监听函数
extension ProjectViewController {
    
    @objc func moreBtnClick() {
        print("more")
    }
}


