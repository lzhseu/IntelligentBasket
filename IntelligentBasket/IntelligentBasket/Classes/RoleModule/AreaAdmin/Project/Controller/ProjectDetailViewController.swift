//
//  ProjectDetailViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/9/2.
//  Copyright © 2019 zhineng. All rights reserved.
//

/*
 * 点击切换项目时，如果是点击的是当前项目，则显示当前项目的项目详情
 * 此为 项目详情 的控制器
 */

import UIKit

class ProjectDetailViewController: BaseViewController {
    
    // MARK: - 懒加载属性
    private lazy var projectDetailInfoVM = ProjectDetailInfoViewModel()
    
    // MARK: - 自定义属性
    var projectId: String?
    
    // MARK: - 模型属性
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectIdLabel: UILabel!
    @IBOutlet weak var projectStateLabel: UILabel!
    @IBOutlet weak var projectStartLabel: UILabel!
    @IBOutlet weak var projectEndLabel: UILabel!
    @IBOutlet weak var areaAdminLabel: UILabel!
    @IBOutlet weak var rentAdminLabel: UILabel!
    @IBOutlet weak var projectBuilderLabel: UILabel!
    @IBOutlet weak var projectResponserLabel: UILabel!
    
    
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        
        loadData()
    }
    
    override func setUI() {
        setNavigationBar(title: "")
        view.backgroundColor = contentBgColor
    }
}

// MARK: - 请求网络数据
extension ProjectDetailViewController {
    
    private func loadData() {
        
        guard let projectId = self.projectId else {
            return
        }
        
        projectDetailInfoVM.requestProjectDetailInfo(projectId: projectId, viewController: self, finishedCallBack: {
            
            let projectDetailInfo = self.projectDetailInfoVM.projectDetailInfoModel
            self.projectNameLabel.text = projectDetailInfo?.projectName
            self.projectIdLabel.text = projectDetailInfo?.projectId
            self.projectStateLabel.text = projectDetailInfo?.projectState
            self.projectStartLabel.text = projectDetailInfo?.projectStart
            self.projectEndLabel.text = projectDetailInfo?.projectEnd
            self.areaAdminLabel.text = projectDetailInfo?.adminAreaId
            self.rentAdminLabel.text = projectDetailInfo?.adminRentId
            self.projectBuilderLabel.text = projectDetailInfo?.projectBuilders
            self.projectResponserLabel.text = projectDetailInfo?.adminProjectId
            
        }) {
            self.view.showTip(tip: kNetWorkErrorTip, position: .bottomCenter)
        }
    }
}
