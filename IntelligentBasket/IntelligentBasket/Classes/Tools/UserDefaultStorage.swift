//
//  UserDefaultStorage.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/23.
//  Copyright © 2019 zhineng. All rights reserved.
//

/*
 * 使用 UserDefault 进行小容量数据存取
 */

import UIKit

private let kTokenKey = "MyToken"
private let kCurrentProKey = "kCurrentProKey"



class UserDefaultStorage {
    
    /// 存取 Token
    class func storeToken(token: String) {
        UserDefaults.standard.set(token, forKey: kTokenKey)
    }
    
    class func getToken() -> String? {
        return UserDefaults.standard.object(forKey: kTokenKey) as? String
    }
    
    /// 存取当前项目名（区域管理员 用到）
    class func storeCurrentProjectId(projectId: String) {
        UserDefaults.standard.set(projectId, forKey: kCurrentProKey)
    }
    
    class func getCurrentProjectId() -> String? {
        return UserDefaults.standard.object(forKey: kCurrentProKey) as? String
    }
}
