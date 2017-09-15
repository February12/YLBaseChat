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

enum YLPhotoBrowserDataSource {
    case all
    case preview
}

class YLPhotoPickerController: UIViewController {
    // 指定相册
    var assetCollection: PHAssetCollection?
    
    var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        
        let window = UIApplication.shared.keyWindow
        
        let w = window?.frame.width ?? UIScreen.main.bounds.width
        let h = window?.frame.height ?? UIScreen.main.bounds.height
        
        let size = w > h ? h : w
        let wh = (size - 25.0) / 4.0
        layout.itemSize = CGSize.init(width: wh, height: wh)
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        
        return collectionView
    }()
    
    var toolbar : YLToolbarBottom = {
        
        let toolbar = YLToolbarBottom.loadNib()
        toolbar.sendBtnIsSelect(false)
        toolbar.previewBtn.isHidden = false
        toolbar.previewBtnIsSelect(false)
        
        return toolbar
    }()
    
    // 所有资源
    var photos = [YLAssetModel]()
    // 已经选择的资源
    var selectPhotos = [YLAssetModel]()
    // 预览的资源
    var previewPhotos = [YLAssetModel]()
    // 图片浏览器数据来源 默认所有图片
    var photoBrowserDataSource: YLPhotoBrowserDataSource = YLPhotoBrowserDataSource.all
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            toolbar.sendBtn.addTarget(self, action: #selector(YLPhotoPickerController.sendBtnHandle), for: UIControlEvents.touchUpInside)
            toolbar.originalImageClickBtn.addTarget(self, action: #selector(YLPhotoPickerController.originalImageClickBtnHandle), for: UIControlEvents.touchUpInside)
            
            toolbar.previewBtn.addTarget(self, action: #selector(YLPhotoPickerController.previewBtnHandle), for: UIControlEvents.touchUpInside)
            
            toolbar.originalImageBtnIsSelect(imagePicker.isSelectedOriginalImage)
            
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
            
            let imagePicker = self?.navigationController as! YLImagePickerController
            
            if let assetCollection = self?.assetCollection {
                
                let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
                
                assets.enumerateObjects({ (asset: PHAsset, _, _) in
                    
                    let assetModel = YLAssetModel()
                    assetModel.asset = asset
                    
                    // 判断gif
                    if asset.mediaType == PHAssetMediaType.image &&
                        imagePicker.isNeedSelectGifImage == true {
                        if let assetType = asset.value(forKey: "filename") as? String {
                            if assetType.hasSuffix("GIF") == true {
                                    assetModel.type = .gif
                            }
                        }
                    // 判断视频
                    }else if asset.mediaType == PHAssetMediaType.video &&
                        imagePicker.isNeedSelectVideo == true {
                        assetModel.type = .video
                    }
                    
                    self?.photos.append(assetModel)
                })
                
            }
            
            DispatchQueue.main.async {
                self?.navigationItem.title = self?.assetCollection?.localizedTitle
                self?.collectionView.reloadData()
                if (self?.photos.count)! > 12 {
                    self?.collectionView.scrollToItem(at: IndexPath.init(row: (self?.photos.count)! - 1, section: 0), at: UICollectionViewScrollPosition.bottom, animated: false)
                }
            }
        }
    }
    
    /// 发送按钮
    func sendBtnHandle() {
        epPhotoBrowserBySendBtnHandle(nil)
    }
    
    /// 选择原图
    func originalImageClickBtnHandle() {
        
        let imagePicker = self.navigationController as! YLImagePickerController
        let isSelectedOriginalImage = imagePicker.isSelectedOriginalImage
        toolbar.originalImageBtnIsSelect(!isSelectedOriginalImage)
        imagePicker.isSelectedOriginalImage = !isSelectedOriginalImage
        
    }
    
    /// 预览
    func previewBtnHandle() {
        photoBrowserDataSource = .preview
        previewPhotos.removeAll()
        previewPhotos += selectPhotos
        let photoBrowser = YLPhotoBrowser.init(0, self)
        self.navigationController?.pushViewController(photoBrowser, animated: true)
    }
    
    /// 获取用户导出图片大小
    func getUserNeedSize(_ size: CGSize) -> CGSize {
        var width:CGFloat = CGFloat(size.width)
        var height:CGFloat = CGFloat(size.height)
        // 是否选择了原图
        let imagePicker = navigationController as! YLImagePickerController
        if imagePicker.isSelectedOriginalImage == false &&
            width > imagePicker.photoWidth {
            
            width = imagePicker.photoWidth
            height = CGFloat(size.height) / CGFloat(size.width) * width
            
        }
        return CGSize.init(width: width, height: height)
    }
    
    /// 完成选择
    func didFinishPickingPhotos(_ assetModels: [YLAssetModel]) {
        
        var photos = [YLPhotoModel]()
        
        for assetModel in assetModels {
            
            if assetModel.type == .gif {
                
                let options = PHImageRequestOptions()
                options.resizeMode = PHImageRequestOptionsResizeMode.fast
                options.isSynchronous = true
                PHImageManager.default().requestImageData(for: assetModel.asset, options: options, resultHandler: { (data:Data?, dataUTI:String?, _, _) in
                    
                    if let data = data {
                        let photoModel = YLPhotoModel.init(gifData: data,asset: assetModel.asset)
                        photos.append(photoModel)
                    }
                    
                })
                
            }else if assetModel.type == .video {
                
                let photoModel = YLPhotoModel.init(asset: assetModel.asset)
                photos.append(photoModel)
                
            }else {
                
                let options = PHImageRequestOptions()
                options.resizeMode = PHImageRequestOptionsResizeMode.fast
                options.isSynchronous = true
                PHImageManager.default().requestImage(for: assetModel.asset, targetSize: getUserNeedSize(CGSize.init(width: assetModel.asset.pixelWidth, height: assetModel.asset.pixelHeight)), contentMode: PHImageContentMode.aspectFill, options: options, resultHandler: { (result:UIImage?, _) in
                    
                    if let image = result {
                        let photoModel = YLPhotoModel.init(image: image,asset: assetModel.asset)
                        photos.append(photoModel)
                    }
                })
            }
        }
        
        let imagePicker = navigationController as! YLImagePickerController
        imagePicker.didFinishPickingPhotosHandle?(photos)
        imagePicker.goBack()
        
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
            toolbar.previewBtnIsSelect(false)
        }else {
            toolbar.sendBtnIsSelect(true)
            toolbar.previewBtnIsSelect(true)
        }
    }
    
    func epImageViewHandle(_ assetModel: YLAssetModel) {
        
        
        let imagePicker = navigationController as! YLImagePickerController
        
        if imagePicker.isOneChoose == true {
            
            if imagePicker.cropType != CropType.none &&
                assetModel.type != .gif &&
                assetModel.type != .video {
                
                let options = PHImageRequestOptions()
                options.resizeMode = PHImageRequestOptionsResizeMode.fast
                options.isSynchronous = true
                
                PHImageManager.default().requestImage(for: assetModel.asset, targetSize: getUserNeedSize(CGSize.init(width: assetModel.asset.pixelWidth, height: assetModel.asset.pixelHeight)), contentMode: PHImageContentMode.aspectFill, options: options, resultHandler: { (result:UIImage?, _) in
                    
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
                            
                        }
                    }
                    
                })
                
            }else {
                didFinishPickingPhotos([assetModel])
            }
            
        }else {
            
            if let row = self.photos.index(where: { $0 === assetModel }) {
                photoBrowserDataSource = .all
                previewPhotos.removeAll()
                let photoBrowser = YLPhotoBrowser.init(row, self)
                self.navigationController?.pushViewController(photoBrowser, animated: true)
            }
        }
    }
}


// MARK: - YLPhotoBrowserDelegate
extension YLPhotoPickerController: YLPhotoBrowserDelegate {
    
    func epPhotoBrowserGetPhotoCount() -> Int {
        switch photoBrowserDataSource {
        case .all:
            return photos.count
        case .preview:
            return previewPhotos.count
        }
    }
    
    func epPhotoBrowserGetPhotoByCurrentIndex(_ currentIndex: Int) -> YLPhoto {
        
        var assetModel: YLAssetModel?
        
        switch photoBrowserDataSource {
        case .all:
            assetModel = photos[currentIndex]
        case .preview:
            assetModel = previewPhotos[currentIndex]
        }
        
        let options = PHImageRequestOptions()
        options.resizeMode = PHImageRequestOptionsResizeMode.fast
        options.isSynchronous = true
        
        var photo: YLPhoto?
        
        if let assetModel = assetModel {
            
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
                    
                    if let row = self.photos.index(where: { $0 === assetModel }),
                        let cell = self.collectionView.cellForItem(at: IndexPath.init(row: row, section: 0)) {
                        
                        frame = self.collectionView.convert(cell.frame, to: self.collectionView.superview)
                        
                        if frame!.minY < 64 ||  frame!.maxY > self.view.frame.height - 44 {
                            frame = CGRect.zero
                        }
                    }
                    
                    photo = YLPhoto.addImage(image, frame: frame)
                    photo?.assetModel = assetModel
                }
            }
        }
        
        return photo ?? YLPhoto()
    }
    
    func epPhotoBrowserByPhotoTagBtnHandle(_ assetModel: YLAssetModel?) {
        if let assetModel = assetModel {
            epPhotoTagBtnHandle(assetModel)
        }
    }
    
    func epPhotoBrowserBySendBtnHandle(_ assetModel: YLAssetModel?) {
        
        if selectPhotos.count == 0 {
            // 发送当前图片 assetModel
            if let assetModel = assetModel,
                let index = self.photos.index(where: { $0 === assetModel }) {
                selectPhotos.append(photos[index])
            }
        }
        
        didFinishPickingPhotos(selectPhotos)
    }
}

// MARK: - TOCropViewControllerDelegate
extension YLPhotoPickerController: TOCropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        
        let imagePicker = self.navigationController as! YLImagePickerController
        let photoModel = YLPhotoModel.init(image: image)
        imagePicker.didFinishPickingPhotosHandle?([photoModel])
        imagePicker.goBack()
    }
}
