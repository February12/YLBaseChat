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
    func epPhotoBrowserBySendBtnHandle(_ currentIndex: Int)
}

let PhotoBrowserBG = UIColor.black
let ImageViewTag = 1000

var YLScreenW = UIScreen.main.bounds.width
var YLScreenH = UIScreen.main.bounds.height

class YLPhotoBrowser: UIViewController {
    
    weak var delegate: YLPhotoBrowserDelegate?
    
    var dataArray = [Int:YLPhoto]() // 数据源
    
    fileprivate var currentIndex: Int = 0 // 当前row
    
    fileprivate var appearAnimatedTransition:YLAnimatedTransition? // 进来的动画
    fileprivate var disappearAnimatedTransition:YLAnimatedTransition? // 出去的动画
    
    var collectionView:UICollectionView!
    
    // 下面的toolbar
    var toolbarBottom : YLToolbarBottom = {
        
        let toolbar = YLToolbarBottom.loadNib()
        toolbar.sendBtn.addTarget(self, action: #selector(YLPhotoBrowser.SendBtnHandle), for: UIControlEvents.touchUpInside)
        toolbar.originalImageClickBtn.addTarget(self, action: #selector(YLPhotoPickerController.originalImageClickBtnHandle), for: UIControlEvents.touchUpInside)
        return toolbar
    }()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        disappearAnimatedTransition = nil
    }
    
    deinit {
        dataArray.removeAll()
        delegate = nil
        print("释放\(self)")
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
        
        // 手势
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(YLPhotoBrowser.singleTap))
        view.addGestureRecognizer(singleTap)
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(YLPhotoBrowser.doubleTap))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        // 优先识别 双击
        singleTap.require(toFail: doubleTap)
        
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
        
        collectionView.register(YLPhotoCell.self, forCellWithReuseIdentifier: "cell")
        
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
    
    /// 单击手势
    func singleTap() {
        self.navigationController?.setNavigationBarHidden(!toolbarBottom.isHidden, animated: false)
        toolbarBottom.isHidden = !toolbarBottom.isHidden
    }
    
    /// 双击手势
    func doubleTap() {
        
        if let imageView = getCurrentImageView(),
            let scrollView = imageView.superview as? UIScrollView,
            let image = imageView.image {
            
            if scrollView.zoomScale == 1 {
                
                var scale:CGFloat = 0
                
                let height = YLPhotoBrowser.getImageViewFrame(image.size).height
                if height >= YLScreenH {
                    scale = 2
                }else {
                    scale = YLScreenH / height
                }
                
                scale = scale > 4 ? 4: scale
                scale = scale < 1 ? 2: scale
                
                scrollView.setZoomScale(scale, animated: true)
            }else {
                scrollView.setZoomScale(1, animated: true)
            }
            
        }
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
    func SendBtnHandle() {
        delegate?.epPhotoBrowserBySendBtnHandle(currentIndex)
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
        
        if size.width > YLScreenW {
            let height = YLScreenW * (size.height / size.width)
            if height <= YLScreenH {
                
                let frame = CGRect.init(x: 0, y: YLScreenH/2 - height/2, width: YLScreenW, height: height)
                return frame
            }else {
                
                let frame = CGRect.init(x: 0, y: 0, width: YLScreenW, height: height)
                return frame
                
            }
        }else {
            
            if size.height <= YLScreenH {
                let frame = CGRect.init(x: YLScreenW/2 - size.width/2, y: YLScreenH/2 - size.height/2, width: size.width, height: size.height)
                return frame
            }else {
                let frame = CGRect.init(x: YLScreenW/2 - size.width/2, y: 0, width: size.width, height: size.height)
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
            transitionBrowserImgFrame = YLPhotoBrowser.getImageViewFrame(CGSize.init(width: YLScreenW, height: YLScreenW))
        }
        
        appearAnimatedTransition = nil
        (delegate as! YLPhotoPickerController).navigationController?.delegate = nil
        appearAnimatedTransition = YLAnimatedTransition.init(photo.image,transitionImageView: nil, transitionOriginalImgFrame: photo.frame, transitionBrowserImgFrame: transitionBrowserImgFrame)
        
        (delegate as! YLPhotoPickerController).navigationController?.delegate =
        appearAnimatedTransition
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
        
        let cell: YLPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! YLPhotoCell
        
        if let photo = getDataByCurrentIndex(indexPath.row) {
            
            cell.updatePhoto(photo)
            cell.delegate = self
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: YLScreenW, height: YLScreenH)
    }
    
    // 已经停止减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == collectionView {
            currentIndex = Int(scrollView.contentOffset.x / YLScreenW)
            
            let photo = getDataByCurrentIndex(currentIndex)
            showPhotoTagBtn(photo?.assetModel)
        }
    }
}


// MARK: - YLPhotoCellDelegate
extension YLPhotoBrowser: YLPhotoCellDelegate {
    
    func epPanGestureRecognizerBegin(_ pan: UIPanGestureRecognizer, photo: YLPhoto) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        toolbarBottom.isHidden = true
        
        disappearAnimatedTransition = nil
        self.navigationController?.delegate = nil
        disappearAnimatedTransition = YLAnimatedTransition()
        disappearAnimatedTransition?.transitionOriginalImgFrame = photo.frame ?? CGRect.zero
        disappearAnimatedTransition?.gestureRecognizer = pan
        self.navigationController?.delegate = disappearAnimatedTransition
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func epPanGestureRecognizerEnd(_ currentImageViewFrame: CGRect, photo: YLPhoto) {
        
        disappearAnimatedTransition?.transitionImage = photo.image
        disappearAnimatedTransition?.transitionImageView = nil
        disappearAnimatedTransition?.transitionBrowserImgFrame = currentImageViewFrame
        disappearAnimatedTransition?.transitionOriginalImgFrame = photo.frame ?? CGRect.zero
        
    }
}
