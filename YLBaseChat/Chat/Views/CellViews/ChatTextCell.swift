//
//  ChatTextCell.swift
//  YLBaseChat
//
//  Created by yl on 17/5/25.
//  Copyright © 2017年 yl. All rights reserved.
//

import Foundation
import UIKit
import YYText

class ChatTextCell: BaseChatCell {
    
    var messageTextLabel:YYLabel!
    
    override func layoutUI() {
        super.layoutUI()
        
        messageTextLabel = YYLabel()
        messageTextLabel.numberOfLines = 0
        messagebubbleBackImageView?.addSubview(messageTextLabel)
        
        messageTextLabel.yl_autoW()
    }
    
    override func updateMessage(_ m: Message, idx: IndexPath) {
        super.updateMessage(m, idx: idx)
        
        let messageBody = message?.messageBody
        
        let text = messageBody?.text.yl_conversionAttributedString()
        
        let layout = YYTextLayout(containerSize: CGSize.init(width: YLScreenWidth*0.648, height: CGFloat.greatestFiniteMagnitude), text: text!)
        
        messageTextLabel.textLayout = layout
        
        messageTextLabel.highlightTapAction = tapHighlightAction

        if message?.direction == MessageDirection.send.rawValue {
            
            messageTextLabel.snp.remakeConstraints({ (make) in
                make.edges.equalTo(UIEdgeInsets(top: 11, left: 10, bottom: 11, right: 15))
                make.width.lessThanOrEqualTo(YLScreenWidth*0.648)
                make.height.equalTo((layout?.textBoundingSize.height)!)
            })
            
        }else {
            
            messageTextLabel.snp.remakeConstraints({ (make) in
                make.edges.equalTo(UIEdgeInsets(top: 11, left: 15, bottom: 11, right: 10))
                make.width.lessThanOrEqualTo(YLScreenWidth*0.648)
                make.height.equalTo((layout?.textBoundingSize.height)!)
            })
            
        }

//        layoutIfNeeded()
        yl_refreshFrame()
        messageHeight = (messagebubbleBackImageView?.yl_bottom)! + 20
    }
    
    fileprivate func tapHighlightAction(_ containerView:UIView, text:NSAttributedString, range:NSRange, rect:CGRect) {
        UIApplication.shared.openURL(URL(string: text.attributedSubstring(from: range).string)!)
    }
    
}
