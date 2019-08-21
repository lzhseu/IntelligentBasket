//
//  ProjectViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/20.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import SnapKit


class ProjectViewController: BaseViewController {
    
    // MARK: - 自定义属性
    var navTitle = "暂无项目"    // 会动态改变
    let titles = ["进度", "待安装", "安装审核", "使用中", "待报停", "报停审核"]

//    // MARK: - 懒加载属性
//    private lazy var pageTitleView: PageTitleView = { [weak self] in
//        let titles = self!.titles
//        let viewFrame = CGRect(x: 0, y: 0, width: kScreenW, height: kTitleViewH)
//        let titleView = PageTitleView(frame: viewFrame, titles: titles)
//        titleView.delegate = self
//        return titleView
//    }()
//
//    private lazy var pageContentView: PageContentView = { [weak self] in
//        ///确定所有的子控制器
//        var childVcs = [UIViewController]()
//        // TODO: 先加入不同颜色，之后在此处添加具体的控制器
//        for _ in 0..<self!.titles.count {
//            let vc = UIViewController()
//            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
//            childVcs.append(vc)
//        }
//
//        /// 获取导航栏宽度
//        let kNavigationBarH = self?.navigationController?.navigationBar.frame.height ?? 0
//        let kTabBarH = self?.tabBarController?.tabBar.frame.height ?? 0
//
//        let viewFrame = CGRect(x: 0, y: kTitleViewH, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH - kTabBarH - kTitleViewH)
//
//        let contentView = PageContentView(frame: viewFrame, childVcs: childVcs, parentVc: self)
//        contentView.delegate = self
//        return contentView
//    }()
//
//
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
        //view.addSubview(pageTitleView)
        //view.addSubview(pageContentView)
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

//    override func makeConstraints() {
//        pageTitleView.snp.makeConstraints { (make) in
//            make.left.right.top.equalToSuperview()
//            make.height.equalTo(kTitleViewH)
//        }
//
//    }

}


// MARK: - 事件监听函数
extension ProjectViewController {
    
    @objc func moreBtnClick() {
        print("more")
    }
}


//// MARK: - 遵守pageTitleViewDelegate协议
//extension ProjectViewController: PageTitleViewDelegate {
//    func pageTitleView(titleView: PageTitleView, selected index: Int) {
//        pageContentView.setControllerByCurrentIndex(currentIndex: index)
//    }
//
//}
//
//
//// MARK: - 遵守pageContentViewDelegate协议
//extension ProjectViewController: PageContentViewDelegate {
//    func pageContentView(content: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
//        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
//    }
//}
