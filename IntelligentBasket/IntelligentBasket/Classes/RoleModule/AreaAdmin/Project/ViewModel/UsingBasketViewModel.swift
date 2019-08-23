//
//  UsingBasketViewModel.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/23.
//  Copyright © 2019 zhineng. All rights reserved.
//

/*
 * 区域管理员 -> 项目 -> 使用中
 */

import UIKit

class UsingBasketViewModel {
    lazy var usingBasketGroup = [UsingBasketModel]()
}

// MARK: - 请求网络数据
extension UsingBasketViewModel {
    
    func requestAllProject(userId: String, viewController: UIViewController, finishedCallBack: @escaping () -> (), errorCallBack: @escaping () -> ()) {
        
        let token = UserDefaultStorage.getToken() ?? ""
        let parameters = ["userId": userId]
        
        NetworkTools.requestDataURLEncoding(URLString: getAllProjectURL, method: .GET, parameters: parameters,token: token, finishedCallBack: { (result) in
            print(result)
            guard let resDict = result as? [String: Any] else { return }
            
            let isAllowed = resDict["isAllowed"] as! Bool
            if isAllowed == false {
                AlertBox.create(title: "警告", message: "令牌无效！", viewController: viewController)
                return
            }
            
            /// 取出数据
            guard let projectList = resDict["projectList"] as? [[String: Any]] else { return }
            /// 遍历数组
            for dict in projectList {
                guard let model = try? DictConvertToModel.JSONModel(UsingBasketModel.self, withKeyValues: dict) else {
                    print("UsingBasketModel: Json To Model Failed")
                    continue
                }
                
                /// 把吊篮编号转成数组，方便之后使用
                let boxList = dict["boxList"] as! String
                let strArr: [String] = boxList.split(separator: ",").compactMap{ "\($0)" }
                model.basketNum = strArr
                
                self.usingBasketGroup.append(model)
            }
            finishedCallBack()
        })
        { (error) in
            print(error)
            errorCallBack() //错误回调
        }
    }
    
    func requestBoxListData(viewController: UIViewController, finishedCallBack: @escaping () -> (), errorCallBack: @escaping () -> ()) {
        
        let token = UserDefaultStorage.getToken() ?? ""
        let parameters = ["projectId": "001"]
        
        NetworkTools.requestDataURLEncoding(URLString: getBasketList, method: .GET, parameters: parameters,token: token, finishedCallBack: { (result) in
            print(result)
//            guard let resDict = result as? [String: Any] else { return }
//
//            let isAllowed = resDict["isAllowed"] as! Bool
//            if isAllowed == false {
//                AlertBox.create(title: "警告", message: "令牌无效！", viewController: viewController)
//                return
//            }
//
//            /// 取出数据
//            guard let projectList = resDict["projectList"] as? [[String: Any]] else { return }
//            /// 遍历数组
//            for dict in projectList {
//                guard let model = try? DictConvertToModel.JSONModel(UsingBasketModel.self, withKeyValues: dict) else {
//                    print("UsingBasketModel: Json To Model Failed")
//                    continue
//                }
//
//                /// 把吊篮编号转成数组，方便之后使用
//                let boxList = dict["boxList"] as! String
//                let strArr: [String] = boxList.split(separator: ",").compactMap{ "\($0)" }
//                model.basketNum = strArr
//
//                self.usingBasketGroup.append(model)
//            }
            finishedCallBack()
        })
        { (error) in
            print(error)
            errorCallBack() //错误回调
        }
    }
    
}
