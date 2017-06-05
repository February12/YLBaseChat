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
    func epSendMessageImage(_ images:[UIImage]?)
}

class ChatView: YLReplyView {
    
    weak var delegate:ChatViewDelegate?
    
}


// MARK: - 重写父类方法
extension ChatView {
    
    override func efSendMessageText(_ text: String) {
        delegate?.epSendMessageText(text)
    }
    
    override func efSendMessageImage(_ images:[UIImage]?) {
        delegate?.epSendMessageImage(images)
    }
    
    override func efSendMessageVideo(_ path: String?) {
        
    }
    
}
