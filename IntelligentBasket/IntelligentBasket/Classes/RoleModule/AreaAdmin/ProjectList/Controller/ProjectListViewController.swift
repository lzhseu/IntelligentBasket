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

private let kItemW = kScreenW
private let kItemH: CGFloat = 178  //kItemW / 3 + 40

class ProjectListViewController: RefreshBaseViewController {
    
    // MARK: - 控件属性
    @IBOutlet weak var testBtn: UIButton!
    
    // MARK: - 懒加载属性
    private lazy var sideMenuViewController = MoreInfoViewController()
    
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        /// 注册cell
        setItemSizeH(itemSizeH: kItemH)
        registerCollectionViewCell(nibName: "ProjectListViewCell")
        
        /// 加载页面
        super.viewDidLoad()
        
        /// 设置其他UI
        setUI()
        setSideMenu()
        
        // 设置上拉刷新
        setRefreshFooter()
        
        /// 请求数据
        loadData(isRefresh: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 重新父类方法
    override func setUI() {
        setNavigationBar(title: "")
        view.backgroundColor = contentBgColor
        view.addSubview(testBtn)
        testBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(testBtnlClicked)))
    }
    
    override func setNavigationBar(title: String?) {
        super.setNavigationBar(title: title)
        let btn = UIButton()
        btn.setTitle("项目列表", for: .normal )
        btn.titleLabel?.font = UIFont.systemFont(ofSize: kNavigationTitleFontSize)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        
        // 设置右边的按钮
        let moreItem = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(moreBtnClick))
        let searchItem = UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: #selector(searchBtnClick))
        navigationItem.rightBarButtonItems = [moreItem, searchItem]
    }
}


// MARK: - 事件监听函数
extension ProjectListViewController {
    @objc private func moreBtnClick() {
        self.present(SideMenuManager.default.menuRightNavigationController!, animated: true,
                     completion: nil)
    }
    
    @objc private func searchBtnClick() {
        
    }
    
    @objc private func  testBtnlClicked() {
        pushViewController(viewController: BasketListViewController(projectId: "testid"), animated: true)
    }
    
    /// 下拉刷新
    override func headerRefresh() {
        
    }
    
    /// 上拉刷新
    override func footerRefresh() {
        
    }
    
}



// MARK: - 网络请求
extension ProjectListViewController {
    private func loadData(isRefresh: Bool) {
        // TODO: 网络请求
    }
}


// MARK: - 侧边栏
extension ProjectListViewController {
    func setSideMenu() {
        sideMenuViewController = UIStoryboard(name: "MoreInfo", bundle: nil).instantiateViewController(withIdentifier: "moreInfo") as! MoreInfoViewController
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
extension ProjectListViewController: MoreInfoViewControllerDelegate {
    
    func moreInfoViewController(selected projectId: String) {
        //
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ProjectListViewController  {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRefreshCellIID, for: indexPath) as! ProjectListViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        //
    }
    
}

