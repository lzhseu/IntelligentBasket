//
//  LoginViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/16.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import BEMCheckBox
import SnapKit

private let kIconWH: CGFloat = 35


class LoginViewController: BaseViewController {
    
    // MARK: - 懒加载属性
    private lazy var textFieldBgView: UIView = {
        let textFieldBgView = UIView()
        textFieldBgView.backgroundColor = UIColor.white
        return textFieldBgView
    }()
    
    private lazy var phoneField: TextFieldWithIcon = {
        return CommonViewFactory.createTextFieldWithIcon(textFieldType: .PhoneField, placeholder: "手机号", sender: self, image: "icon_user_info")
    }()
    
    private lazy var passwdFeild: TextFieldWithIcon = {
        let passwdField = CommonViewFactory.createTextFieldWithIcon(textFieldType: .PasswordField, placeholder: "密码", sender: self, image: "icon_password")
        passwdField.setReturnKeyType(returnKeyType: .done)
        return passwdField
    }()
    
    private lazy var rememberPasswdCheckBox: UIView = {
        let checkBox = CheckBox(frame: .zero, checkBoxTitle: "记住密码")
        checkBox.delegate = self
        return checkBox
    }()
    
    private lazy var loginBtn: UIButton = { [weak self] in
        let btn = CommonViewFactory.createCustomButton(title: "登录", font: UIFont.systemFont(ofSize: 18), textColor: UIColor.white, backColor: primaryColor, action: #selector(loginBtnClick), sender: self)
        btn.layer.cornerRadius = kButtonCornerRadius
        btn.addTarget(self, action: #selector(btnChangeColor(btn:)), for: .touchDown)
        return btn
    }()
    
    private lazy var registerBtn: UIButton = { [weak self] in
        let btn = CommonViewFactory.createCustomButton(title: "注册", font: UIFont.systemFont(ofSize: 18), textColor: UIColor.white, backColor: primaryColor, action: #selector(registerBtnClick), sender: self)
        btn.layer.cornerRadius = kButtonCornerRadius
        btn.addTarget(self, action: #selector(btnChangeColor(btn:)), for: .touchDown)
        return btn
    }()
    
    private lazy var singleTapGes: UITapGestureRecognizer = { [weak self] in
        return UITapGestureRecognizer(target: self, action: #selector(singleTapAction))
    }()
    
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        makeConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 属性重写
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - 父类方法重新写
    override func setUI() {
        super.setNavigationBar(title: "登 录")
        view.backgroundColor = lightGray
        view.addSubview(textFieldBgView)
        textFieldBgView.addSubview(phoneField)
        textFieldBgView.addSubview(passwdFeild)
        textFieldBgView.addSubview(rememberPasswdCheckBox)

        view.addSubview(loginBtn)
        view.addSubview(registerBtn)
        
        view.addGestureRecognizer(singleTapGes)
    }
    
    override func makeConstraints() {
        textFieldBgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(rememberPasswdCheckBox.snp_bottom).offset(15)
        }
        
        phoneField.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(kTextFieldWithIcon_IconWH)
        }
        
        passwdFeild.snp.makeConstraints { (make) in
            make.top.equalTo(phoneField.snp_bottom).offset(15)
            make.left.width.height.equalTo(phoneField)
        }
        rememberPasswdCheckBox.snp.makeConstraints { (make) in
            make.height.equalTo(kCheckBoxWH)
            make.width.equalTo(passwdFeild)
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(passwdFeild.snp_bottom).offset(25)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(passwdFeild)
            make.top.equalTo(textFieldBgView.snp_bottom).offset(25)
        }
        registerBtn.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(loginBtn)
            make.top.equalTo(loginBtn.snp_bottom).offset(25)
        }
    }

}


// MARK: - 事件监听函数
extension LoginViewController {
    
    @objc private func loginBtnClick(){
        normalViewColor(view: loginBtn)
    }
    
    @objc private func registerBtnClick(){
        normalViewColor(view: registerBtn)
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    /// 按下按钮时改变按钮背景颜色
    @objc private func btnChangeColor(btn: UIButton){
        clickViewColor(view: btn)
    }
    
    /// 单击屏幕可隐藏键盘
    @objc private func singleTapAction(){
        phoneField.getTextField().resignFirstResponder()
        passwdFeild.getTextField().resignFirstResponder()
    }
}


// MARK: - 实现 UITextFieldDelegate, CheckBoxDelegate 代理方法
extension LoginViewController: UITextFieldDelegate, CheckBoxDelegate{
    /// 点击 checkBox
    func tapCheckBox(checkBox: CheckBox) {
        // TODO: 记住密码
    }
    
    /// 点击 checkBoxLabel
    func tapCheckBoxLabel(checkBox: CheckBox) {
        
    }
    
    /// 点击键盘的 return 时，隐藏键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


