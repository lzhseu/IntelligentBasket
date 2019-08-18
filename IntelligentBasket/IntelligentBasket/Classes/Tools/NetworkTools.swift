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

enum MethodType{
    case GET
    case POST
}

class NetworkTools {

    class func requestData(URLString: String, method: MethodType, parameters: [String: Any]? = nil, finishedCallBack: @escaping (_ result: Any) -> ()){
        
        var methodType = HTTPMethod.get
        
        switch method {
        case .GET:
            methodType = HTTPMethod.get
        case .POST:
            methodType = HTTPMethod.post
        }
        
        Alamofire.request(URLString, method: methodType, parameters: parameters).responseJSON { (response) in
            //debugPrint(response)
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            //将结果回调出去
            finishedCallBack(result)
        }
    }
    
    /// 使用PromiseKit
    class func requestDataWithPromiseKit(URLString: String, method: MethodType, parameters: [String: Any]? = nil, finishedCallBack: @escaping (_ result: Any) -> ()){
        
        var methodType = HTTPMethod.get
        
        switch method {
        case .GET:
            methodType = HTTPMethod.get
        case .POST:
            methodType = HTTPMethod.post
        }
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(URLString, method: methodType, parameters: parameters).responseJSON()
            .ensure {
                //UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            .done { (json, response) in
                finishedCallBack(json)
            }
            .catch { (error) in
                print("error: \(error)")
            }
    }
}
