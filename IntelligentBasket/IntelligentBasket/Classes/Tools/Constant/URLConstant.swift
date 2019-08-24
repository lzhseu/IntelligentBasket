//
//  URLConstant.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/19.
//  Copyright © 2019 zhineng. All rights reserved.
//

import Foundation

let baseURL = "http://47.100.1.211"
let baseRtmpURL = "rtmp://47.96.103.244:1935/rtmplive"


/// 登录注册
let registerURL = baseURL + "/checkRegister"
let loginURL = baseURL + "/login"

/// 获取区域管理员负责的所有项目信息，以便出库
let getAllProjectURL = baseURL + "/getAllProject"

/// 获取某一项目的吊篮列表
let getBasketListURL = baseURL + "/getBasketList"

/// 移动端向吊篮发起命令：
let sendToDeviceURL = baseURL + ":8081/sendToDevice"
