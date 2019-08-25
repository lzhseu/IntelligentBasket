//
//  SideMenuViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/25.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    private var projectGroup: [ProjectModel]?

    
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
        // Dispose of any resources that can be recreated.
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
        
        return cell
    }
    
    // 处理点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: 切换项目
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}
