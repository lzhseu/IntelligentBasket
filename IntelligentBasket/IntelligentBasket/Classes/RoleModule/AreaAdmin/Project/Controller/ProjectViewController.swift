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


class ProjectViewController: BaseViewController {
    
    // MARK: - 自定义属性
    var navTitle = "暂无项目"    // 会动态改变
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
        return pageMenu
    }()
    
    private lazy var childVcs = [BaseViewController]()
    
    private lazy var projectVM = ProjectViewModel()

    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        makeConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - 重新父类方法
    override func setUI() {
        setNavigationBar(title: navTitle)
        view.backgroundColor = contentBgColor
        view.addSubview(pageMenu)
        view.addSubview(scrollView)
        
        // TODO: 把子控制器加在此处
        var vc = RoleBaseViewController()
        vc = UsingViewController()
        addChild(vc)
        childVcs.append(vc)
        scrollView.addSubview(vc.view)
        vc.view.frame = CGRect(x: 0, y: 0, width: kScreenW, height: scrollView.frame.height)
        
        vc = BasketDetailViewController()
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
        
        /// 显示第一个视图
        if pageMenu.selectedItemIndex < childVcs.count {
            scrollView.contentOffset = CGPoint(x: CGFloat(pageMenu.selectedItemIndex) * kScreenW, y: 0)
        }
        
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


// MARK: - 事件监听函数
extension ProjectViewController {
    
    @objc func moreBtnClick() {
        print("more")
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

