//
//  ProjectModel.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/24.
//  Copyright © 2019 zhineng. All rights reserved.
//

/*
 * 获取区域管理员负责的所有项目信息  对应的 项目模型
 */

import UIKit

class ProjectModel: Codable {
    // TODO: 先用一部分，之后再慢慢补充
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
