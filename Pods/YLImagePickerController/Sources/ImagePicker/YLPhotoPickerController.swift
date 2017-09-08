//
//  YLPhotoPickerController.swift
//  YLImagePickerController
//
//  Created by yl on 2017/8/30.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit
import Photos
import TOCropViewController

class YLPhotoPickerController: UIViewController {
    // 指定相册
    var assetCollection: PHAssetCollection?
    
    var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        let width = YLScreenW > YLScreenH ? YLScreenH : YLScreenW
        let wh = (width - 25.0) / 4.0
        layout.itemSize = CGSize.init(width: wh, height: wh)
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        
        return collectionView
    }()
    
    var toolbar : YLToolbarBottom = {
        
        let toolbar = YLToolbarBottom.loadNib()
        toolbar.sendBtnIsSelect(false)
        toolbar.sendBtn.addTarget(self, action: #selector(YLPhotoPickerController.sendBtnHandle), for: UIControlEvents.touchUpInside)
        return toolbar
    }()
    
    // 所有资源
    var photos = [YLAssetModel]()
    // 已经选择的资源
    var selectPhotos = [YLAssetModel]()
    
    deinit {
        print("释放\(self)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = YLScreenW
        if YLScreenW > YLScreenH {
            YLScreenW = YLScreenH
            YLScreenH = width
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "取消", style: UIBarButtonItemStyle.done, target: self.navigationController, action: #selector(YLImagePickerController.goBack))
        
        view.backgroundColor = UIColor.white
        
        layoutUI()
        
        loadData()
    }
    
    func layoutUI() {
        
        collectionView.register(UINib.init(nibName: "YLThumbnailCell", bundle: Bundle.yl_imagePickerNibBundle()), forCellWithReuseIdentifier: "cell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let imagePicker = navigationController as! YLImagePickerController
        
        view.addSubview(collectionView)
        
        // 约束
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        var edgeInsets = UIEdgeInsets.zero
        if imagePicker.isOneChoose == false {
            edgeInsets = UIEdgeInsets.init(top: 70, left: 5, bottom: -44, right: -5)
        }else {
            edgeInsets = UIEdgeInsets.init(top: 70, left: 5, bottom: 0, right: -5)
        }
        collectionView.addLayoutConstraint(toItem: view, edgeInsets: edgeInsets)
        
        
        if imagePicker.isOneChoose == false {
        
            view.addSubview(toolbar)
            // 约束
            toolbar.translatesAutoresizingMaskIntoConstraints = false
            toolbar.addLayoutConstraint(attribute: NSLayoutAttribute.left, toItem: view, constant: 0)
            toolbar.addLayoutConstraint(attribute: NSLayoutAttribute.right, toItem: view, constant: 0)
            toolbar.addLayoutConstraint(attribute: NSLayoutAttribute.bottom, toItem: view, constant: 0)
            toolbar.addLayoutConstraint(attribute: NSLayoutAttribute.height, constant: 44)
            
        }
        
        view.layoutIfNeeded()
    }
    
    func loadData() {
        
        DispatchQueue.global().async { [weak self] in
            
            if self?.assetCollection == nil {
                
                let smartAssetCollections = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
                
                smartAssetCollections.enumerateObjects({ (assetCollection, _, _) in
                    
                    if assetCollection.assetCollectionSubtype == PHAssetCollectionSubtype.smartAlbumUserLibrary {
                        
                        self?.assetCollection = assetCollection
                        return
                    }
                })
            }
            
            if let assetCollection = self?.assetCollection {
                
                let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
                
                assets.enumerateObjects({ (asset: PHAsset, _, _) in
                    
                    let assetModel = YLAssetModel()
                    assetModel.asset = asset
                    
                    self?.photos.append(assetModel)
                })
                
            }
            
            DispatchQueue.main.async {
                self?.navigationItem.title = self?.assetCollection?.localizedTitle
                self?.collectionView.reloadData()
            }
        }
        
    }
    
    func sendBtnHandle() {
        epPhotoBrowserBySendBtnHandle(-1)
    }
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension YLPhotoPickerController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: YLThumbnailCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! YLThumbnailCell
        
        cell.delegate = self
        
        cell.isSelected = false
        
        let assetModel = photos[indexPath.row]
        
        if assetModel.thumbnailImage == nil {
            
            let options = PHImageRequestOptions()
            options.resizeMode = PHImageRequestOptionsResizeMode.fast
            options.isSynchronous = true
            
            PHImageManager.default().requestImage(for: assetModel.asset, targetSize: thumbnailSize, contentMode: PHImageContentMode.aspectFill, options: options, resultHandler: { (image:UIImage?, _) in
                
                assetModel.thumbnailImage = image
            })
        }
        
        let imagePicker = navigationController as! YLImagePickerController
        
        cell.updateAssetModel(assetModel, isOneChoose: imagePicker.isOneChoose)
        
        return cell
        
    }
}

// MARK: - YLThumbnailCellDelegate
extension YLPhotoPickerController :YLThumbnailCellDelegate {
    
    func epPhotoTagBtnHandle(_ assetModel: YLAssetModel) {
        
        if assetModel.isSelected == false {
            
            let imagePicker = navigationController as! YLImagePickerController
            
            if selectPhotos.count >= imagePicker.maxImagesCount {
                UIAlertView.init(title: nil, message: "最多只能选择\(imagePicker.maxImagesCount)张照片", delegate: nil, cancelButtonTitle: "确定").show()
                return
            }
            
            
            assetModel.isSelected = true
            selectPhotos.append(assetModel)
            
            assetModel.selectedSerialNumber = selectPhotos.count
            
            if let row = photos.index(where: { $0 === assetModel }) {
                collectionView.reloadItems(at: [IndexPath.init(row: row, section: 0)])
            }
            
        }else {
            assetModel.isSelected = false
            
            var indexPaths = [IndexPath]()
            
            if let row = photos.index(where: { $0 === assetModel }) {
                indexPaths.append(IndexPath.init(row: row, section: 0))
            }
            
            if let index = selectPhotos.index(where: { $0 === assetModel }) {
                selectPhotos.remove(at: index)
            }
            
            if selectPhotos.count > 0 {
                for index in 0...(selectPhotos.count - 1) {
                    let asset = selectPhotos[index]
                    if asset.selectedSerialNumber != index + 1 {
                        asset.selectedSerialNumber = index + 1
                        if let row = photos.index(where: { $0 === asset }) {
                            indexPaths.append(IndexPath.init(row: row, section: 0))
                        }
                    }
                }
            }
            
            collectionView.reloadItems(at: indexPaths)
        }
        
        if selectPhotos.count == 0 {
            toolbar.sendBtnIsSelect(false)
        }else {
            toolbar.sendBtnIsSelect(true)
        }
    }
    
    func epImageViewHandle(_ assetModel: YLAssetModel) {
        
        let options = PHImageRequestOptions()
        options.resizeMode = PHImageRequestOptionsResizeMode.fast
        options.isSynchronous = true
        
        let imagePicker = navigationController as! YLImagePickerController
        
        if imagePicker.isOneChoose == true {
            
            PHImageManager.default().requestImage(for: assetModel.asset, targetSize: CGSize.init(width: assetModel.asset.pixelWidth, height: assetModel.asset.pixelHeight), contentMode: PHImageContentMode.aspectFill, options: options, resultHandler: { (result:UIImage?, _) in
                
                if let image = result {
                
                    if imagePicker.cropType != CropType.none {
                        
                        // 单选 裁剪
                        var style = TOCropViewCroppingStyle.default
                        if imagePicker.cropType == CropType.circular {
                            style = TOCropViewCroppingStyle.circular
                        }
                        
                        let cropViewController = TOCropViewController.init(croppingStyle: style, image: image)
                        cropViewController.delegate = self
                        self.navigationController?.pushViewController(cropViewController, animated: true)
                        
                    }else {
                        // 单选 不裁剪
                        imagePicker.didFinishPickingPhotosHandle?([image])
                        imagePicker.goBack()
                    }
                    
                }
                
            })
            
        }else {
            
            if let row = self.photos.index(where: { $0 === assetModel }) {
                let photoBrowser = YLPhotoBrowser.init(row, self)
                self.navigationController?.pushViewController(photoBrowser, animated: true)
            }
        }
    }
}


// MARK: - YLPhotoBrowserDelegate
extension YLPhotoPickerController: YLPhotoBrowserDelegate {

    func epPhotoBrowserGetPhotoCount() -> Int {
        return photos.count
    }
    
    func epPhotoBrowserGetPhotoByCurrentIndex(_ currentIndex: Int) -> YLPhoto {
        
        let options = PHImageRequestOptions()
        options.resizeMode = PHImageRequestOptionsResizeMode.fast
        options.isSynchronous = true
        
        let assetModel = photos[currentIndex]
        
        var photo: YLPhoto?
        
        let aspectRatio: CGFloat = CGFloat(assetModel.asset.pixelWidth) / CGFloat(assetModel.asset.pixelHeight)
        var pixelWidth: CGFloat = collectionView.frame.width * 2
        // 超宽图片
        if aspectRatio > 1.8 {
            pixelWidth = pixelWidth * aspectRatio
        }
        // 超高图片
        if aspectRatio < 0.2 {
            pixelWidth = pixelWidth * 0.5
        }
        var pixelHeight:CGFloat = pixelWidth / aspectRatio
        
        if pixelWidth > CGFloat(assetModel.asset.pixelWidth) ||
            pixelHeight > CGFloat(assetModel.asset.pixelHeight) {
            
            pixelWidth = CGFloat(assetModel.asset.pixelWidth)
            pixelHeight = CGFloat(assetModel.asset.pixelHeight)
        }
        
        let imageSize = CGSize.init(width: pixelWidth, height: pixelHeight)
        
        PHImageManager.default().requestImage(for: assetModel.asset, targetSize: imageSize, contentMode: PHImageContentMode.aspectFill, options: options) { (result:UIImage?, _) in
            
            if let image = result {
                var frame:CGRect?
                
                if let cell = self.collectionView.cellForItem(at: IndexPath.init(row: currentIndex, section: 0)) {
                    
                    let window = UIApplication.shared.keyWindow
                    
                    let rect1 = cell.convert(cell.frame, from: self.collectionView)
                    frame = cell.convert(rect1, to: window)
                    
                    if frame!.minY < 64 ||  frame!.maxY > YLScreenH - 44 {
                        frame = nil
                    }
                }
                
                photo = YLPhoto.addImage(image, frame: frame)
                photo?.assetModel = assetModel
            }
            
        }
    
        return photo ?? YLPhoto()
    }
    
    func epPhotoBrowserByPhotoTagBtnHandle(_ assetModel: YLAssetModel?) {
        if let assetModel = assetModel {
            epPhotoTagBtnHandle(assetModel)
        }
    }
    
    func epPhotoBrowserBySendBtnHandle(_ currentIndex: Int) {
        
        let options = PHImageRequestOptions()
        options.resizeMode = PHImageRequestOptionsResizeMode.fast
        options.isSynchronous = true
        
        if selectPhotos.count == 0 && currentIndex >= 0 {
            // 发送当前图片 currentIndex
            selectPhotos.append(photos[currentIndex])
        }
        
        var images = [UIImage]()
        for assetModel in selectPhotos {
        
            PHImageManager.default().requestImage(for: assetModel.asset, targetSize: CGSize.init(width: assetModel.asset.pixelWidth, height: assetModel.asset.pixelHeight), contentMode: PHImageContentMode.aspectFill, options: options, resultHandler: { (result:UIImage?, _) in
                
                if let image = result {
                    images.append(image)
                }
            })
        }
        
        let imagePicker = navigationController as! YLImagePickerController
        imagePicker.didFinishPickingPhotosHandle?(images)
        
        imagePicker.goBack()
        
    }
}

// MARK: - TOCropViewControllerDelegate
extension YLPhotoPickerController: TOCropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        
        let imagePicker = self.navigationController as! YLImagePickerController
        imagePicker.didFinishPickingPhotosHandle?([image])
        imagePicker.goBack()
    }
}
