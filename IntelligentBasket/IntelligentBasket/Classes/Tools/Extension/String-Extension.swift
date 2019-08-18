//
//  String-Extension.swift
//  LoginTest
//
//  Created by 卢卓桓 on 2019/8/16.
//  Copyright © 2019 zhineng. All rights reserved.
//


//通过对String扩展，字符串增加下表索引功能
extension String
{
    subscript(index:Int) -> String
    {
        get{
            return String(self[self.index(self.startIndex, offsetBy: index)])
        }
        set{
            let tmp = self
            self = ""
            for (idx, item) in tmp.enumerated() {
                if idx == index {
                    self += "\(newValue)"
                }else{
                    self += "\(item)"
                }
            }
        }
    }
}
