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
private let kItemH: CGFloat = 180  //kItemW / 3 + 40
private let kSearchBoxH: CGFloat = 60
let kSearchByAreaType: Int = 1
let kSearchByPageType: Int = 2
let kEmptyKeyWord = "  "
let kFirstPageIndex: Int = 1
private let kTableCellID = "kTableCellID"


class ProjectListViewController: RefreshBaseViewController {
    
    // MARK: - 控件属性
    
    // MARK: - 懒加载属性
    private lazy var sideMenuViewController = MoreInfoViewController()
    private lazy var searchBoxView: SearchBoxView = {
        let searchBoxView = SearchBoxView.searchBoxView()
        searchBoxView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kSearchBoxH)
        return searchBoxView
    }()
    private lazy var searchController = UISearchController(searchResultsController: nil)
    private lazy var projectListVM = ProjectListViewModel()
    private lazy var projectListSearchByPage = [ProjectInfoModel]()
    private lazy var projectListSearchByArea = [ProjectInfoModel]()
    private lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 44, right: 0)
        //tableView.scrollIndicatorInsets = UIEdgeInsets(top: 64, left: 0, bottom: 44, right: 0)
        tableView.rowHeight = kItemH
        tableView.register(UINib(nibName: "ProjectListViewCell", bundle: nil), forCellReuseIdentifier: kTableCellID)
        tableView.tableFooterView = UIView(frame: .zero)
        //以下代码关闭估算行高,从而解决底下留白的bug
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        // 改变索引的颜色
        //tableView.sectionIndexColor = UIColor.black
        // 改变索引背景颜色
        //tableView.sectionIndexBackgroundColor = UIColor.clear
        // 改变索引被选中的背景颜色
        // table.sectionIndexTrackingBackgroundColor = UIColor.green
        return tableView
        }()
    
    
    // MARK: - 自定义属性
    static var pageIndx4Area: Int = kFirstPageIndex
    static var pageIndx4Page: Int = kFirstPageIndex
    private var lastKeyWord = kEmptyKeyWord
    private var searchType: Int = kSearchByPageType

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
        loadData(isRefresh: false, keyWord: kEmptyKeyWord, type: kSearchByPageType, pageNum: ProjectListViewController.pageIndx4Page)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 重新父类方法
    override func setUI() {
        setNavigationBar(title: "")
        view.backgroundColor = contentBgColor
        
        view.addSubview(searchBoxView)
        searchBoxView.isHidden = true
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
        
        
        // 设置搜索框
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "搜索"
        //修改取消按钮的颜色
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
        //修改取消按钮的文字
        searchController.searchBar.setValue("取消", forKey: "_cancelButtonText")
        //修改光标颜色
        searchController.searchBar.tintColor = UIColor.gray
        //设置搜索框背景图片
        searchController.searchBar.setSearchFieldBackgroundImage(UIImage(named: "white-bg"), for: .normal)
        //设置键盘搜索键的代理
        searchController.searchBar.delegate = self
        
        self.definesPresentationContext = true //这是能push成功的关键
 
    }
}

// MARK: - UISearchBarDelegate
extension ProjectListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyWord = searchController.searchBar.text else {
            view.showTip(tip: "百胜吊篮：输入无效！", position: .bottomCenter)
            return
        }
        lastKeyWord = keyWord
        ProjectListViewController.pageIndx4Area = kFirstPageIndex
        loadData(isRefresh: false, keyWord: keyWord, type: kSearchByAreaType, pageNum: ProjectListViewController.pageIndx4Area)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchType = kSearchByPageType
        lastKeyWord = kEmptyKeyWord
        ProjectListViewController.pageIndx4Area = kFirstPageIndex
        self.removeNoProjectPage()
        self.enabelFooter()
        collectionView.reloadData()
    }

}

// MARK: - 事件监听函数
extension ProjectListViewController {
    @objc private func moreBtnClick() {
        self.present(SideMenuManager.default.menuRightNavigationController!, animated: true,
                     completion: nil)
    }
    
    @objc private func searchBtnClick() {
        //searchBoxView.isHidden = !searchBoxView.isHidden
        //let flag = navigationController?.navigationBar.isHidden ?? false
        //navigationController?.navigationBar.isHidden = !flag
        pushViewController(viewController: UIViewController(), animated: false)
    }
    
    /// 下拉刷新
    override func headerRefresh() {
        //此处不设置下拉刷新
    }
    
    /// 上拉刷新
    override func footerRefresh() {
        var pageNum = 1;
        switch searchType {
        case kSearchByAreaType:
            pageNum = ProjectListViewController.pageIndx4Area
        case kSearchByPageType:
            pageNum = ProjectListViewController.pageIndx4Page
        default:
            break
        }
        loadData(isRefresh: true, keyWord: lastKeyWord, type: searchType, pageNum: pageNum)
    }
 
}



// MARK: - 网络请求
extension ProjectListViewController {
    private func loadData(isRefresh: Bool, keyWord: String, type: Int, pageNum: Int) {
        // TODO: 网络请求
        projectListVM.requestProjectList(keyWord: keyWord, type: type, pageNum: pageNum, viewController: self, finishedCallBack: {
            
            self.searchType = type
            self.projectListSearchByPage = self.projectListVM.projectList
            self.projectListSearchByArea = self.projectListVM.searchProjectList
            
            /// 若无数据，则加载空页面
            switch type {
            case kSearchByPageType:
                if self.projectListSearchByPage.count == 0 {
                    self.loadNoProjectPage()
                    self.disablFooter()
                } else {
                    self.removeNoProjectPage()
                    self.enabelFooter()
                }
            case kSearchByAreaType:
                if self.projectListSearchByArea.count == 0 {
                    self.loadNoProjectPage()
                    self.disablFooter()
                } else {
                    self.removeNoProjectPage()
                    self.enabelFooter()
                }
            default:
                break
            }

            
            /// 刷新表格数据
            self.collectionView.reloadData()
            
            if isRefresh {
                self.footerEndRefreshing()  //如果是刷新数据（不是第一次请求），那么刷新后要手动停止刷新
            }
            
        }) {
            //error
            self.view.showTip(tip: kNetWorkErrorTip, position: .bottomCenter)
        }
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
/*
extension ProjectListViewController  {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch searchType {
        case kSearchByPageType:
            return projectListSearchByPage.count
        case kSearchByAreaType:
            return projectListSearchByArea.count
        default:
            return 0
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRefreshCellIID, for: indexPath) as! ProjectListViewCell
        switch searchType {
        case kSearchByPageType:
            cell.projectInfoModel = self.projectListSearchByPage[indexPath.item]
        case kSearchByAreaType:
            cell.projectInfoModel = self.projectListSearchByArea[indexPath.item]
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        // 点击进入吊篮页面
        var projectId: String?
        switch searchType {
        case kSearchByPageType:
            projectId = self.projectListSearchByPage[indexPath.item].projectId
        case kSearchByAreaType:
            projectId = self.projectListSearchByArea[indexPath.item].projectId
        default:
            break
        }
        pushViewController(viewController: BasketListViewController(projectId: projectId), animated: true)
    }
    
}
*/

extension ProjectListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchType {
        case kSearchByPageType:
            return projectListSearchByPage.count
        case kSearchByAreaType:
            return projectListSearchByArea.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTableCellID, for: indexPath) as! ProjectListViewCell
        switch searchType {
        case kSearchByPageType:
            cell.projectInfoModel = self.projectListSearchByPage[indexPath.item]
        case kSearchByAreaType:
            cell.projectInfoModel = self.projectListSearchByArea[indexPath.item]
        default:
            break
        }
        return cell
    }
    
    
}
