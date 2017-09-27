//
//  YLPhotoBrowser.swift
//  YLPhotoBrowser
//
//  Created by yl on 2017/7/25.
//  Copyright © 2017年 February12. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

let PhotoBrowserBG = UIColor.black
let ImageViewTag = 1000
let CoverViewTag = 10000

public typealias GetTransitionImageView = (_ currentIndex: Int,_ image: UIImage?,_ isBack: Bool) -> (UIView?)

public typealias GetViewOnTheBrowser = (_ currentIndex: Int) -> (UIView?)

/// YLPhotoBrowserDelegate
public protocol YLPhotoBrowserDelegate: NSObjectProtocol {
    func epPhotoBrowserGetPhotoCount() -> Int
    func epPhotoBrowserGetPhotoByCurrentIndex(_ currentIndex: Int) -> YLPhoto
}

public class YLPhotoBrowser: UIViewController {
    
    /// 非矩形图片需要实现(比如聊天界面带三角形的图片) 默认是矩形图片
    public var getTransitionImageView: GetTransitionImageView? {
        didSet {
            if let photo = getDataByCurrentIndex(currentIndex) {
                editTransitioningDelegate(photo,isBack: false)
            }
        }
    }
    /// 每张图片上的 View 视图
    public var getViewOnTheBrowser: GetViewOnTheBrowser?
    
    /// 用于遮挡原来图片的View的背景色
    public var originalCoverViewBG = UIColor.clear
    
    weak var delegate: YLPhotoBrowserDelegate?
    
    var dataArray = [Int:YLPhoto]() // 数据源
    
    fileprivate var currentIndex: Int = 0 // 当前row
    
    fileprivate var animatedTransition:YLAnimatedTransition? // 控制器动画
    
    var collectionView:UICollectionView!
    fileprivate var pageControl:UIPageControl?
    
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        animatedTransition = nil
        transitioningDelegate = nil
    }
    
    deinit {
        removeObserver(self, forKeyPath: "view.frame")
        dataArray.removeAll()
        delegate = nil
    }
    
    // 是否支持屏幕旋转
    override public var shouldAutorotate: Bool {
        return true
    }
    
    // 初始化
    public convenience init(_ index: Int,_ delegate: YLPhotoBrowserDelegate) {
        self.init()
        
        currentIndex = index
        self.delegate = delegate
        
        let photo = getDataByCurrentIndex(currentIndex)
        
        animatedTransition = YLAnimatedTransition()
        transitioningDelegate = animatedTransition
        
        editTransitioningDelegate(photo!,isBack: false)
    }
    
    // 键盘 View frame 改变
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "view.frame" {
            dataArray.removeAll()
            collectionView.reloadData()
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.scrollToItem(at: IndexPath.init(row: self?.currentIndex ?? 0, section: 0), at: UICollectionViewScrollPosition.left, animated: false)
            }
        }
    }
    
    override public func viewDidLoad() {
        
        view.backgroundColor = PhotoBrowserBG
        view.isUserInteractionEnabled = true
        
        animatedTransition?.originalCoverViewBG = originalCoverViewBG
        
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(YLPhotoBrowser.singleTap))
        view.addGestureRecognizer(singleTap)
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(YLPhotoBrowser.doubleTap))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        // 优先识别 双击
        singleTap.require(toFail: doubleTap)
        
        layoutUI()
        
        collectionView.scrollToItem(at: IndexPath.init(row: currentIndex, section: 0), at: UICollectionViewScrollPosition.left, animated: false)
        
        addObserver(self, forKeyPath: "view.frame", options: NSKeyValueObservingOptions.old, context: nil)
        
    }
    
    // 绘制 UI
    private func layoutUI() {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        collectionView.register(YLPhotoCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        // collectionView 约束
        collectionView.addConstraints(toItem: view, edgeInsets: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        let count = delegate?.epPhotoBrowserGetPhotoCount()
        if count! > 1 {
            
            pageControl = UIPageControl()
            pageControl?.pageIndicatorTintColor = UIColor.lightGray
            pageControl?.currentPageIndicatorTintColor = UIColor.white
            pageControl?.numberOfPages = count!
            pageControl?.currentPage = currentIndex
            pageControl?.backgroundColor = UIColor.clear
            
            view.addSubview(pageControl!)
            
            // pageControl 约束
            pageControl?.addConstraints(attributes: [.centerX,.bottom], toItem: view, attributes: nil, constants: [0,-30])
            
        }
        
        view.layoutIfNeeded()
    }
    
    // 单击手势
    @objc func singleTap() {
        
        if let photo = getDataByCurrentIndex(currentIndex) {
            editTransitioningDelegate(photo,isBack: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    // 双击手势
    @objc func doubleTap() {
        
        if let imageView = getCurrentImageView(),
            let scrollView = imageView.superview as? UIScrollView,
            let image = imageView.image {
            
            if scrollView.zoomScale == 1 {
                
                var scale:CGFloat = 0
                
                if view.frame.width < view.frame.height {
                    let height = YLPhotoBrowser.getImageViewFrame(image.size).height
                    if height >= view.frame.height {
                        scale = 2
                    }else {
                        scale = view.frame.height / height
                    }
                }else {
                    let width = YLPhotoBrowser.getImageViewFrame(image.size).width
                    if width >= view.frame.width {
                        scale = 2
                    }else {
                        scale = view.frame.width / width
                    }
                }
                
                scale = scale > 4 ? 4: scale
                scale = scale < 1 ? 2: scale
                
                scrollView.setZoomScale(scale, animated: true)
            }else {
                scrollView.setZoomScale(1, animated: true)
            }
            
        }
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
    func editTransitioningDelegate(_ photo: YLPhoto,isBack: Bool) {
        
        if photo.image == nil {
            
            let isCached = KingfisherManager.shared.cache.imageCachedType(forKey: photo.imageUrl, processorIdentifier: "").cached
            
            if isCached {
                KingfisherManager.shared.retrieveImage(with: URL.init(string: photo.imageUrl)!, options: [.preloadAllAnimationData,.transition(.fade(1))], progressBlock: nil, completionHandler: { (image:Image?, _, _, _) in
                    photo.image = image
                })
            }
        }
        
        let currentImageView = getCurrentImageView()
        
        var transitionBrowserImgFrame = CGRect.zero
        if currentImageView != nil {
            transitionBrowserImgFrame = (currentImageView?.frame)!
        }else if photo.image != nil {
            transitionBrowserImgFrame = YLPhotoBrowser.getImageViewFrame((photo.image?.size)!)
        }else {
            transitionBrowserImgFrame = YLPhotoBrowser.getImageViewFrame(CGSize.init(width: view.frame.width, height: view.frame.width))
        }
        
        let transitionImageView = getTransitionImageView?(currentIndex,photo.image,isBack)
        animatedTransition?.update(photo.image,transitionImageView: transitionImageView, transitionOriginalImgFrame: photo.frame, transitionBrowserImgFrame: transitionBrowserImgFrame)
        
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
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = delegate?.epPhotoBrowserGetPhotoCount() {
            return count
        }else {
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: YLPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! YLPhotoCell
        
        if let photo = getDataByCurrentIndex(indexPath.row) {
            
            cell.updatePhoto(photo)
            cell.delegate = self
            
            if let coverView = getViewOnTheBrowser?(indexPath.row) {
                coverView.tag = CoverViewTag
                
                if let subView = cell.viewWithTag(CoverViewTag) {
                    subView.removeFromSuperview()
                }
                
                coverView.frame = cell.bounds
                cell.addSubview(coverView)
            }
            
        }
        
        return cell
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: view.frame.width, height: view.frame.height)
    }
    
    // 已经停止减速
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == collectionView {
            currentIndex = Int(scrollView.contentOffset.x / view.frame.width)
            pageControl?.currentPage = currentIndex
        }
    }
}

extension YLPhotoBrowser: YLPhotoCellDelegate {
    
    func epPanGestureRecognizerBegin(_ pan: UIPanGestureRecognizer, photo: YLPhoto) {
        
        animatedTransition?.transitionOriginalImgFrame = photo.frame
        animatedTransition?.gestureRecognizer = pan
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func epPanGestureRecognizerEnd(_ currentImageViewFrame: CGRect, photo: YLPhoto) {
        
        animatedTransition?.gestureRecognizer = nil
        let transitionImageView = getTransitionImageView?(currentIndex,photo.image,true)
        animatedTransition?.update(photo.image,transitionImageView: transitionImageView, transitionOriginalImgFrame: photo.frame, transitionBrowserImgFrame: currentImageViewFrame)
    }
}
