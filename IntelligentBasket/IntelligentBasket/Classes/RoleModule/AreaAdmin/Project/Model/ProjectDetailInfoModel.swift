//
//  ProjectDetailInfoModel.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/10/9.
//  Copyright © 2019 zhineng. All rights reserved.
//

/*
 * 获取指定项目的详细信息  对应的模型
 */

import UIKit

class ProjectDetailInfoModel: Codable {
    
    var projectId: String?
    var projectName: String?
    var projectState: String?
    var projectStart: String?
    var projectEnd: String?
    var projectContractUrl: String?
    var projectCertUrl: String?
    var adminAreaId: String?
    var adminRentId: String?
    var adminProjectId: String?
    var projectBuilders: String?
    
    enum CodingKeys: String, CodingKey {
        case projectId
        case projectName
        case projectState
        case projectStart
        case projectEnd
        case projectContractUrl
        case projectCertUrl
        case adminAreaId
        case adminRentId
        case adminProjectId
        case projectBuilders
    }
}
