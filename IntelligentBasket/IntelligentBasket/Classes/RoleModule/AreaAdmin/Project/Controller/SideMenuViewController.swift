//
//  SideMenuViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/25.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

private let kCurrentImageViewTag = 11    // 当前项目图标的tag

protocol SideMenuViewControllerDelegate: class {
    func sideMenuViewController(selected projectId: String)
}

class SideMenuViewController: UIViewController {
    
    private var projectGroup: [ProjectModel]?
    weak var delegate: SideMenuViewControllerDelegate?

    
    @IBOutlet weak var settingTableView: UITableView!
    
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func setProjectGroup(projectGroup: [ProjectModel]?){
        self.projectGroup = projectGroup
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
            currentImageView?.isHidden = false
        } else {
            currentImageView?.isHidden = true
        }
        return cell
    }
    
    // 处理点击事件:切换项目
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: true) {
            guard let selectedProjectId = self.projectGroup![indexPath.row].projectId else {
                return
            }
            self.delegate?.sideMenuViewController(selected: selectedProjectId)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}
