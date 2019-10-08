//
//  ProfileViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/20.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    // MARK: - 模型属性
    @IBOutlet weak var logoutItem: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userRoleLabel: UILabel!
    
    // MARK: - 自定义属性
    var userDetailVM: UserDetailViewModel = UserDetailViewModel()
    var userDetailModel: UserDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        logoutItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoutItemTapped)))
        
        loadData()
    }
    
    override func setUI() {
        setNavigationBar(title: "")
        view.backgroundColor = contentBgColor
    }
    
}

// MARK: - 事件监听函数
extension ProfileViewController {
    
    @objc private func logoutItemTapped() {
        UserDefaultStorage.removeToken()
        self.dismiss(animated: false, completion: nil)
    }
}

// MARK: - 网络请求数据
extension ProfileViewController {
    
    private func loadData() {
        
        let userId = UserDefaultStorage.getUserId() ?? ""
        
        userDetailVM.requestUserDetail(userId: userId, viewController: self, finishedCallBack: {
            self.userDetailModel = self.userDetailVM.userDetailModel  // 把请求到的数据放到Model里
            self.userNameLabel.text = self.userDetailModel?.userName
            let userRoleRawValue = self.userDetailModel?.userRole
            var userRoleTxt: String?
            switch userRoleRawValue {
            case UserRole.AreaAdmin.rawValue:
                userRoleTxt = "区域管理员"
            case UserRole.RentAdmin.rawValue:
                userRoleTxt = "租方管理员"
            case UserRole.Inspector.rawValue:
                userRoleTxt = "巡检人员"
            case UserRole.Worker.rawValue:
                userRoleTxt = "工人"
            default:
                userRoleTxt = "未知"
            }
            self.userRoleLabel.text = userRoleTxt
        }, errorCallBack: {
            self.view.showTip(tip: kNetWorkErrorTip, position: .bottomCenter)
        })
    }
    
}
