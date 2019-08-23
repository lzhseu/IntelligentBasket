//
//  UsingBasketModel.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/23.
//  Copyright © 2019 zhineng. All rights reserved.
//

/*
 * 区域管理员 -> 项目 -> 使用中 的模型
 */

import UIKit

class UsingBasketModel: Codable {
    
    // MARK: - 模型属性
    var adminAreaId: String?
    var adminProjectId: String?
    var boxList: String?
    var projectId: String?
    var projectName: String?
    var projectState: String?
 
    // MARK: - 自定义属性
    var basketNum: [String]?
    
    enum CodingKeys: String, CodingKey {
        case adminAreaId
        case adminProjectId
        case boxList
        case projectId
        case projectName
        case projectState
    }
}
