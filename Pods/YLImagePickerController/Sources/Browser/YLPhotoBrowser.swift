//
//  YLPhotoBrowser.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/25.
//  Copyright © 2017年 February12. All rights reserved.
//

import Foundation
import UIKit


/// YLPhotoBrowserDelegate
protocol YLPhotoBrowserDelegate: NSObjectProtocol {
    func epPhotoBrowserGetPhotoCount() -> Int
    func epPhotoBrowserGetPhotoByCurrentIndex(_ currentIndex: Int) -> YLPhoto
    func epPhotoBrowserByPhotoTagBtnHandle(_ assetModel:YLAssetModel?)
    func epPhotoBrowserBySendBtnHandle(_ assetModel:YLAssetModel?)
}

let PhotoBrowserBG = UIColor.black
let ImageViewTag = 1000

class YLPhotoBrowser: UIViewController {
    
    weak var delegate: YLPhotoBrowserDelegate?
    
    var dataArray = [Int:YLPhoto]() // 数据源
    
    fileprivate var currentIndex: Int = 0 // 当前row
    
    fileprivate var animatedTransition:YLAnimatedTransition? // 控制器动画
    
    var collectionView:UICollectionView!
    
    // 下面的toolbar
    var toolbarBottom : YLToolbarBottom = {
        
        let toolbar = YLToolbarBottom.loadNib()
        return toolbar
    }()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        animatedTransition = nil
        (delegate as! YLPhotoPickerController).navigationController?.delegate = nil
    }
    
    deinit {
        animatedTransition = nil
        dataArray.removeAll()
        delegate = nil
    }
    
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - index: 当前页
    ///   - delegate: 代理
    convenience init(_ index: Int,_ delegate: YLPhotoBrowserDelegate) {
        self.init()
        
        currentIndex = index
        self.delegate = delegate
        
        let photo = getDataByCurrentIndex(currentIndex)
        
        animatedTransition = YLAnimatedTransition()
        (delegate as! YLPhotoPickerController).navigationController?.delegate = animatedTransition
        
        editTransitioningDelegate(photo!)
        
    }
    
    override func viewDidLoad() {
        
        self.automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = PhotoBrowserBG
        view.isUserInteractionEnabled = true
        
        // 导航栏
        let backBtn = UIButton.init(type: UIButtonType.system)
        backBtn.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
        
        backBtn.setImage(UIImage.yl_imageName("photo_navi_back"), for: UIControlState.normal)
        backBtn.addTarget(self, action: #selector(YLPhotoBrowser.backBtnHandle), for: UIControlEvents.touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        
        let photo = getDataByCurrentIndex(currentIndex)
        showPhotoTagBtn(photo?.assetModel)
        
        layoutUI()
        
        collectionView.scrollToItem(at: IndexPath.init(row: currentIndex, section: 0), at: UICollectionViewScrollPosition.left, animated: false)
        
    }
    
    /// 绘制 UI
    private func layoutUI() {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(YLPhotoCell.self, forCellWithReuseIdentifier: "YLPhotoCell")
        collectionView.register(YLVideoCell.self, forCellWithReuseIdentifier: "YLVideoCell")
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        // collectionView 约束
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.addLayoutConstraint(toItem: view, edgeInsets: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        
        
        let imagePicker = navigationController as! YLImagePickerController
        toolbarBottom.originalImageBtnIsSelect(imagePicker.isSelectedOriginalImage)
        
        toolbarBottom.sendBtn.addTarget(self, action: #selector(YLPhotoBrowser.sendBtnHandle), for: UIControlEvents.touchUpInside)
        toolbarBottom.originalImageClickBtn.addTarget(self, action: #selector(YLPhotoPickerController.originalImageClickBtnHandle), for: UIControlEvents.touchUpInside)
        
        // 下面的toobbar
        view.addSubview(toolbarBottom)
        // 约束
        toolbarBottom.translatesAutoresizingMaskIntoConstraints = false
        toolbarBottom.addLayoutConstraint(attribute: NSLayoutAttribute.left, toItem: view, constant: 0)
        toolbarBottom.addLayoutConstraint(attribute: NSLayoutAttribute.right, toItem: view, constant: 0)
        toolbarBottom.addLayoutConstraint(attribute: NSLayoutAttribute.bottom, toItem: view, constant: 0)
        toolbarBottom.addLayoutConstraint(attribute: NSLayoutAttribute.height, constant: 44)
        
        view.layoutIfNeeded()
    }
    
    /// 返回
    func backBtnHandle() {
        let photo = getDataByCurrentIndex(currentIndex)
        editTransitioningDelegate(photo!)
        self.navigationController?.popViewController(animated: true)
    }
    
    /// 点击 是否选择按钮
    func photoTagBtnHandle() {
        let photo = getDataByCurrentIndex(currentIndex)
        delegate?.epPhotoBrowserByPhotoTagBtnHandle(photo?.assetModel)
        
        showPhotoTagBtn(photo?.assetModel)
    }
    
    /// 处理选择按钮显内容
    func showPhotoTagBtn(_ assetModel: YLAssetModel?) {
        
        let photoTagBtn = UIButton.init(type: UIButtonType.custom)
        photoTagBtn.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
        photoTagBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        photoTagBtn.addTarget(self, action: #selector(YLPhotoBrowser.photoTagBtnHandle), for: UIControlEvents.touchUpInside)
        
        if assetModel?.isSelected == true {
            
            let image = UIImage.yl_imageName("photo_selected")
            photoTagBtn.setBackgroundImage(image, for: UIControlState.normal)
            photoTagBtn.setTitle(String(assetModel?.selectedSerialNumber ?? 0), for: UIControlState.normal)
        }else {
            
            let image = UIImage.yl_imageName("photo_no_selected")
            photoTagBtn.setBackgroundImage(image, for: UIControlState.normal)
            photoTagBtn.setTitle("", for: UIControlState.normal)
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: photoTagBtn)
    }
    
    /// 发送按钮
    func sendBtnHandle() {
        let photo = getDataByCurrentIndex(currentIndex)
        delegate?.epPhotoBrowserBySendBtnHandle(photo?.assetModel)
    }
    
    /// 选择原图
    func originalImageClickBtnHandle() {
        
        let imagePicker = self.navigationController as! YLImagePickerController
        let isSelectedOriginalImage = imagePicker.isSelectedOriginalImage
        toolbarBottom.originalImageBtnIsSelect(!isSelectedOriginalImage)
        (delegate as! YLPhotoPickerController).toolbar.originalImageBtnIsSelect(!isSelectedOriginalImage)
        imagePicker.isSelectedOriginalImage = !isSelectedOriginalImage
    }
    
    // 获取imageView frame
    class func getImageViewFrame(_ size: CGSize) -> CGRect {
        
        let window = UIApplication.shared.keyWindow
        
        let w = window?.frame.width ?? UIScreen.main.bounds.width
        let h = window?.frame.height ?? UIScreen.main.bounds.height
        
        if size.width > w {
            let height = w * (size.height / size.width)
            if height <= h {
                
                let frame = CGRect.init(x: 0, y: h/2 - height/2, width: w, height: height)
                return frame
            }else {
                
                let frame = CGRect.init(x: 0, y: 0, width: w, height: height)
                return frame
                
            }
        }else {
            
            if size.height <= h {
                let frame = CGRect.init(x: w/2 - size.width/2, y: h/2 - size.height/2, width: size.width, height: size.height)
                return frame
            }else {
                let frame = CGRect.init(x: w/2 - size.width/2, y: 0, width: size.width, height: size.height)
                return frame
            }
            
        }
    }
    
    // 获取 currentImageView
    func getCurrentImageView() -> UIImageView? {
        
        if collectionView == nil {
            return nil
        }
        
        let cell = collectionView.cellForItem(at: IndexPath.init(row: currentIndex, section: 0))
        
        if let imgView = cell?.viewWithTag(ImageViewTag) {
            return imgView as? UIImageView
        }else {
            return nil
        }
    }
    
    // 修改 transitioningDelegate
    func editTransitioningDelegate(_ photo: YLPhoto) {
        
        let currentImageView = getCurrentImageView()
        
        var transitionBrowserImgFrame = CGRect.zero
        if currentImageView != nil {
            transitionBrowserImgFrame = (currentImageView?.frame)!
        }else if photo.image != nil {
            transitionBrowserImgFrame = YLPhotoBrowser.getImageViewFrame((photo.image?.size)!)
        }else {
            transitionBrowserImgFrame = YLPhotoBrowser.getImageViewFrame(CGSize.init(width: view.frame.width, height: view.frame.width))
        }
        
        animatedTransition?.update(photo.image,transitionImageView: nil, transitionOriginalImgFrame: photo.frame, transitionBrowserImgFrame: transitionBrowserImgFrame)
        
    }
    
    // 获取数据源,并缓存数据
    func getDataByCurrentIndex(_ index :Int) -> YLPhoto? {
        if dataArray.keys.contains(index) {
            return dataArray[index]
        }else {
            if let photo = delegate?.epPhotoBrowserGetPhotoByCurrentIndex(index) {
                dataArray[index] = photo
                
                if dataArray.count > 5 {
                    let keys = [Int](dataArray.keys).sorted()
                    if abs(keys.first! - index) > abs(keys.last! - index) {
                        dataArray.removeValue(forKey: keys.first!)
                    }
                }
                return photo
            }else {
                return nil
            }
        }
    }
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension YLPhotoBrowser:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = delegate?.epPhotoBrowserGetPhotoCount() {
            return count
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let photo = getDataByCurrentIndex(indexPath.row) {
            
            if photo.assetModel?.type == .video {
            
                let cell: YLVideoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "YLVideoCell", for: indexPath) as! YLVideoCell
                cell.updatePhoto(photo,row: indexPath.row)
                cell.delegate = self
                
                return cell
            }else if photo.assetModel?.type == .photo ||
                photo.assetModel?.type == .gif {
                
                let cell: YLPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "YLPhotoCell", for: indexPath) as! YLPhotoCell
                cell.updatePhoto(photo)
                cell.delegate = self
                
                return cell
            }
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: view.frame.width, height: view.frame.height)
    }
    
    // 已经停止减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == collectionView {
            currentIndex = Int(scrollView.contentOffset.x / view.frame.width)
            
            let photo = getDataByCurrentIndex(currentIndex)
            showPhotoTagBtn(photo?.assetModel)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("videoCellReceivescrollViewDelegate"), object: ["state":"endDecelerating","currentIndex":String(currentIndex)])
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        NotificationCenter.default.post(name: NSNotification.Name("videoCellReceivescrollViewDelegate"), object: ["state":"beginDragging","currentIndex":String(currentIndex)])
        
    }
}

extension YLPhotoBrowser: YLVideoCellDelegate {

    func epVideoSingleTap(isHidden: Bool) {
        self.navigationController?.setNavigationBarHidden(isHidden, animated: false)
        toolbarBottom.isHidden = isHidden
    }

}

// MARK: - YLPhotoCellDelegate
extension YLPhotoBrowser: YLPhotoCellDelegate {
    
    func epPhotoPanGestureRecognizerBegin(_ pan: UIPanGestureRecognizer, photo: YLPhoto) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        toolbarBottom.isHidden = true
        
        animatedTransition?.transitionOriginalImgFrame = photo.frame
        animatedTransition?.gestureRecognizer = pan
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func epPhotoPanGestureRecognizerEnd(_ currentImageViewFrame: CGRect, photo: YLPhoto) {
        
        animatedTransition?.gestureRecognizer = nil
        animatedTransition?.update(photo.image,transitionImageView: nil, transitionOriginalImgFrame: photo.frame, transitionBrowserImgFrame: currentImageViewFrame)
    }
    
    func epPhotoSingleTap() {
        self.navigationController?.setNavigationBarHidden(!toolbarBottom.isHidden, animated: false)
        toolbarBottom.isHidden = !toolbarBottom.isHidden
    }
    
    func epPhotoDoubleTap() {
        if let imageView = getCurrentImageView(),
            let scrollView = imageView.superview as? UIScrollView,
            let image = imageView.image {
            
            if scrollView.zoomScale == 1 {
                
                var scale:CGFloat = 0
                
                let height = YLPhotoBrowser.getImageViewFrame(image.size).height
                if height >= view.frame.height {
                    scale = 2
                }else {
                    scale = view.frame.height / height
                }
                
                scale = scale > 4 ? 4: scale
                scale = scale < 1 ? 2: scale
                
                scrollView.setZoomScale(scale, animated: true)
            }else {
                scrollView.setZoomScale(1, animated: true)
            }
            
        }
    }
}
