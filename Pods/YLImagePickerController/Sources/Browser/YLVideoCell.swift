//
//  YLVideoCell.swift
//  YLImagePickerController
//
//  Created by yl on 2017/9/15.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit
import Photos

protocol YLVideoCellDelegate :NSObjectProtocol {
    func epVideoSingleTap(isHidden: Bool)
}

class YLVideoCell: UICollectionViewCell {
    
    var photo: YLPhoto!
    
    weak var delegate: YLVideoCellDelegate?

    var row: Int = -100
    
    var player: AVPlayer = AVPlayer()
    var playerLayer: AVPlayerLayer = {
        let playerLayer = AVPlayerLayer()
        return playerLayer
    }()
    var playerView: UIView = {
        let playerView = UIView()
        playerView.backgroundColor = UIColor.clear
        return playerView
    }()
    
    let playImageView: UIImageView = {
        
        let playImageView = UIImageView()
       playImageView.image = UIImage.yl_imageName("photo_play")
        return playImageView
    }()
    
    deinit {
        delegate = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutUI() {
        
        backgroundColor = UIColor.clear
        
        // 视频播放器
        self.addSubview(playerView)
        playerView.addConstraints(toItem: self, edgeInsets: .init(top: 0, left: 0, bottom: 0, right: 0))
        playerLayer.player = player
        playerLayer.frame = self.bounds
        playerView.layer.addSublayer(playerLayer)
        
        playerView.addSubview(playImageView)
        playImageView.addConstraints(attributes: [.centerX,.centerY,.width,.height], toItem: self, attributes: nil, constants: [0,0,50,50])
        
        // 手势
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(YLPhotoCell.singleTap))
        self.addGestureRecognizer(singleTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(YLVideoCell.scrollViewDelegate(_:)), name: NSNotification.Name("videoCellReceivescrollViewDelegate"), object: nil)
    }
    
    /// 滚动视图监听
    @objc func scrollViewDelegate(_ not: Notification) {
    
        if let obj = not.object as? Dictionary<String, String> {
            
            let state = obj["state"]
            let currentIndex = Int(obj["currentIndex"]!)
            
            if state == "endDecelerating" {
            
                if (currentIndex == row - 1 ||
                    currentIndex == row + 1) &&
                    player.currentItem != nil &&
                    player.currentTime() != kCMTimeZero {
                    
                    player.seek(to: kCMTimeZero)
                }
                
            }else if state == "beginDragging" {
                if currentIndex == row &&
                    playImageView.isHidden == true {
                    player.pause()
                    playImageView.isHidden = false
                    delegate?.epVideoSingleTap(isHidden: false)
                }
            }
        }
    }
    
    /// 单击手势
    @objc func singleTap() {
        
        if playImageView.isHidden == false {
            player.play()
            playImageView.isHidden = true
            delegate?.epVideoSingleTap(isHidden: true)
        }else {
            player.pause()
            playImageView.isHidden = false
            delegate?.epVideoSingleTap(isHidden: false)
        }
    }
    
    func updatePhoto(_ photo: YLPhoto, row: Int) {
        
        self.photo = photo
        self.row = row
        
        player.replaceCurrentItem(with: nil)
        player.pause()
        playImageView.isHidden = true
        
        if let asset = photo.assetModel?.asset {
            
            let options = PHVideoRequestOptions()
            options.deliveryMode = .fastFormat
            options.isNetworkAccessAllowed = true
            
            PHImageManager.default().requestPlayerItem(forVideo: asset, options: options, resultHandler: { [weak self] (item:AVPlayerItem?, _) in
                
                DispatchQueue.main.async {
                    
                    self?.player.replaceCurrentItem(with: item)
                    self?.player.pause()
                    self?.playImageView.isHidden = false
                    
                }
            })
        }
    }
}
