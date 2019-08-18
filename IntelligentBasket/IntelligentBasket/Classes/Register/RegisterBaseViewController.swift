//
//  RegisterBaseViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/18.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import SnapKit

private let kImageBgViewH = 0.22 * kScreenH
private let kImageViewH = kImageBgViewH * 2 / 3
private let kShortButtonW = kScreenW / 2 - 30 * 2

class RegisterBaseViewController: BaseViewController {
    
    // MARK: - 自定义属性
    var role = ""         //角色
    var image = "ic_launcher"

    // MARK: - 懒加载属性
    private lazy var titleLabel: UILabel = {
        return CommonViewFactory.createLabel(title: "基本信息", font: UIFont.systemFont(ofSize: 18), textColor: UIColor.gray)
    }()
    
    private lazy var textFieldBgView: UIView = {
        let textFieldBgView = UIView()
        textFieldBgView.backgroundColor = UIColor.white
        return textFieldBgView
    }()
    
    private lazy var phoneField: TextFieldWithIcon = {
        return CommonViewFactory.createTextFieldWithIcon(textFieldType: .PhoneField, placeholder: "手机号", sender: self, image: "icon_phone")
    }()
    
    private lazy var usernameFeild: TextFieldWithIcon = {
        let usernameFeild = CommonViewFactory.createTextFieldWithIcon(textFieldType: .NormalTextField, placeholder: "密码", sender: self, image: "icon_user_info")
        usernameFeild.setReturnKeyType(returnKeyType: .done)
        return usernameFeild
    }()
    
    private lazy var passwdFeild: TextFieldWithIcon = {
        let passwdField = CommonViewFactory.createTextFieldWithIcon(textFieldType: .PasswordField, placeholder: "输入密码", sender: self, image: "icon_password")
        passwdField.setReturnKeyType(returnKeyType: .done)
        return passwdField
    }()
    
    private lazy var passwdAgainFeild: TextFieldWithIcon = {
        let passwdField = CommonViewFactory.createTextFieldWithIcon(textFieldType: .PasswordField, placeholder: "再次输入密码", sender: self, image: "icon_password")
        passwdField.setReturnKeyType(returnKeyType: .done)
        return passwdField
    }()
    
    private lazy var imageBgView: UIView = {
        let imageBgView = UIView()
        imageBgView.backgroundColor = UIColor.white
        return imageBgView
    }()
    
    private lazy var imageView: UIImageView = {
        return CommonViewFactory.createImageView(image: image)
    }()
    
    private lazy var takePhotoBtn: UIButton = {
        let btn = CommonViewFactory.createCustomButton(title: "拍摄照片", font: UIFont.systemFont(ofSize: 18), textColor: UIColor.white, backColor: primaryColor, action: #selector(takePhotoBtnClick), sender: self)
        btn.layer.cornerRadius = kButtonCornerRadius
        btn.addTarget(self, action: #selector(btnChangeColor(btn:)), for: .touchDown)
        return btn
    }()
    
    private lazy var pickPhotoBtn: UIButton = {
        let btn = CommonViewFactory.createCustomButton(title: "从相册中选择", font: UIFont.systemFont(ofSize: 18), textColor: UIColor.white, backColor: primaryColor, action: #selector(pickPhotoBtnClick), sender: self)
        btn.layer.cornerRadius = kButtonCornerRadius
        btn.addTarget(self, action: #selector(btnChangeColor(btn:)), for: .touchDown)
        return btn
    }()
    
    private lazy var confirmBtn: UIButton = {
        let btn = CommonViewFactory.createCustomButton(title: "确认注册", font: UIFont.systemFont(ofSize: 18), textColor: UIColor.white, backColor: primaryColor, action: #selector(confirmBtnClick), sender: self)
        btn.layer.cornerRadius = kButtonCornerRadius
        btn.addTarget(self, action: #selector(btnChangeColor(btn:)), for: .touchDown)
        return btn
    }()
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        makeConstraints()
    }
    
    // MARK: - 构造函数
    init(role: String){
        super.init(nibName: nil, bundle: nil)
        self.role = role
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 属性重写
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - 重写父类函数
    override func setUI() {
        view.backgroundColor = lightGray
        setNavigationBarTitle(title: role)
        
        view.addSubview(titleLabel)
        view.addSubview(textFieldBgView)
        textFieldBgView.addSubview(phoneField)
        textFieldBgView.addSubview(usernameFeild)
        textFieldBgView.addSubview(passwdFeild)
        textFieldBgView.addSubview(passwdAgainFeild)
        
        view.addSubview(imageBgView)
        imageBgView.addSubview(imageView)
        
        view.addSubview(takePhotoBtn)
        view.addSubview(pickPhotoBtn)
        view.addSubview(confirmBtn)
    }
    
    override func makeConstraints() {
        makeConstraintsForTextField(superView: view)
        makeConstraintsForImageView(superView: view, referenceView: textFieldBgView)
        makeConstraintsForButton(superView: view, referenceView: imageBgView)
    }
    
    // MARK: - UI封装，方便子类使用
    func makeConstraintsForTextField(superView: UIView) {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(superView).offset(5)
            make.top.equalTo(superView).offset(20)
        }
        textFieldBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(superView)
            make.top.equalTo(titleLabel.snp_bottom).offset(3)
            make.bottom.equalTo(passwdAgainFeild.snp_bottom).offset(10)
        }
        phoneField.snp.makeConstraints { (make) in
            make.top.left.equalTo(textFieldBgView).offset(10)
            make.right.equalTo(textFieldBgView).offset(-5)
            make.height.equalTo(kTextFieldWithIcon_IconWH)
        }
        usernameFeild.snp.makeConstraints { (make) in
            make.top.equalTo(phoneField.snp_bottom).offset(10)
            make.left.width.height.equalTo(phoneField)
        }
        passwdFeild.snp.makeConstraints { (make) in
            make.top.equalTo(usernameFeild.snp_bottom).offset(10)
            make.left.width.height.equalTo(phoneField)
        }
        passwdAgainFeild.snp.makeConstraints { (make) in
            make.top.equalTo(passwdFeild.snp_bottom).offset(10)
            make.left.width.height.equalTo(phoneField)
        }
    }
    
    func makeConstraintsForImageView(superView: UIView, referenceView: UIView) {
        imageBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(superView)
            make.top.equalTo(referenceView.snp_bottom).offset(kSpaceBetweenModule)
            make.height.equalTo(kImageBgViewH)
        }
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(imageBgView)
            make.height.width.equalTo(kImageViewH)
        }
    }
    
    func makeConstraintsForButton(superView: UIView, referenceView: UIView) {
        takePhotoBtn.snp.makeConstraints { (make) in
            make.left.equalTo(superView).offset(30)
            make.top.equalTo(referenceView.snp_bottom).offset(kSpaceBetweenModule)
            //make.height.equalTo(phoneField)
            make.width.equalTo(kShortButtonW)
        }
        pickPhotoBtn.snp.makeConstraints { (make) in
            make.right.equalTo(superView).offset(-30)
            make.centerY.equalTo(takePhotoBtn)
            make.width.height.equalTo(takePhotoBtn)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.right.equalTo(pickPhotoBtn)
            make.left.equalTo(takePhotoBtn)
            make.top.equalTo(takePhotoBtn.snp_bottom).offset(25)
            make.height.equalTo(takePhotoBtn)
        }
    }

}


// MARK: - 事件监听函数
extension RegisterBaseViewController {
    
    @objc private func takePhotoBtnClick() {
        normalViewColor(view: takePhotoBtn)
    }
    
    @objc private func pickPhotoBtnClick() {
        normalViewColor(view: pickPhotoBtn)
    }
    
    @objc private func confirmBtnClick() {
        normalViewColor(view: confirmBtn)
    }
    
    /// 按下按钮时改变按钮背景颜色
    @objc private func btnChangeColor(btn: UIButton) {
        clickViewColor(view: btn)
    }
}


// MARK: - 实现代理方法 UITextFieldDelegate
extension RegisterBaseViewController: UITextFieldDelegate {
    /// 点击键盘的 return 时，隐藏键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - 对外暴露的方法
extension RegisterBaseViewController {
    
    func getTextFieldBgView() -> UIView {
        return textFieldBgView
    }
    
    func getimageBgView() -> UIView {
        return imageBgView
    }
    
}
