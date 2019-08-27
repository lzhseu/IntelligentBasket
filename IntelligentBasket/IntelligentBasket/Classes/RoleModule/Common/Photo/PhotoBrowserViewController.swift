//
//  PhotoBrowserViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/27.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import YBImageBrowser

private let kPhotoCellID = "kPhotoCellID"
private let PhotoCollectionViewTag = 2

class PhotoBrowserViewController: RefreshBaseViewController {

    let imageArr = ["image1", "image2", "image3"]
    private lazy var  imageDatas = [YBIBImageData]()
    
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
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
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
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        collectionView.addSubview(photoBrowserCollectionView)
        
        for (idx, data) in imageArr.enumerated() {
            let imageData = YBIBImageData()
            imageData.imageName = data
            imageData.projectiveView = viewAtIndex(index: idx)
            imageDatas.append(imageData)
        }
    }
    
    func viewAtIndex(index: Int) -> UIView? {
        let cell = photoBrowserCollectionView.cellForItem(at: IndexPath(row: index, section: 0))
        return cell?.contentView
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == PhotoCollectionViewTag {
            return imageArr.count
        } else {
            return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == PhotoCollectionViewTag {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPhotoCellID, for: indexPath) as! PhotoViewCell
            cell.image = imageArr[indexPath.item]
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

}

