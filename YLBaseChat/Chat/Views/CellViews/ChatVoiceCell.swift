//
//  ChatVoiceCell.swift
//  YLBaseChat
//
//  Created by yl on 17/6/5.
//  Copyright © 2017年 yl. All rights reserved.
//

import Foundation
import UIKit

class ChatVoiceCell: BaseChatCell {
    
    var messageAnimationVoiceImageView:UIImageView!
    var messageVoiceDurationLabel:UILabel!
        
    override func layoutUI() {
        super.layoutUI()
        
        messageAnimationVoiceImageView = UIImageView()
        messageAnimationVoiceImageView.isUserInteractionEnabled = true
        messageAnimationVoiceImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(ChatVoiceCell.tapHandle)))
        messagebubbleBackImageView?.addSubview(messageAnimationVoiceImageView)
        
        messageVoiceDurationLabel = UILabel()
        messageVoiceDurationLabel.font = UIFont.systemFont(ofSize: 12)
        messageVoiceDurationLabel.textColor = UIColor.colorFromRGB(0xb9b9bb)
        messageVoiceDurationLabel.yl_autoW()
        messagebubbleBackImageView?.addSubview(messageVoiceDurationLabel)
    }
    
    override func updateMessage(_ m: Message, idx: IndexPath) {
        super.updateMessage(m, idx: idx)
        
        let messageBody = message?.messageBody
    
        let duration = messageBody?.voiceDuration
        
        var width:CGFloat = 0
        if let duration = duration {
            if  duration <= 15 {
                width = YLScreenWidth * 0.088 + (YLScreenWidth * 0.18) / 15.0 * CGFloat(duration)
            }else{
                width = YLScreenWidth * (0.088 + 0.18) + (YLScreenWidth * 0.55 - YLScreenWidth * (0.088 + 0.18)) / 45.0 * CGFloat(duration - 15)
            }
            
            if (width > YLScreenWidth * 0.55) {
                width = YLScreenWidth * 0.55
            }
        }
        
        if message?.direction == MessageDirection.send.rawValue {
            
            messageAnimationVoiceImageView.snp.remakeConstraints({ (make) in
                make.edges.equalTo(UIEdgeInsets(top: 11, left: 10, bottom: 11, right: 25))
                make.width.equalTo(width)
                make.height.equalTo(13)
            })
            
            messageAnimationVoiceImageView.contentMode = UIViewContentMode.right
            messageVoiceAnimationImageViewWithIsSendMessage(true)
            
            messageVoiceDurationLabel.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(messageAnimationVoiceImageView)
                make.left.equalTo(10)
            })
            
            messageVoiceDurationLabel.text = "\(duration!) ”"
            
        }else {
            
            messageAnimationVoiceImageView.snp.remakeConstraints({ (make) in
                make.edges.equalTo(UIEdgeInsets(top: 11, left: 25, bottom: 11, right: 10))
                make.width.equalTo(width)
                make.height.equalTo(13)
            })
            
            messageAnimationVoiceImageView.contentMode = UIViewContentMode.left
            messageVoiceAnimationImageViewWithIsSendMessage(false)
            
            messageVoiceDurationLabel.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(messageAnimationVoiceImageView)
                make.right.equalTo(-10)
            })
            
            messageVoiceDurationLabel.text = "\(duration!) ”"
            
        }
        
        layoutIfNeeded()
    }
    
    fileprivate func messageVoiceAnimationImageViewWithIsSendMessage(_ isSendMessage:Bool) {
        
        var imageSepatorName = ""
        if isSendMessage {
            imageSepatorName = "ico_talk_voice_right"
        }else{
            imageSepatorName = "ico_talk_voice_left"
        }
        
        var images = [UIImage]()
        
        for i in 0...2 {
            if let image = UIImage(named: imageSepatorName + "_play_\(i)") {
                images.append(image)
            }
        }
        
        messageAnimationVoiceImageView.image = UIImage.init(named: imageSepatorName)
        messageAnimationVoiceImageView.animationImages = images
        messageAnimationVoiceImageView.animationDuration = 1.0
        messageAnimationVoiceImageView.stopAnimating()
        
    }
    
    @objc fileprivate func tapHandle() {
        if let message = message {
            delegate?.epDidVoiceClick(message)
        }
    }
}
