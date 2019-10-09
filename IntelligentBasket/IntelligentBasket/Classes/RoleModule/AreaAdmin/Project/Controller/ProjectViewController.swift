//
//  ProjectViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/20.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import SnapKit
import SPPageMenu
import SideMenu


class ProjectViewController: BaseViewController {
    
    // MARK: - 自定义属性
    let titles = ["进度", "待安装", "安装审核", "使用中", "待报停", "报停审核"]

    // MARK: - 懒加载属性
    private lazy var scrollView: UIScrollView = { [weak self] in
        
        let kTabBarH = self!.tabBarController?.tabBar.frame.height ?? 0
        let frameH: CGFloat = kScreenH - kStatusBarH - getNavigationBarH() - kPageMenuH - kTabBarH
        let frame = CGRect(x: 0, y: kPageMenuH, width: kScreenW, height: frameH)
        let scrollView = UIScrollView(frame: frame)
        //scrollView.delegate = self
        scrollView.isPagingEnabled = true;
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false;
        scrollView.backgroundColor = contentBgColor
        scrollView.contentSize = CGSize(width: kScreenW * CGFloat(self!.titles.count), height: scrollView.bounds.height)
        return scrollView
    }()
    
    private lazy var pageMenu: SPPageMenu = { [weak self] in
        let frame = CGRect(x: 0, y: 0, width: kScreenW, height: kPageMenuH)
        let pageMenu = SPPageMenu(frame: frame, trackerStyle: .line)
        pageMenu.setItems(self!.titles, selectedItemIndex: 0)
        pageMenu.selectedItemTitleColor = pageMenuSelectColor
        pageMenu.unSelectedItemTitleColor = pageMenuNormalColor
        pageMenu.delegate = self
        pageMenu.bridgeScrollView = self!.scrollView
        pageMenu.tracker.backgroundColor = primaryColor
        pageMenu.selectedItemIndex = 3   //配置第一个显示的选项卡
        return pageMenu
    }()
    
    private lazy var sideMenuViewController = SideMenuViewController()
    
    private lazy var childVcs = [BaseViewController]()               //子控制器
    
    private lazy var projectVM = ProjectViewModel()                  //project的VM，现在用于处理网络请求
    
    private lazy var currentProject = ProjectModel()                 //当前项目
    


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
        view.addSubview(pageMenu)
        view.addSubview(scrollView)
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
extension ProjectViewController {
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

// MARK: - 事件监听函数
extension ProjectViewController {
    
    @objc func moreBtnClick() {
        self.present(SideMenuManager.default.menuRightNavigationController!, animated: true,
                     completion: nil)
    }
}

// MARK: - 实现 SPPageMenuDelegate 代理方法
extension ProjectViewController: SPPageMenuDelegate {

    func pageMenu(_ pageMenu: SPPageMenu, itemSelectedFrom fromIndex: Int, to toIndex: Int) {

        if !scrollView.isDragging { // 判断用户是否在拖拽scrollView
            // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
            if(labs(toIndex - fromIndex) >= 2) {
                scrollView.setContentOffset(CGPoint(x: kScreenW * CGFloat(toIndex), y: 0), animated: false)
            } else {
                scrollView.setContentOffset(CGPoint(x: kScreenW * CGFloat(toIndex), y: 0), animated: true)
            }
        }
    }
}

// MARK: - 添加子控制器
extension ProjectViewController {
    private func addChildVcs(projectId: String?) {
        // TODO: 把子控制器加在此处
        /*
        var vc = RoleBaseViewController()
        vc = UsingViewController(projectId: projectId)
        addChild(vc)
        childVcs.append(vc)
        scrollView.addSubview(vc.view)
        vc.view.frame = CGRect(x: 0, y: 0, width: kScreenW, height: scrollView.frame.height)
        
        vc = BasketDetailViewController(deviceId: "")
        addChild(vc)
        childVcs.append(vc)
        scrollView.addSubview(vc.view)
        vc.view.frame = CGRect(x: kScreenW, y: 0, width: kScreenW, height: scrollView.frame.height)
        
        vc = InstallAndCheckViewController()
        addChild(vc)
        childVcs.append(vc)
        scrollView.addSubview(vc.view)
        vc.view.frame = CGRect(x: kScreenW * 2, y: 0, width: kScreenW, height: scrollView.frame.height)
        
        for index in 3..<titles.count {
            let vc = BaseViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            
            addChild(vc)
            childVcs.append(vc)
            
            scrollView.addSubview(vc.view)
            vc.view.frame = CGRect(x: CGFloat(index) * kScreenW, y: 0, width: kScreenW, height: scrollView.frame.height)
        }
        */
        for index in 0..<titles.count {
            var vc = BaseViewController()
            if index == 3 {
                vc = UsingViewController(projectId: projectId)
                addChild(vc)
                childVcs.append(vc)
                scrollView.addSubview(vc.view)
                vc.view.frame = CGRect(x: CGFloat(index) * kScreenW, y: 0, width: kScreenW, height: scrollView.frame.height)
            } else {
                vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
                
                addChild(vc)
                childVcs.append(vc)
                
                scrollView.addSubview(vc.view)
                vc.view.frame = CGRect(x: CGFloat(index) * kScreenW, y: 0, width: kScreenW, height: scrollView.frame.height)
            }
        }
        
        /// 显示第一个视图
        if pageMenu.selectedItemIndex < childVcs.count {
            scrollView.contentOffset = CGPoint(x: CGFloat(pageMenu.selectedItemIndex) * kScreenW, y: 0)
        }
    }
}

// MARK: - 网络请求数据
extension ProjectViewController {
    
    private func loadData() {
        let userId = UserDefaultStorage.getUserId() ?? ""
        projectVM.requestAllProject(userId: userId, viewController: self, finishedCallBack: {
            /// 拿到数据
            let projectGroup = self.projectVM.projectGroup
            
            /// 拿到当前项目名称
            /// 若系统中存在当前项目
            var isFound = false
            if let currentProjectId = UserDefaultStorage.getCurrentProjectId() {
                for project in projectGroup {
                    if project.projectId == currentProjectId {
                        /// 若请求的数据中也有当前项目，则显示当前项目
                        self.currentProject = project
                        isFound = true
                        break
                    }
                }
            } else {
                /// 若不存在当前项目
                isFound = false
            }
            
            if !isFound {
                if projectGroup.count > 0 {
                    self.currentProject = projectGroup[0]  /// 使用请求到的数据的第一个作为当前项目
                    UserDefaultStorage.storeCurrentProjectId(projectId: self.currentProject.projectId!)
                }
            }
            
            /// 设置导航栏标题
            if let projectName = self.currentProject.projectName {
                self.setNavigationBarTitle(title: projectName)
            } else {
                self.setNavigationBarTitle(title: "暂无项目")
            }
            
            /// 设置侧边栏项目
            self.sideMenuViewController.setProjectGroup(projectGroup: projectGroup)
            self.sideMenuViewController.setUserId(userId: userId)
            
            /// 添加子控制器
            self.addChildVcs(projectId: self.currentProject.projectId)
            
        }) {
            self.view.showTip(tip: kNetWorkErrorTip, position: .bottomCenter)
        }
    }
}


// MARK: - 切换项目
extension ProjectViewController: SideMenuViewControllerDelegate {
    
    func sideMenuViewController(selected projectId: String) {
        if projectId == currentProject.projectId! {
            let vc = UIStoryboard(name: "ProjectDetail", bundle: nil).instantiateViewController(withIdentifier: "projectDetail") as! ProjectDetailViewController
            vc.projectId = projectId
            pushViewController(viewController: vc, animated: true)
        } else {
            
            /// 1.把之前的子控制器移除
            for childVc in childVcs {
                childVc.removeFromParent()
            }
            childVcs = []
            
            /// 2.加入新的控制器
            addChildVcs(projectId: projectId)
            
            /// 3.重新储存当前项目ID
            UserDefaultStorage.storeCurrentProjectId(projectId: projectId)
            for project in projectVM.projectGroup {
                if project.projectId == projectId {
                    currentProject = project
                    break
                }
            }
            
            /// 4. 修改导航栏标题
            if let projectName = self.currentProject.projectName {
                self.setNavigationBarTitle(title: projectName)
            } else {
                self.setNavigationBarTitle(title: "项目名")
            }
        }
    }
    
}
