//
//  PageMenu.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/21.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import PagingMenuController

struct PagingMenuOptions: PagingMenuControllerCustomizable {
    
    var childVc = [UIViewController]()
    var menuItems = [MenuItemViewCustomizable]()
    
    var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(menuItems: menuItems), pagingControllers: childVc)
    }
    
    var isScrollEnabled: Bool {
        return true
    }
    
    
}

/// 菜单配置项
struct MenuOptions: MenuViewCustomizable {

    var menuItems =  [MenuItemViewCustomizable]()

    var displayMode: MenuDisplayMode {
        return .standard(widthMode: .fixed(width: 40), centerItem: false, scrollingMode: .scrollEnabled)
        //return .segmentedControl
    }

    var itemsOptions: [MenuItemViewCustomizable] {
        return menuItems
    }
    
}


class PageMenuController {

    class func create(childVc: [UIViewController], menuItems: [MenuItemViewCustomizable]) -> PagingMenuController{
        let pagingMenuOptions = PagingMenuOptions(childVc: childVc, menuItems: menuItems)
        return PagingMenuController(options: pagingMenuOptions)
    }
    
}


