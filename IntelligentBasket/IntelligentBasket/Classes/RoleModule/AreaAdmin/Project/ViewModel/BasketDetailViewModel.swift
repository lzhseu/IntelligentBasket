//
//  BasketDetailViewModel.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/28.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

private let kPrefetchingPhotoNum = 25 // 预取的照片数
private let kRefreshPhotoNum = 6      // 刷新下载的照片数
private let kMaxPhotoNumsFromLoaclFiles = 15 // 从本地拿照片显示时，一次最多显示15张
let NO_MORE_PHOTO: Int = 1014

class BasketDetailViewModel {

    var photosName = [String]()
    static var photosDisplayed = [String]()   //用于存储已经显示的图片
    
}

// MARK: - 获取图片
extension BasketDetailViewModel {
    
    ///点击按钮时获取图片
    func getPhotos(deviceId: String, success: @escaping (_ result: Any) -> (), finishWithError: @escaping (_ error: Int) -> ()) {
        
        /// 判断文件夹是否存在，不存在则创建
        let dirPath = "/" + localFileAppendingBaseURL + "/" + deviceId
        if !LocalFileTools.isDirExistInCache(dir: dirPath) {
            LocalFileTools.createDirInCache(dir: dirPath)
        }
        
        
        /// 获取文件夹中的所有图片
        let localFiles = LocalFileTools.getAllFilesInCache(dir: dirPath)
        
        var imagesPath = [String]()
        
        BasketDetailViewModel.photosDisplayed = []
        
        /// 若文件夹中有图片，则直接展示
        if localFiles.count > 0 {
            
            print("get photos from local file.")
            /// 一次显示15张
            for (idx, image) in localFiles.enumerated() {
                if idx == kMaxPhotoNumsFromLoaclFiles {
                    break
                }
                imagesPath.append(NSHomeDirectory() + dirPath + "/" + image)
                BasketDetailViewModel.photosDisplayed.append(image)
            }
            
            /// 成功回调
            success(imagesPath)
            
        } else {
            
            print("get photos from ftp server.")
            
            let dGroup = DispatchGroup()
            
            /// 本地没有图片的话，则从服务器拿
            /// 先获取资源列表
            let ftpResourceListURL = baseFtpURL + photoDirFtpURL + "/" + deviceId
            FtpTools.FtpResourceList(baseURL: ftpResourceListURL, finishedCallBack: { (result) in
                
                print("拿到资源列表")
                
                /// 拿到资源列表
                guard let resArr = result as? [[String: Any]] else { return }
                
                /// 拿到每张图片的名称
                for dict in resArr {
                    let photoName = dict["kCFFTPResourceName"] as! String
                    if photoName.hasSuffix(".jpg") || photoName.hasSuffix(".jpeg") || photoName.hasSuffix(".png") {
                        self.photosName.append(photoName)
                    }
                    /// 我先预拿25张，减少开销，因为FTP没那么快，拿多了也没用
                    if self.photosName.count == kPrefetchingPhotoNum {
                        break
                    }
                }
                
                /// 开始下载
                for  (idx, file) in self.photosName.enumerated() {

                    let appendingURL = photoDirFtpURL + "/" + deviceId + "/" + file
                    let localFilePath = localFileAppendingBaseURL + "/" + deviceId + "/" + file
                    
                    dGroup.enter()
                    FtpTools.FtpDownload(appendingURL: appendingURL, localFilePath: localFilePath, finishedCallBack: { (result) in
                        guard let image = result as? String else {
                            dGroup.leave()
                            return
                        }
                        imagesPath.append(image)
                        dGroup.leave()
                    }) { (error) in
                        dGroup.leave()
                        finishWithError(error)
                    }
                    
                    /// 一次下载12张
                    if idx == FtpMaxClient - 1 {
                        break
                    }
                }
                
                /// 所有并行请求都结束后
                dGroup.notify(queue: .main) {
                    /// 将结果回调
                    print("ftp download photos ooooooooook")
                    success(imagesPath)
                }
                
            }) { (error) in
                finishWithError(error)
            }
            
        }
    }
    
    /// 刷新时获取图片
    func getRefreshPhotos(deviceId: String, success: @escaping (_ result: Any) -> (), finishWithError: @escaping (_ error: Int) -> ()) {
        
        /// 需要知道此时已经有哪些照片了
        /// 需要有一个变量来记录
        /// 获取文件夹中的所有图片
        let dirPath = "/" + localFileAppendingBaseURL + "/" + deviceId
        let localFiles = LocalFileTools.getAllFilesInCache(dir: dirPath)
        
        photosName = []
        var imagesPath = [String]()
        
        let dGroup = DispatchGroup()
        
        /// 先看本地有没有剩余的图片
        if localFiles.count > BasketDetailViewModel.photosDisplayed.count {
            
            print("get photos from local file.")

            /// 一次显示15张
            let displayedCount = BasketDetailViewModel.photosDisplayed.count
            for idx in displayedCount ..< localFiles.count {
                if idx == kMaxPhotoNumsFromLoaclFiles + displayedCount {
                    break
                }
                imagesPath.append(NSHomeDirectory() + dirPath + "/" + localFiles[idx])
                BasketDetailViewModel.photosDisplayed.append(localFiles[idx])
            }
            success(imagesPath)
        } else {
            print("get photos from ftp server.")
            
            /// 先获取资源列表
            let ftpResourceListURL = baseFtpURL + photoDirFtpURL + "/" + deviceId
            FtpTools.FtpResourceList(baseURL: ftpResourceListURL, finishedCallBack: { (result) in
                /// 拿到资源列表
                guard let resArr = result as? [[String: Any]] else { return }
                
                /// 如果本地图片的数量已经等于服务器图片
                if localFiles.count >= resArr.count {
                    finishWithError(NO_MORE_PHOTO)
                    return
                }
                
                /// 拿本地没有的文件
                for idx in localFiles.count ..< resArr.count {
                    let dict = resArr[idx]
                    let photoName = dict["kCFFTPResourceName"] as! String
                    if photoName.hasSuffix(".jpg") || photoName.hasSuffix(".jpeg") || photoName.hasSuffix(".png") {
                        
                        self.photosName.append(photoName)
                    }
                    
                    /// 我先预拿25张，减少开销，因为FTP没那么快，拿多了也没用
                    if idx == localFiles.count + kPrefetchingPhotoNum {
                        break
                    }
                }
                
                /// 开始下载
                for  (idx, file) in self.photosName.enumerated() {
                    let appendingURL = photoDirFtpURL + "/" + deviceId + "/" + file
                    let localFilePath = localFileAppendingBaseURL + "/" + deviceId + "/" + file
                    
                    dGroup.enter()
                    FtpTools.FtpDownload(appendingURL: appendingURL, localFilePath: localFilePath, finishedCallBack: { (result) in
                        
                        guard let image = result as? String else {
                            dGroup.leave()
                            return
                        }
                        
                        imagesPath.append(image)
                        dGroup.leave()
                        
                    }) { (error) in
                        dGroup.leave()
                        finishWithError(error)
                    }
                    
                    if idx == kRefreshPhotoNum - 1 {
                        break
                    }
                }
                
                /// 所有并行请求都结束后
                dGroup.notify(queue: .main) {
                    /// 将结果回调
                    print("ftp refresh photos ooooooooook")
                    success(imagesPath)
                }
                
            }) { (error) in
                finishWithError(error)
            }
        }
        
    }
}



// MARK: - 以下没用到
extension BasketDetailViewModel {
    func FTPResourceListRequest(deviceId: String, finishedCallBack: @escaping (_ result: Any) -> (), finishWithError: @escaping (_ error: Int) -> ()) {
        
        // TODO: 判断本地是否已经有
        // 如果本地有，而服务器上又有新的图片，又当如何处理
        // 每次先获取列表，接着跟本地目录比，只下载本地没有的图片
        // 这样日积月累，本地图片会很多，是否需要定时清理
        let ftpResourceListURL = baseFtpURL + photoDirFtpURL + "/" + deviceId
        
        FtpTools.FtpResourceList(baseURL: ftpResourceListURL, finishedCallBack: { (result) in
            /// 拿到资源列表
            guard let resArr = result as? [[String: Any]] else { return }
            
            for dict in resArr {
                /// 拿到每张图片的名称
                self.photosName.append(dict["kCFFTPResourceName"] as! String)
            }
            /// 将结果回调
            finishedCallBack(self.photosName)
            
        }) { (error) in
            finishWithError(error)
        }
    }
    
    func FTPDownload(deviceId: String, filesName: [String], finishedCallBack: @escaping (_ result: Any) -> (), finishWithError: @escaping (_ error: Int) -> ()) {
        
        
        for  (idx, file) in filesName.enumerated() {
            
            let appURL = photoDirFtpURL + "/" + deviceId + "/" + file
            let localFilePath = localFileAppendingBaseURL + "/" + deviceId + "/" + file
            
            FtpTools.FtpDownload(appendingURL: appURL, localFilePath: localFilePath, finishedCallBack: { (result) in
                finishedCallBack(result)
            }) { (error) in
                finishWithError(error)
            }
            
            if idx == FtpMaxClient {
                break
            }
        }
        
    }
}
