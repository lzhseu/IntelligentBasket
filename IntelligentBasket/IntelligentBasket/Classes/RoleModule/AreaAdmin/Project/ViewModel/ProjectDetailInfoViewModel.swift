//
//  ProjectDetailInfoViewModel.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/10/9.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class ProjectDetailInfoViewModel {

    var projectDetailInfoModel: ProjectDetailInfoModel?
}

// MARK: - 请求网络数据
extension ProjectDetailInfoViewModel {
    
    func requestProjectDetailInfo(projectId: String, viewController: UIViewController, finishedCallBack: @escaping () -> (), errorCallBack: @escaping () -> ()) {
        
        let token = UserDefaultStorage.getToken() ?? ""
        let parameters = ["projectId": projectId]
        
        HttpTools.requestDataURLEncoding(URLString: projectDetailInfoURL, method: .GET, parameters: parameters, token: token, finishedCallBack: { (result) in
            //print(result)
            guard let resDict = result as? [String: Any] else { return }
            
            let isAllowed = resDict["isAllowed"] as! Bool
            if isAllowed == false {
                AlertBox.createForInvalidToken(title: "警告", message: "令牌无效！", viewController: viewController)
                return
            }
            
            guard let projectDetail = resDict["projectDetail"] as? [String: Any] else { return }
            guard let projectDetailInfoModel = try? DictConvertToModel.JSONModel(ProjectDetailInfoModel.self, withKeyValues: projectDetail) else {
                print("ProjectDetailInfoModel: Json To Model Failed")
                return
            }
            self.projectDetailInfoModel = projectDetailInfoModel
            finishedCallBack()
            
        }) { (error) in
            print("requestProjectDetailInfo error:  \(error)")
            errorCallBack() //错误回调
        }
    }
}
