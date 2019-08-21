//
//  UserInfoModel.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/20.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class UserInfoModel: Codable {
    
    var checked = false
    var userId = ""
    var userName = ""
    var userPassword = ""
    var userPhone = ""
    var userRole = ""
    var userPerm = ""   //用户权限
    var userImage = ""

    
    enum CodingKeys: String, CodingKey {
        case checked
        case userId
        case userName
        case userPassword
        case userPhone
        case userRole
        case userPerm
        case userImage
    }
}


