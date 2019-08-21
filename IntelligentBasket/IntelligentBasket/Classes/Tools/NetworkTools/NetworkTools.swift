//
//  NetworkTools.swift
//  LiveApp
//
//  Created by 卢卓桓 on 2019/7/30.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit

private let kTokenKey = "MyToken"

enum MethodType{
    case GET
    case POST
}

class NetworkTools {
    
    /// 默认的请求方法(使用json发送参数)
    class func requestData(URLString: String, method: MethodType, parameters: [String: Any]? = nil, finishedCallBack: @escaping (_ result: Any) -> (), finishWithError: @escaping (_ error: Any) -> ()){
        
        let headers: HTTPHeaders = ["Accept": "*/*", "Content-Type": "application/json"]
        
        Alamofire.request(URLString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON()
            .done { (json, response) in
                finishedCallBack(json)  //回调结果
            }.catch { (error) in
                finishWithError(error)  //回调错误
        }
    }
    
    /// 携带Token
    class func requestData(URLString: String, method: MethodType, parameters: [String: Any]? = nil, token: String, finishedCallBack: @escaping (_ result: Any) -> (), finishWithError: @escaping (_ error: Any) -> ()){
        
        let headers: HTTPHeaders = ["Accept": "*/*", "Content-Type": "application/json", "token": token]
        
        Alamofire.request(URLString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON()
            .done { (json, response) in
                finishedCallBack(json)  //回调结果
            }.catch { (error) in
                finishWithError(error)  //回调错误
        }
    }
    
    class func storeToken(token: String) {
        UserDefaults.standard.set(token, forKey: kTokenKey)
    }
    
    class func getToken() -> String? {
        return UserDefaults.standard.object(forKey: kTokenKey) as? String
    }
}
