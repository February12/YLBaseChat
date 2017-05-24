//
//  ChatView.swift
//  YLBaseChat
//
//  Created by yl on 17/5/18.
//  Copyright © 2017年 yl. All rights reserved.
//

import Foundation
import UIKit

protocol ChatViewDelegate: NSObjectProtocol {
    
    func epSendMessageText(_ text:String)
    
}

class ChatView: YLReplyView {
    
    weak var delegate:ChatViewDelegate?
    
}


// MARK: - 重写父类方法
extension ChatView {
    
    override func efSendMessageText() {
        
        var text = ""
        
        let attributedText = evInputView.inputTextView.attributedText!
        
        attributedText.enumerateAttributes(in: NSRange.init(location: 0, length: attributedText.length), options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) {(attrs, range, _) in
            
            if let attachment = attrs["NSAttachment"] as? NSTextAttachment  {
                
                let img = attachment.image!
                
                if (img.yl_tag?.hasPrefix("["))! && (img.yl_tag?.hasSuffix("]"))! {
                    text = text + img.yl_tag!
                }
                
            }else{
            
                let tmptext:String = attributedText.attributedSubstring(from: range).string
                text = text + tmptext
                
            }
            
        }
        
        evInputView.selectedRange = NSMakeRange(0, 0);
        evInputView.inputTextView.text = ""
        
        evInputView.textViewDidChanged()
        
        delegate?.epSendMessageText(text)
    }
    
}
