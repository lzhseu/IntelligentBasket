//
//  BasketListViewCell.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/10/17.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class BasketListViewCell: UICollectionViewCell {

    // MARK: - 自定义属性
    var usingBasketModel: UsingBasketModel? {
        didSet {
            if let workState = usingBasketModel?.workingState {
                switch workState {
                case 0:
                    isUsingLabel.text = "未使用"
                    isUsingLabel.textColor = UIColor.red
                case 1:
                    isUsingLabel.text = "使用中"
                    isUsingLabel.textColor = primaryColor
                default:
                    isUsingLabel.text = "吊篮状态未知"
                    isUsingLabel.textColor = UIColor.yellow
                }
            } else {
                isUsingLabel.text = "吊篮状态未知"
                isUsingLabel.textColor = UIColor.yellow
            }
            deviceIdLabel.text = usingBasketModel?.deviceId
        }
    }
    
    var superController: BaseViewController?
    
    // MARK: - 懒加载属性
    private lazy var basketDetailVM = BasketDetailViewModel()
    
    // MARK: - 控件属性
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var vedio1ImageView: UIImageView!
    @IBOutlet weak var vedio2ImageView: UIImageView!
    @IBOutlet weak var isUsingLabel: UILabel!
    @IBOutlet weak var deviceIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(photoImageViewTapped)))
        vedio1ImageView.isUserInteractionEnabled = true
        vedio1ImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(vedio1ImageViewTapped)))
        vedio2ImageView.isUserInteractionEnabled = true
        vedio2ImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(vedio2ImageViewTapped)))
    }

}

// MARK: - 事件监听函数
extension BasketListViewCell {
    
    @objc private func photoImageViewTapped() {
//        guard let deviceId = self.usingBasketModel?.deviceId else {
//            self.superController?.view.showTip(tip: "百胜吊篮：设备号无效！")
//            return
//        }
        let deviceId = "10006732"
        let photoVc = PhotoBrowserViewController()
        photoVc.deviceId = deviceId
        superController!.pushViewController(viewController: photoVc, animated: true)
        
        basketDetailVM.getPhotos(deviceId: deviceId, success: { (result) in
            guard let images = result as? [String] else { return }
            photoVc.imageArr = images
        }) { (error) in
            photoVc.view.hideLoading()
            switch error {
            case 550:
                photoVc.view.showTip(tip: "百胜吊篮：没有更多图片！", position: .bottomCenter)
            default:
                photoVc.view.showTip(tip: "百胜吊篮：图片数据请求失败！", position: .bottomCenter)
            }
        }
    }
    
    @objc private func vedio1ImageViewTapped() {
        guard  let deviceId = usingBasketModel?.deviceId else {
            superController?.view.showTip(tip: "百胜吊篮：设备号无效！", position: .bottomCenter)
            return
        }
        
        let token = UserDefaultStorage.getToken() ?? ""
        HttpTools.requestDeviceVideo(deviceId: deviceId, token: token, finishedCallBack: { (result) in
            if (result as! String) == "success" {
                /// 进入播放视频页面
                let playUrl = baseRtmpURL + "/" + deviceId
                self.superController?.present(PLPlayerViewController(playUrl: playUrl), animated: true, completion: nil)
            } else {
                self.superController?.view.showTip(tip: "百胜吊篮：获取设备视频失败！", position: .bottomCenter)
            }
            
        }) { (error) in
            print("get vedio: \(error)")
            self.superController?.view.showTip(tip: "百胜吊篮：获取设备视频失败！", position: .bottomCenter)
        }
        
    }
    
    @objc private func vedio2ImageViewTapped() {
        superController?.present(PLPlayerViewController(playUrl: "rtmp://202.69.69.180:443/webcast/bshdlive-pc"), animated: true, completion: nil)
    }
}
