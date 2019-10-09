//
//  BasketDetailViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/22.
//  Copyright © 2019 zhineng. All rights reserved.
//

/*
 * 区域管理员 -> 项目 -> 使用中 -> 吊篮详情
 */

import UIKit
import Alamofire

private let kCircleBtnWH: CGFloat = kScreenW / 4

class BasketDetailViewController: RoleBaseViewController {
    
    // MARK: - 自定义属性
    var deviceId: String?
    var name: String?
    
    // MARK: - 懒加载属性
    private lazy var paramBtn: CircleButton = { [weak self] in
        let btn = CircleButton(frame: .zero, text: "参数", image: "ic_parameter_192")
        btn.addGestureRecognizer(UITapGestureRecognizer(target: self!, action: #selector(paramBtnClick)))
        return btn
    }()
    
    private lazy var pictureBtn: CircleButton = { [weak self] in
        let btn = CircleButton(frame: .zero, text: "图片", image: "ic_image_192")
        btn.addGestureRecognizer(UITapGestureRecognizer(target: self!, action: #selector(pictureBtnClick)))
        return btn
    }()
    
    private lazy var videoBtn: CircleButton = { [weak self] in
        let btn = CircleButton(frame: .zero, text: "监控", image: "ic_video_192")
        btn.addGestureRecognizer(UITapGestureRecognizer(target: self!, action: #selector(videoBtnClick)))
        return btn
    }()
    
    private lazy var settingBtn: CircleButton = { [weak self] in
        let btn = CircleButton(frame: .zero, text: "设置", image: "ic_setting_192")
        btn.addGestureRecognizer(UITapGestureRecognizer(target: self!, action: #selector(settingBtnClick)))
        return btn
    }()
    
    private lazy var fixBtn: CircleButton = { [weak self] in
        let btn = CircleButton(frame: .zero, text: "报修", image: "ic_repair_192")
        btn.addGestureRecognizer(UITapGestureRecognizer(target: self!, action: #selector(fixBtnClick)))
        //btn.addTarget(self, action: #selector(btnChangeColor(btn:)), for: .touchDown)
        return btn
    }()
    
    private lazy var deviceIdTitleLabel: UILabel = {
        return CommonViewFactory.createLabel(title: "吊篮编号", font: UIFont.systemFont(ofSize: 18), textColor: UIColor.black)
    }()
    
    private lazy var deviceIdContentLabel: UILabel = { [weak self] in
        let label = UILabel()
        label.text = self!.deviceId
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var nameTitleLabel: UILabel = {
        return CommonViewFactory.createLabel(title: "负责人", font: UIFont.systemFont(ofSize: 18), textColor: UIColor.black)
    }()
    
    private lazy var nameContentLabel: UILabel = { [weak self] in
        let label = UILabel()
        if self?.name == "" {
            label.text = "负责人姓名"
        } else {
            label.text = self!.name
        }
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var basketDetailVM = BasketDetailViewModel()
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUI()
        makeConstraints()
    }
    
    init(deviceId: String?, name: String? = "负责人姓名"){
        super.init(nibName: nil, bundle: nil)
        self.deviceId = deviceId
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - 重写父类方法
    override func setUI() {
        setNavigationBarTitle(title: "吊篮详情")
        view.addSubview(paramBtn)
        view.addSubview(pictureBtn)
        view.addSubview(videoBtn)
        view.addSubview(settingBtn)
        view.addSubview(fixBtn)
        view.addSubview(deviceIdTitleLabel)
        view.addSubview(deviceIdContentLabel)
        view.addSubview(nameTitleLabel)
        view.addSubview(nameContentLabel)
    }
    
    override func makeConstraints() {
        deviceIdTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
        }
        
        deviceIdContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(deviceIdTitleLabel.snp_right).offset(10)
            make.centerY.equalTo(deviceIdTitleLabel)
        }
        
        nameTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(deviceIdTitleLabel)
            make.top.equalTo(deviceIdTitleLabel.snp_bottom).offset(20)
        }
        
        nameContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(deviceIdContentLabel)
            make.centerY.equalTo(nameTitleLabel)
        }
        
        paramBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(kCircleBtnWH)
            make.left.equalToSuperview()
            make.top.equalTo(nameTitleLabel.snp_bottom).offset(40)
        }
        
        pictureBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(paramBtn)
            make.left.equalTo(paramBtn.snp_right)
            make.top.equalTo(paramBtn)
        }
        
        videoBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(pictureBtn)
            make.left.equalTo(pictureBtn.snp_right)
            make.top.equalTo(pictureBtn)
        }
        
        settingBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(videoBtn)
            make.left.equalTo(videoBtn.snp_right)
            make.top.equalTo(videoBtn)
        }
        
        fixBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(paramBtn)
            make.left.equalTo(paramBtn)
            make.top.equalTo(paramBtn.snp_bottom)
        }
        
    }
  
}


// MARK: - 事件监听函数
extension BasketDetailViewController {
    
    @objc private func paramBtnClick() {
        
    }
    
    @objc private func pictureBtnClick() {
        // TODO: ftp下载照片
        // TODO: 下载前先判断本地有没有
        guard  let deviceId = self.deviceId else {
            return
        }
        
        let photoVc = PhotoBrowserViewController()
        photoVc.deviceId = deviceId
        pushViewController(viewController: photoVc, animated: true)
        
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
    
    @objc private func videoBtnClick() {
        guard  let deviceId = deviceId else {
            view.showTip(tip: "百胜吊篮：当前没有吊篮！", position: .bottomCenter)
            return
        }
        
        let token = UserDefaultStorage.getToken() ?? ""
        HttpTools.requestDeviceVideo(deviceId: deviceId, token: token, finishedCallBack: { (result) in
            if (result as! String) == "success" {
                /// 进入播放视频页面
                let playUrl = baseRtmpURL + "/" + deviceId
                self.present(PLPlayerViewController(playUrl: playUrl), animated: true, completion: nil)
            } else {
                self.view.showTip(tip: "百胜吊篮：获取设备视频失败！", position: .bottomCenter)
            }
            
        }) { (error) in
            print("get vedio: \(error)")
            self.view.showTip(tip: "百胜吊篮：获取设备视频失败！", position: .bottomCenter)
        }
        

    }
    
    @objc private func settingBtnClick() {
    }
    
    @objc private func fixBtnClick() {
        present(PLPlayerViewController(playUrl: "rtmp://202.69.69.180:443/webcast/bshdlive-pc"), animated: true, completion: nil)
    }
    
}



