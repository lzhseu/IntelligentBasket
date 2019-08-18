//
//  RegisterWorkerViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/17.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import SnapKit
import LMJDropdownMenu

private let kMenuH: CGFloat = 35

class RegisterWorkerViewController: RegisterBaseViewController {

    // MARK: - 自定义属性
    private var menuOptions = kWorkTypeArr    /// 工种的数据是从后台获得的还是写死的？ 此处先写死
    
    // MARK: - 懒加载属性
    private lazy var menu: LMJDropdownMenu = {
        let menuFrame = CGRect(x: 0, y: 0, width: kScreenW, height: kMenuH)
        let menu = LMJDropdownMenu()
        menu.frame = menuFrame
        menu.title = "选择工种"
        menu.titleBgColor = UIColor.white
        menu.titleFont = UIFont.systemFont(ofSize: 18)
        menu.titleColor = UIColor.gray
        menu.rotateIcon = UIImage(named: "icon_dropdown")!
        menu.rotateIconSize = CGSize(width: 20, height: 20)
        
        menu.optionFont = UIFont.systemFont(ofSize: 18)
        menu.optionBgColor  =  lightGray
        menu.optionTextColor = UIColor.black
        menu.optionNumberOfLines = 0
        
        menu.dataSource = self
        menu.delegate = self
        
        return menu
    }()
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setMyUI()
    }
    
    // MARK: - 重写父类方法
    override func makeConstraints() {}
    
    // MARK: - UI封装
    private func setMyUI() {
        setUI()
        view.addSubview(menu)
        
        makeConstraintsForTextField(superView: view)
        makeConstraintsForMenu()
        makeConstraintsForImageView(superView: view, referenceView: menu)
        makeConstraintsForButton(superView: view, referenceView: getimageBgView())
    }
    
    func makeConstraintsForMenu(){
        menu.snp.makeConstraints { (make) in
            make.width.left.right.equalTo(view)
            make.height.equalTo(35)
            make.top.equalTo(getTextFieldBgView().snp_bottom).offset(30)
        }
    }
    
}


// MARK: - 实现代理方法 LMJDropdownMenuDelegate, 遵守数据源协议 LMJDropdownMenuDataSource
extension RegisterWorkerViewController: LMJDropdownMenuDelegate, LMJDropdownMenuDataSource {
    func numberOfOptions(in menu: LMJDropdownMenu) -> UInt {
        return UInt(menuOptions.count)
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, heightForOptionAt index: UInt) -> CGFloat {
        return kMenuOptionH
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, titleForOptionAt index: UInt) -> String {
        if menuOptions.count > 0 {
            return menuOptions[Int(index)]
        }
        return ""
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, didSelectOptionAt index: UInt, optionTitle title: String) {
        // TODO: 在此方法中实现选择工种后的操作
    }
    
}
