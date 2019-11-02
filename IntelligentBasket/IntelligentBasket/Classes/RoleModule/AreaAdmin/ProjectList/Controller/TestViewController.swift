//
//  TestViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/11/2.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import SnapKit

private let kItemW = kScreenW
private let kItemH: CGFloat = 180  //kItemW / 3 + 40
private let kTableCellID = "kTableCellID"


class TestViewController: RoleBaseViewController {
    
    // MARK: - 懒加载属性
    private lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 44, right: 0)
        //tableView.scrollIndicatorInsets = UIEdgeInsets(top: 64, left: 0, bottom: 44, right: 0)
        tableView.rowHeight = kItemH
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kTableCellID)
        tableView.tableFooterView = UIView(frame: .zero)
        //以下代码关闭估算行高,从而解决底下留白的bug
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        // 改变索引的颜色
        //tableView.sectionIndexColor = UIColor.black
        // 改变索引背景颜色
        //tableView.sectionIndexBackgroundColor = UIColor.clear
        // 改变索引被选中的背景颜色
        // table.sectionIndexTrackingBackgroundColor = UIColor.green
        return tableView
    }()
    
    var searchController: LZHSearchController?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    
    override func setUI() {
        searchController = LZHSearchController(searchResultsController: UITableViewController())
        tableView.tableHeaderView = searchController?.searchBar
        view.addSubview(tableView)
    }

}


extension TestViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTableCellID)
        cell!.backgroundColor = indexPath.item % 2 == 0 ? UIColor.red : UIColor.blue
        return cell!
    }
    
    
}
