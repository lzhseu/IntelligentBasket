//
//  ProjectListViewModel.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/10/22.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class ProjectListViewModel {
    lazy var projectList = [ProjectInfoModel]()
    lazy var searchProjectList = [ProjectInfoModel]()  // 通过搜索得到的结果
}

// MARK: - 请求网络数据
extension ProjectListViewModel {
    
    func requestProjectList(keyWord: String, type: Int, pageNum: Int, viewController: UIViewController, finishedCallBack: @escaping () -> (), errorCallBack: @escaping () -> ()) {
        
        if pageNum == 1 {
            searchProjectList = []
        }
        
        let token = UserDefaultStorage.getToken() ?? ""
        let parameters = ["keyWord": keyWord, "type": type, "pageNum": pageNum] as [String : Any]
        
        HttpTools.requestDataURLEncoding(URLString: getProjectListByKeyURL, method: .GET, parameters: parameters,token: token, finishedCallBack: { (result) in
            //print(result)
            
            guard let resDict = result as? [String: Any] else { return }
            
            let isLogin = resDict["isLogin"] as? Bool ?? false
            if !isLogin {
                AlertBox.createForInvalidToken(title: "警告", message: "权限认证失败！", viewController: viewController)
                return
            }
            
            /// 取出数据
            guard let projectList = resDict["projectList"] as? [[String: Any]] else { return }
            
            /// 更新页码
            if projectList.count != 0 {
                switch type {
                case kSearchByPageType:
                    ProjectListViewController.pageIndx4Page += 1
                case kSearchByAreaType:
                    ProjectListViewController.pageIndx4Area += 1
                default:
                    break
                }
            }
            
            /// 遍历数组
            for dict in projectList {
                guard let projectInfoModel = try? DictConvertToModel.JSONModel(ProjectInfoModel.self, withKeyValues: dict) else {
                    print("ProjectInfoModel: Json To Model Failed")
                    continue
                }
                /// 把吊篮编号转成数组，方便之后使用
                let boxList = dict["boxList"] as? String
                let strArr: [String] = boxList?.split(separator: ",").compactMap{ "\($0)" } ?? []
                projectInfoModel.deviceIds = strArr
                
                /// 根据类型更新数组
                switch type {
                case kSearchByPageType:
                    self.projectList.append(projectInfoModel)
                case kSearchByAreaType:
                    self.searchProjectList.append(projectInfoModel)
                default: break
                }
                
            }
            
            finishedCallBack()
            
        })
        { (error) in
            print("RequestProjectList error: \(error)")
            errorCallBack() //错误回调
        }
    }

    
}
