//
//  YLAlbumPickerController.swift
//  YLImagePickerController
//
//  Created by yl on 2017/8/30.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit
import Photos

class YLAlbumPickerController: UIViewController {
    
    var tableView: UITableView = {
        
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 60, bottom: 0, right: 0)
        
        return tableView
    }()
    
    var dataArray = [PHAssetCollection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "照片"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "取消", style: UIBarButtonItemStyle.done, target: self.navigationController, action: #selector(YLImagePickerController.goBack))
        
        
        layoutUI()
        
        loadData()
    }
    
    
    /// 加载UI
    func layoutUI() {
        
        tableView.register(UINib.init(nibName: "YLAlbumCell", bundle: Bundle.yl_imagePickerNibBundle()), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        // 约束
        tableView.addConstraints(toItem: view, edgeInsets: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        view.layoutIfNeeded()
    }
    
    
    /// 添加数据
    func loadData() {
        
        dataArray.removeAll()
        
        DispatchQueue.global().async { [weak self] in
            
            let smartAssetCollections = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
            
            smartAssetCollections.enumerateObjects({ (assetCollection, _, _) in
                
                let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
                
                if assets.count != 0 {
                    self?.dataArray.append(assetCollection)
                }
            })
            
            let userAssetCollections = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
            
            userAssetCollections.enumerateObjects({ (assetCollection, _, _) in
                
                let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
                
                if assets.count != 0 {
                    self?.dataArray.append(assetCollection)
                }
                
            })
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}


// MARK: - UITableViewDelegate,UITableViewDataSource
extension YLAlbumPickerController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? YLAlbumCell
        
        let assetCollection = dataArray[indexPath.row]
        let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
        
        cell?.albumName.text = assetCollection.localizedTitle
        cell?.albumCount.text = "(\(String(assets.count)))"
        
        if let asset = assets.lastObject {
            
            let options = PHImageRequestOptions()
            options.resizeMode = PHImageRequestOptionsResizeMode.fast
            options.isSynchronous = true
            
            PHImageManager.default().requestImage(for: asset, targetSize: thumbnailSize, contentMode: PHImageContentMode.aspectFill, options: options) { (image:UIImage?, _) in
                cell?.albumImageView.image = image
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let photoPicker = YLPhotoPickerController()
        photoPicker.assetCollection = dataArray[indexPath.row]
        navigationController?.pushViewController(photoPicker, animated: true)
        
    }
}
