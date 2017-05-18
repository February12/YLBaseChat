//
//  YLReplyView.swift
//  YLBaseChat
//
//  Created by yl on 17/5/18.
//  Copyright © 2017年 yl. All rights reserved.
//

import Foundation
import UIKit

class YLReplyView: YLBaseReplyView {
    
    override func efLayoutUI() {
        super.efLayoutUI()
        
        let touchGestureRecognizer = YLTouchesGestureRecognizer.init(target: self, action: #selector(YLReplyView.recoverGesticulation(_:)))
        
        evInputView.recordOperationBtn.addGestureRecognizer(touchGestureRecognizer)
    }
    
    @objc fileprivate func recoverGesticulation(_ gesticulation:UIGestureRecognizer) {
        
        if gesticulation.state == UIGestureRecognizerState.began {
            
            print("开始录音")
            evInputView.recordOperationBtn.isSelected = true
            
            efStartRecording()
            
        }else if gesticulation.state == UIGestureRecognizerState.ended {
            
            
            let point = gesticulation.location(in: gesticulation.view)
            
            evInputView.recordOperationBtn.isSelected = false
            
            if point.y > 0 {
                
                print("发送录音")
                efSendRecording()
                
            }else{
                
                print("取消录音")
                efCancelRecording()
            }
            
        }else if gesticulation.state == UIGestureRecognizerState.changed {
            
            let point = gesticulation.location(in: gesticulation.view)
            
            if point.y > 0 {
                
                print("向上滑动取消录音")
                efSlideUpToCancelTheRecording()
                
            }else{
                
                print("松开取消录音")
                efLoosenCancelRecording()
                
            }
        }
    }
    
}


// MARK: - 子类需要重写
extension YLReplyView {
    
    // 录音处理
    func efStartRecording() {}
    func efCancelRecording() {}
    func efSendRecording() {}
    func efSlideUpToCancelTheRecording() {}
    func efLoosenCancelRecording() {}
    
    // 发送消息
    func efSendMessageText() {}
    

}


// MARK: - YLInputViewDelegate
extension YLReplyView {
    
    override func epSendMessageText() {
        
        efSendMessageText()
        
    }
    
}
