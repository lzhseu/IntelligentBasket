//
//  RegisterViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/17.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import SnapKit

private let kButtonW: CGFloat = kScreenW * 2 / 5
private let kButtonEdgeSpace: CGFloat = 20
private let kLabelY: CGFloat = 0.22 * kScreenH


class RegisterViewController: BaseViewController {

    // MARK: - 懒加载属性
    private lazy var tipLable: UILabel = {
        let title = "请选择您想要注册的角色:"
        return CommonViewFactory.createLabel(title: title, font: UIFont.systemFont(ofSize: 20), textColor: UIColor.black, backColor: UIColor.white)
    }()
    
    private lazy var workerBtn: UIButton = { [weak self] in
        let btn = CommonViewFactory.createCustomButton(title: "施工人员", font: UIFont.systemFont(ofSize: 18), textColor: UIColor.white, backColor: primaryColor, action: #selector(workerBtnClick), sender: self)
        btn.layer.cornerRadius = kButtonCornerRadius
        btn.addTarget(self, action: #selector(btnChangeColor(btn:)), for: .touchDown)
        return btn
    }()
    
    private lazy var renterBtn: UIButton = { [weak self] in
        let btn = CommonViewFactory.createCustomButton(title: "租方管理员", font: UIFont.systemFont(ofSize: 18), textColor: UIColor.white, backColor: primaryColor, action: #selector(renterBtnClick), sender: self)
        btn.layer.cornerRadius = kButtonCornerRadius
        btn.addTarget(self, action: #selector(btnChangeColor(btn:)), for: .touchDown)
        return btn
    }()
    
    private lazy var regionBtn: UIButton = { [weak self] in
        let btn = CommonViewFactory.createCustomButton(title: "区域管理员", font: UIFont.systemFont(ofSize: 18), textColor: UIColor.white, backColor: primaryColor, action: #selector(regionBtnClick), sender: self)
        btn.layer.cornerRadius = kButtonCornerRadius
        btn.addTarget(self, action: #selector(btnChangeColor(btn:)), for: .touchDown)
        return btn
        }()
    
    private lazy var inspectorBtn: UIButton = { [weak self] in
        let btn = CommonViewFactory.createCustomButton(title: "巡检人员", font: UIFont.systemFont(ofSize: 18), textColor: UIColor.white, backColor: primaryColor, action: #selector(inspectorBtnClick), sender: self)
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
    
    
    // MARK: - 重写父类方法
    override func setUI() {
        view.backgroundColor = UIColor.white
        super.setNavigationBarTitle(title: "注册-选择角色")
        view.addSubview(tipLable)
        view.addSubview(workerBtn)
        view.addSubview(renterBtn)
        view.addSubview(regionBtn)
        view.addSubview(inspectorBtn)
    }
    
    override func makeConstraints() {
        tipLable.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kLabelY)
        }
        workerBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(tipLable.snp_bottom).offset(30)
            make.width.equalTo(kButtonW)
        }
        renterBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(workerBtn.snp_bottom).offset(kButtonEdgeSpace)
            make.width.equalTo(kButtonW)
        }
        regionBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(renterBtn.snp_bottom).offset(kButtonEdgeSpace)
            make.width.equalTo(kButtonW)
        }
        inspectorBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(regionBtn.snp_bottom).offset(kButtonEdgeSpace)
            make.width.equalTo(kButtonW)
        }
    }

}


// MARK: - 事件监听函数
extension RegisterViewController {
    
    @objc func workerBtnClick(){
        normalViewColor(view: workerBtn)
        pushViewController(viewController: RegisterWorkerViewController(role: UserRole.Worker.rawValue, navTitle: "注册-施工人员"), animated: true)
    }
    
    @objc func renterBtnClick(){
        normalViewColor(view: renterBtn)
        pushViewController(viewController: RegisterBaseViewController(role: UserRole.RentAdmin.rawValue, navTitle: "注册-租方管理员"), animated: true)
    }
    
    @objc func regionBtnClick(){
        normalViewColor(view: regionBtn)
        pushViewController(viewController: RegisterBaseViewController(role: UserRole.AreaAdmin.rawValue, navTitle: "注册-区域管理员"), animated: true)
    }
    
    @objc func inspectorBtnClick(){
        normalViewColor(view: inspectorBtn)
        pushViewController(viewController: RegisterBaseViewController(role: UserRole.Inspector.rawValue, navTitle: "注册-巡检人员"), animated: true)
    }
    
    /// 按下按钮时改变按钮背景颜色
    @objc private func btnChangeColor(btn: UIButton){
        clickViewColor(view: btn)
    }
}


