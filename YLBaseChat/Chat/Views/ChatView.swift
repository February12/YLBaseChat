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
    
    override func efSendMessageText(_ text: String) {
        
        delegate?.epSendMessageText(text)
        
    }
    
}
