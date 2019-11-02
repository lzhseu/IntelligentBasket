//
//  LZHSearchController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/11/2.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

fileprivate let kLzhSearchTintColor = UIColor(r: 0.12, g: 0.74, b: 0.13, alpha: 1)
let kSectionColor = contentBgColor

class LZHSearchController: UISearchController {
    // MARK: - 懒加载属性
    lazy var hasFindCancelBtn: Bool = {
        return false
    }()
    
    lazy var link: CADisplayLink = {
        CADisplayLink(target: self, selector: #selector(findCancel))
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - 相关设置
extension LZHSearchController {
    func setup() {
        searchBar.barTintColor = kSectionColor
        
        // 搜索框
        searchBar.barStyle = .default
        searchBar.tintColor = kLzhSearchTintColor
        
        searchBar.delegate = self
    }
}

// MARK: - 事件监听函数
extension LZHSearchController {
    @objc private func findCancel() {
        let btn = searchBar.value(forKey: "_cancelButton") as AnyObject
        if btn.isKind(of: NSClassFromString("UINavigationButton")!) {
            link.invalidate()
            link.remove(from: RunLoop.current, forMode: .common)
            hasFindCancelBtn = true
            let cancel = btn as! UIButton
            cancel.setTitleColor(kLzhSearchTintColor, for: .normal)
            // cancel.setTitleColor(UIColor.orange, for: .highlighted)
        }
    }
}

// MARK: - UISearchBarDelegate
extension LZHSearchController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if !hasFindCancelBtn {
            link.add(to: RunLoop.current, forMode: .common)
        }
    }
}
