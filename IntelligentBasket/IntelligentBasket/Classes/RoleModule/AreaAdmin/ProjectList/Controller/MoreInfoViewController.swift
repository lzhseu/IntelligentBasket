//
//  SideMenuViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/10/18.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

protocol MoreInfoViewControllerDelegate: class {
    func moreInfoViewController(selected projectId: String)
}


class MoreInfoViewController: UIViewController {

    // MARK: - 自定义属性
    weak var delegate: MoreInfoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = primaryColor
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension MoreInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuViewCell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    // 处理点击事件:切换项目
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}

// MARK: - 事件监听函数
extension SideMenuViewController {
    
    // 退出登录
    @objc private func logoutImageViewClicked() {
        UserDefaultStorage.removeToken()
        self.dismiss(animated: false, completion: nil)
    }
}

