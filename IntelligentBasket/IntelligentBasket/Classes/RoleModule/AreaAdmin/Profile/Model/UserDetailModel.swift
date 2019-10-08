//
//  UserDetailModel.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/10/8.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class UserDetailModel: Codable {
    var userId: String?
    var userName: String?
    var userRole: String?
    var userPhone: String?
    var userImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId
        case userName
        case userRole
        case userPhone
        case userImage
    }
}
