//
//  SideMenuViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/25.
//  Copyright © 2019 zhineng. All rights reserved.
//

/*
 * 此为 切换项目侧边栏 的控制器
 */

import UIKit

private let kCurrentImageViewTag = 11    // 当前项目图标的tag
private let kTitleLabelTag = 22          // 表格文字内容(label)的tag

protocol SideMenuViewControllerDelegate: class {
    func sideMenuViewController(selected projectId: String)
}

class SideMenuViewController: UIViewController {
    
    // MARK: - 自定义属性
    private var projectGroup: [ProjectModel]?
    private var currentIndexPath: IndexPath?
    weak var delegate: SideMenuViewControllerDelegate?
    private var userId = ""
    private lazy var projectVM = ProjectViewModel()

    // MARK: - 模型属性
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var refreshImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*//设置背景图片，暂时没找到合适的
        let imageView = UIImageView(image: UIImage(named: "sidemenu-back4"))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.insertSubview(imageView, at: 0)
        */
        view.backgroundColor = primaryColor
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.tableFooterView = UIView()
        refreshImageView.isUserInteractionEnabled = true
        refreshImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(refreshImagViewClicked)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func setProjectGroup(projectGroup: [ProjectModel]?){
        self.projectGroup = projectGroup
    }

    func setUserId(userId: String) {
        self.userId = userId
    }
}


extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectGroup?.count ?? 0
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuViewCell", for: indexPath)
        
        cell.backgroundColor = UIColor.clear
        cell.textLabel!.text = projectGroup![indexPath.row].projectName
        /// 显示当前项目图标
        let currentImageView = cell.viewWithTag(kCurrentImageViewTag)
        guard let currentProjectId = UserDefaultStorage.getCurrentProjectId() else {
            return cell
        }
        if currentProjectId == projectGroup![indexPath.row].projectId {
            currentIndexPath = indexPath
            currentImageView?.isHidden = false
        } else {
            currentImageView?.isHidden = true
        }
        return cell
    }
    
    // 处理点击事件:切换项目
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: true) {
            
            /// 将当前点击的项目图标设置可见，其他项目设置不可见
            guard let projectName = self.projectGroup![indexPath.row].projectName else {
                return
            }
            
            for cell in tableView.visibleCells {
                let currentImageView = cell.viewWithTag(kCurrentImageViewTag)
                let titleLabel = cell.viewWithTag(kTitleLabelTag) as! UILabel
                guard let title = titleLabel.text else { continue }
                if projectName == title {
                    currentImageView?.isHidden = false
                } else {
                    currentImageView?.isHidden = true
                }
            }
            
            /// 通过代理，完成切换项目后的工作
            guard let selectedProjectId = self.projectGroup![indexPath.row].projectId else {
                return
            }
            self.delegate?.sideMenuViewController(selected: selectedProjectId)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}

// MARK: - 事件监听函数
extension SideMenuViewController {
    
    /// 点击刷新时，重新请求项目的数据
    @objc private func refreshImagViewClicked() {
        loadData()
    }
}

// MARK: - 网络请求数据
extension SideMenuViewController {
    
    private func loadData() {
        view.showLoadingHUD()
        projectVM.requestAllProject(userId: userId, viewController: self, finishedCallBack: {
            self.projectGroup = self.projectVM.projectGroup
            self.settingTableView.reloadData()
            self.view.hideLoading()
        }) {
            self.view.showTip(tip: "刷新失败！", position: .bottomCenter)
        }
    }
}
