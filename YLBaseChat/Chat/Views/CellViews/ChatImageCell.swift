//
//  ChatImageCell.swift
//  YLBaseChat
//
//  Created by yl on 17/5/25.
//  Copyright © 2017年 yl. All rights reserved.
//

import Foundation
import UIKit

class ChatImageCell: BaseChatCell {
    
    var messagePhotoImageView:ChatPhotoImageView!
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: (messagePhotoImageView?.yl_bottom)! + 10)
    }
    
    override func layoutUI() {
        isNeedBubbleBackground = false
        super.layoutUI()
        
        messagePhotoImageView = ChatPhotoImageView(frame: CGRect.zero)
        contentView.addSubview(messagePhotoImageView)
    }
    
    override func updateMessage(_ m: Message, idx: IndexPath) {
        super.updateMessage(m, idx: idx)
        
        let messageBody = message?.messageBody
        
        let image:UIImage = UIImage(data: messageBody?.image as! Data)!
        
        
        var w = image.size.width
        var h = image.size.height
        
        if w > YLScreenWidth*0.2 {
            h = h / w * YLScreenWidth * 0.2
            w = YLScreenWidth * 0.2
        }else if w < YLScreenWidth * 0.1 {
            h = h * ((YLScreenWidth * 0.1) / w)
            w = YLScreenWidth * 0.1
        }
        
        if message?.direction == MessageDirection.send.rawValue {
            
            messagePhotoImageView.snp.remakeConstraints({ (make) in
                make.width.equalTo(w)
                make.height.equalTo(h)
                make.right.equalTo(messageAvatarsImageView.snp.left).offset(-16)
                make.top.equalTo(messageAvatarsImageView)
            })
            messagePhotoImageView.updateMessagePhoto(image, isSendMessage: true)
        }else {
            
            messagePhotoImageView.snp.remakeConstraints({ (make) in
                make.width.equalTo(w)
                make.height.equalTo(h)
                make.left.equalTo(messageAvatarsImageView.snp.right).offset(8)
                make.top.equalTo(messageUserNameLabel.snp.bottom).offset(4)
            })
            messagePhotoImageView.updateMessagePhoto(image, isSendMessage: false)
            
        }
        
        layoutIfNeeded()
        
    }
    
    
}


class ChatPhotoImageView: UIView {
    
    var messagePhotoImageView:UIImageView!
    var layerImageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        
        // 图片
        messagePhotoImageView = UIImageView()
        messagePhotoImageView.contentMode = UIViewContentMode.scaleAspectFill
        messagePhotoImageView.clipsToBounds = true
        addSubview(messagePhotoImageView)
        
        messagePhotoImageView.snp.makeConstraints {[weak self] (make) in
            make.edges.equalTo(self!)
        }
        
        // 图片层
        layerImageView = UIImageView()
        messagePhotoImageView.addSubview(layerImageView)
        
        layerImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(messagePhotoImageView)
        }
        
    }
    
    func updateMessagePhoto(_ image: UIImage,isSendMessage: Bool) {
        
        if isSendMessage {
            layerImageView.image = UIImage(named: "bg_talk_bubble_photo")?.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 20), resizingMode: UIImageResizingMode.stretch)
        }else {
            layerImageView.image = UIImage(named: "bg_talk_bubble_photo_left")?.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10), resizingMode: UIImageResizingMode.stretch)
        }
        
        messagePhotoImageView.image = image
    }
    
}
