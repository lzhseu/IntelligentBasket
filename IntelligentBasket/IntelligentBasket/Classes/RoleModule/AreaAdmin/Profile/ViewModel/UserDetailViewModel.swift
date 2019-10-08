//
//  UserDetailViewModel.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/10/8.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class UserDetailViewModel {
    var userDetailModel: UserDetailModel?
}

// MARK: - 请求网络数据
extension UserDetailViewModel {
    
    func requestUserDetail(userId: String, viewController: UIViewController, finishedCallBack: @escaping () -> (), errorCallBack: @escaping () -> ()) {
        
        let token = UserDefaultStorage.getToken() ?? ""
        
        HttpTools.requestDataURLEncoding(URLString: "http://47.100.1.211/androidGetUserInfo?userId=\(userId)", method: .POST,token: token, finishedCallBack: { (result) in
            //print(result)
            
            guard let resDict = result as? [String: Any] else { return }
            
            let isLogin = resDict["isLogin"] as! Bool
            if isLogin == false {
                AlertBox.createForInvalidToken(title: "警告", message: "令牌无效！", viewController: viewController)
                return
            }
            
            guard let userInfo = resDict["userInfo"] as? [String: Any] else { return }
            guard let userDetailModel = try? DictConvertToModel.JSONModel(UserDetailModel.self, withKeyValues: userInfo) else {
                print("UserDetailModel: Json To Model Failed")
                return
            }
            self.userDetailModel = userDetailModel
            finishedCallBack()
        })
        { (error) in
            print(error)
            errorCallBack() //错误回调
        }
    }
}
