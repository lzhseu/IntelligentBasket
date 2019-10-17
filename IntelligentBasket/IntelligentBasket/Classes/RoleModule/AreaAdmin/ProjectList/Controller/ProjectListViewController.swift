//
//  ProjectListViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/10/17.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import SnapKit
import SideMenu

class ProjectListViewController: BaseViewController {
    
    // MARK: - 懒加载属性
    private lazy var sideMenuViewController = SideMenuViewController()

    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        makeConstraints()
        setSideMenu()
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 重新父类方法
    override func setUI() {
        setNavigationBar(title: "")
        view.backgroundColor = contentBgColor
    }
    
    override func setNavigationBar(title: String?) {
        super.setNavigationBar(title: title)
        let btn = UIButton()
        btn.setTitle("项目", for: .normal )
        btn.titleLabel?.font = UIFont.systemFont(ofSize: kNavigationTitleFontSize)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        let moreItem = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(moreBtnClick))
        navigationItem.rightBarButtonItem = moreItem
    }
}


// MARK: - 侧边栏
extension ProjectListViewController {
    func setSideMenu() {
        sideMenuViewController = UIStoryboard(name: "SideMenu", bundle: nil).instantiateViewController(withIdentifier: "menuView") as! SideMenuViewController
        sideMenuViewController.delegate = self
        let sideMenu = UISideMenuNavigationController(rootViewController: sideMenuViewController)
        sideMenu.isNavigationBarHidden = true                            //隐藏导航栏
        SideMenuManager.default.menuFadeStatusBar = false                //阻止状态栏背景变黑
        SideMenuManager.default.menuShadowColor = .black                 //阴影颜色
        SideMenuManager.default.menuShadowRadius = 25                    //阴影距离
        SideMenuManager.default.menuRightNavigationController = sideMenu //将其作为默认的右侧菜单
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        let screenWidth = UIScreen.main.bounds.width                     // 屏幕宽度
        let screenHeight = UIScreen.main.bounds.height                   // 屏幕高度
        SideMenuManager.default.menuWidth = round(min(screenWidth, screenHeight) * 0.7)
        SideMenuManager.default.menuAnimationTransformScaleFactor = 0.9
        SideMenuManager.default.menuAnimationBackgroundColor = primaryColor_0_5
    }
}


// MARK: - 侧边栏代理
extension ProjectListViewController: SideMenuViewControllerDelegate {
    
    func sideMenuViewController(selected projectId: String) {
        //
    }
}


// MARK: - 事件监听函数
extension ProjectListViewController {
    @objc func moreBtnClick() {
        self.present(SideMenuManager.default.menuRightNavigationController!, animated: true,
                     completion: nil)
    }
}



// MARK: - 网络请求
extension ProjectListViewController {
    private func loadData(){
        // TODO: 网络请求
    }
}
