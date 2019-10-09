//
//  ProjectViewModel.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/24.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class ProjectViewModel {
    lazy var projectGroup = [ProjectModel]()
}

// MARK: - 请求网络数据
extension ProjectViewModel {
    
    func requestAllProject(userId: String, viewController: UIViewController, finishedCallBack: @escaping () -> (), errorCallBack: @escaping () -> ()) {
        
        let token = UserDefaultStorage.getToken() ?? ""
        let parameters = ["userId": userId]
        
        projectGroup = []
        
        HttpTools.requestDataURLEncoding(URLString: getAllProjectURL, method: .GET, parameters: parameters,token: token, finishedCallBack: { (result) in
            //print(result)
            guard let resDict = result as? [String: Any] else { return }
            
            let isAllowed = resDict["isAllowed"] as! Bool
            if isAllowed == false {
                //AlertBox.create(title: "警告", message: "令牌无效！", viewController: viewController)
                AlertBox.createForInvalidToken(title: "警告", message: "令牌无效！", viewController: viewController)
                return
            }
            
            /// 取出数据
            guard let projectList = resDict["projectList"] as? [[String: Any]] else { return }
            /// 遍历数组
            for dict in projectList {
                guard let projectModel = try? DictConvertToModel.JSONModel(ProjectModel.self, withKeyValues: dict) else {
                    print("ProjectModel: Json To Model Failed")
                    continue
                }
                /// 把吊篮编号转成数组，方便之后使用
                let boxList = dict["boxList"] as! String
                let strArr: [String] = boxList.split(separator: ",").compactMap{ "\($0)" }
                projectModel.basketNum = strArr
                self.projectGroup.append(projectModel)
            }
            finishedCallBack()
        })
        { (error) in
            print(error)
            errorCallBack() //错误回调
        }
    }

}
