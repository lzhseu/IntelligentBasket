//
//  PhotoBrowserViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/27.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import YBImageBrowser
import LxFTPRequest
import MJRefresh

private let kPhotoCellID = "kPhotoCellID"
private let PhotoCollectionViewTag = 2

class PhotoBrowserViewController: RefreshBaseViewController {

    var imageArr: [String]? {
        didSet {
            ///设置待展示的照片数据
            imageDatas = []
            
            for (idx, data) in imageArr!.enumerated() {
                let imageData = YBIBImageData()
                imageData.imageName = data
                imageData.projectiveView = viewAtIndex(index: idx)
                imageDatas.append(imageData)
            }
            view.hideLoading()
            photoBrowserCollectionView.reloadData()
        }
    }
    
    var deviceId = ""
    
    private lazy var refreshFooter = MJRefreshAutoNormalFooter()

    private lazy var  imageDatas = [YBIBImageData]()
    
    private lazy var basketDetailVM = BasketDetailViewModel()

    // MARK: - 懒加载属性
    private lazy var photoBrowserCollectionView: UICollectionView = { [unowned self] in
        /// 创建布局
        let padding: CGFloat = 5
        let itemSizeWH: CGFloat = (UIScreen.main.bounds.width - padding * 2) / 3
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSizeWH, height: itemSizeWH)
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        /// 创建UICollectionView
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (self.tabBarController?.tabBar.frame.height ?? 0))
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.tag = PhotoCollectionViewTag
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "PhotoViewCell", bundle: nil), forCellWithReuseIdentifier: kPhotoCellID)

        return collectionView
    }()

    // MARK: - 系统回调函数
    override func viewDidLoad() {
        setItemSizeH(itemSizeH: kScreenH - kStatusBarH - getNavigationBarH())
        //setRefreshFooter()
        setMyRefreshFooter()
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        collectionView.addSubview(photoBrowserCollectionView)
        
        //setMyRefreshFooter()
        
        /// 进来后先等待数据
        view.showLoadingHUD()
        //view.showFullLoading()
        
    }
    
    func viewAtIndex(index: Int) -> UIView? {
        let cell = photoBrowserCollectionView.cellForItem(at: IndexPath(row: index, section: 0))
        return cell?.contentView
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == PhotoCollectionViewTag {
            return imageArr?.count ?? 0
        } else {
            return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == PhotoCollectionViewTag {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPhotoCellID, for: indexPath) as! PhotoViewCell
            cell.image = imageArr![indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRefreshCellIID, for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == PhotoCollectionViewTag {
            let imageBrowser = YBImageBrowser()
            imageBrowser.dataSourceArray = imageDatas
            imageBrowser.currentPage = indexPath.item
            imageBrowser.show()
        }
    }

    func setMyRefreshFooter() {
        refreshFooter.setTitle("点击或上拉刷新数据", for: .idle)
        refreshFooter.setTitle("正在加载数据", for: .refreshing)
        refreshFooter.setTitle("数据加载完毕", for: .noMoreData)
        refreshFooter.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        //是否自动加载（默认为true，即表格滑到底部就自动加载）
        refreshFooter.isAutomaticallyRefresh = false
        photoBrowserCollectionView.mj_footer = refreshFooter
    }
}


// MARK: - 事件监听函数
extension PhotoBrowserViewController {
    
    /// 下拉刷新
    override func headerRefresh() {
        basketDetailVM.getRefreshPhotos(deviceId: deviceId, success: { (result) in
            print("刷新请求数据： \(result)")
            guard let images = result as? [String] else { return }
            self.imageArr = (self.imageArr ?? []) + images
            self.headerEndRefreshing()
        }) { (error) in
            self.headerEndRefreshing()
            if error == NO_MORE_PHOTO {
                self.view.showTip(tip: "百胜吊篮：尚无更多图片！", position: .bottomCenter)
            } else {
                self.view.showTip(tip: "百胜吊篮：图片数据请求失败！", position: .bottomCenter)
            }
            
        }
    }
    
    /// 上拉刷新
    override func footerRefresh() {
        basketDetailVM.getRefreshPhotos(deviceId: deviceId, success: { (result) in
            print("刷新请求数据： \(result)")
            guard let images = result as? [String] else { return }
            self.imageArr = (self.imageArr ?? []) + images
            self.photoBrowserCollectionView.mj_footer.endRefreshing()
        }) { (error) in
            self.photoBrowserCollectionView.mj_footer.endRefreshing()
            if error == NO_MORE_PHOTO {
                self.view.showTip(tip: "百胜吊篮：尚无更多图片！", position: .bottomCenter)
            } else {
                self.view.showTip(tip: "百胜吊篮：图片数据请求失败！", position: .bottomCenter)
            }
            
        }
    }
}
