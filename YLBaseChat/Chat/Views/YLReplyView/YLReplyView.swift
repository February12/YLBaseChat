//
//  YLReplyView.swift
//  YLBaseChat
//
//  Created by yl on 17/5/15.
//  Copyright © 2017年 yl. All rights reserved.
//

import Foundation
import UIKit

// 表情框
fileprivate let defaultPanelViewH:CGFloat = 210.0

enum YLReplyViewState:Int {
    // 普通状态
    case normal = 1
    // 输入状态
    case input
    // 表情状态
    case face
    // 更多状态
    case more
    // 录音状态
    case record
}

class YLReplyView: UIView,YLInputViewDelegate {
    
    var evInputView:YLInputView! // 输入框
    
    var evReplyViewState:YLReplyViewState = YLReplyViewState.normal
    
    var evFacePanelView:UIView!  // 表情面板
    var evMorePanelView:UIView!  // 更多面板
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func layoutUI() {
        
        // 默认大小
        frame = CGRect(x: 0, y: 0, width: YLScreenWidth, height: YLScreenHeight)
        backgroundColor = UIColor.clear
        
        evInputView = YLInputView(frame: CGRect.zero)
        evInputView.delegate = self
        
        addSubview(evInputView)
        
        editInputViewConstraintWithBottom(0)
        
        evFacePanelView = efAddFacePanelView()
        editPanelViewConstraintWithPanelView(evFacePanelView)
        
        evMorePanelView = efAddMorePanelView()
        editPanelViewConstraintWithPanelView(evMorePanelView)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(YLReplyView.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(YLReplyView.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // recordOperationBtn 添加手势
        let touchGestureRecognizer = YLTouchesGestureRecognizer(target: self, action: #selector(YLReplyView.recoverGesticulation(_:)))
        
        evInputView.recordOperationBtn.addGestureRecognizer(touchGestureRecognizer)
    }
    
    // 编辑InputView 约束
    fileprivate func editInputViewConstraintWithBottom(_ bottom:CGFloat) {
        
        evInputView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(bottom)
            make.height.equalTo(defaultInputViewH).priority(750)
        }
        layoutIfNeeded()
    }
    
    // 编辑Panel 约束
    fileprivate func editPanelViewConstraintWithPanelView(_ panelView:UIView) {
        
        panelView.isHidden = true
        addSubview(panelView)
        
        panelView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(evInputView.snp.bottom)
            make.height.equalTo(defaultPanelViewH)
        }
        
    }
    
    // 发送消息
    fileprivate func sendMessageText() {
    
        var text = ""
        
        let attributedText = evInputView.inputTextView.attributedText!
        
        attributedText.enumerateAttributes(in: NSRange(location: 0, length: attributedText.length), options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) {(attrs:[String:Any], range:NSRange, _) in
            
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
        
        efSendMessageText(text)
    }
    
    // recordOperationBtn 手势处理
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


// MARK: - 子类可以重写/外部调用
extension YLReplyView{
    
    // 添加表情面板
    func efAddFacePanelView() -> UIView {
        
        let faceView:YLFaceView = Bundle.main.loadNibNamed("YLFaceView", owner: self, options: nil)?.first as! YLFaceView
        
        faceView.delegate = self
        
        return faceView
    }
    
    // 添加更多面板
    func efAddMorePanelView() -> UIView {
        let panelView = UIView()
        panelView.backgroundColor = UIColor.white
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "btn_import_photo")
        panelView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(40)
            make.width.height.equalTo(75)
        }
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(YLReplyView.efHandlePhotos)))
        
        return panelView
    }
    
    // 选择相片
    func efHandlePhotos() {
        efSendMessageImage(UIImage(named: "sendPhotos")!)
    }
    
    // 恢复普通状态
    func efDidRecoverReplyViewStateForNormal() {}
    
    // 恢复编辑状态
    func efDidRecoverReplyViewStateForEdit() {}
    
    // 收起输入框
    func efPackUpInputView() {
        updateReplyViewState(YLReplyViewState.normal)
    }
    
    // 录音处理
    func efStartRecording() {}
    func efCancelRecording() {}
    func efSendRecording() {}
    func efSlideUpToCancelTheRecording() {}
    func efLoosenCancelRecording() {}
    
    // 发送消息
    func efSendMessageText(_ text:String) {}
    func efSendMessageImage(_ image:UIImage) {}
}


// MARK: - 状态切换
extension YLReplyView{
    
    fileprivate func updateReplyViewState(_ state:YLReplyViewState) {
        
        if(evReplyViewState == state) {return}
        
        resetInputView()
        
        evReplyViewState = state
        
        switch state {
        case .normal:
            
            evInputView.inputTextView.resignFirstResponder()
            evInputView.textViewDidChanged()
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.editInputViewConstraintWithBottom(0)
                }, completion: { [weak self] (_) in
                    self?.evFacePanelView.isHidden = true
                    self?.evMorePanelView.isHidden = true
            })
            
            perform(#selector(YLReplyView.efDidRecoverReplyViewStateForNormal), with: nil, afterDelay: 0.0)
            
            break
            
        case .record:
            
            evInputView.inputTextView.resignFirstResponder()
            
            evInputView.inputTextView.snp.remakeConstraints({ (make) in
                make.edges.equalTo(evInputView.recordOperationBtn)
            })
            
            showKeyboardBtn(evInputView.recordBtn)
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.editInputViewConstraintWithBottom(0)
                }, completion: { [weak self] (_) in
                    self?.evFacePanelView.isHidden = true
                    self?.evMorePanelView.isHidden = true
                    self?.evInputView.recordOperationBtn.isHidden = false
                    self?.evInputView.inputTextView.isHidden = true
            })
            
            perform(#selector(YLReplyView.efDidRecoverReplyViewStateForEdit), with: nil, afterDelay: 0.0)
            
            break
            
        case .face:
            
            evFacePanelView.isHidden = false
            evMorePanelView.isHidden = true
            
            evInputView.inputTextView.resignFirstResponder()
            
            showKeyboardBtn(evInputView.faceBtn)
            
            evInputView.textViewDidChanged()
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.editInputViewConstraintWithBottom(-defaultPanelViewH)
            })
            
            perform(#selector(YLReplyView.efDidRecoverReplyViewStateForEdit), with: nil, afterDelay: 0.0)
            
            break
            
        case .more:
            
            evFacePanelView.isHidden = true
            evMorePanelView.isHidden = false
            
            evInputView.inputTextView.resignFirstResponder()
            
            showKeyboardBtn(evInputView.moreBtn)
            
            evInputView.textViewDidChanged()
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.editInputViewConstraintWithBottom(-defaultPanelViewH)
            })
            
            perform(#selector(YLReplyView.efDidRecoverReplyViewStateForEdit), with: nil, afterDelay: 0.0)
            
            break
            
        case .input:
            
            evInputView.inputTextView.becomeFirstResponder()
            evInputView.textViewDidChanged()
            
            break
            
        }
        
    }
    
    // 恢复输入框的初始状态
    fileprivate func resetInputView() {
        
        evInputView.faceBtn.isHidden = false
        evInputView.moreBtn.isHidden = false
        evInputView.recordBtn.isHidden = false
        evInputView.inputTextView.isHidden = false
        evInputView.keyboardBtn.isHidden = true
        evInputView.recordOperationBtn.isHidden = true
    }
    
    // 显示键盘按钮.隐藏点击的按钮
    fileprivate func showKeyboardBtn(_ btn:UIButton) {
        
        btn.isHidden = true
        evInputView.keyboardBtn.isHidden = false
        
        evInputView.keyboardBtn.snp.remakeConstraints { (make) in
            make.center.equalTo(btn)
            make.height.width.equalTo(defaultInputViewBtnWH)
        }
        layoutIfNeeded()
    }
    
}


// MARK: - YLFaceViewDelegate
extension YLReplyView:YLFaceViewDelegate {
    
    func epSendMessage() {
        sendMessageText()
    }
    
    func epInsertFace(_ image: UIImage) {
        
        autoreleasepool {
            
            let attachment = NSTextAttachment()
            
            attachment.image = image
            
            attachment.bounds = CGRect(x: 0, y: 0, width: 16 , height: 16)
            
            let textAttachmentString = NSAttributedString(attachment: attachment)
            
            let mutableStr = NSMutableAttributedString(attributedString: evInputView.inputTextView.attributedText)
            
            
            let selectedRange:NSRange = evInputView.inputTextView.selectedRange
            
            let newSelectedRange:NSRange
            
            mutableStr.insert(textAttachmentString, at: selectedRange.location)
            newSelectedRange = NSRange(location: selectedRange.location + 1, length: 0)
            
            evInputView.inputTextView.attributedText = mutableStr;
            
            evInputView.inputTextView.selectedRange = newSelectedRange;
            
            evInputView.inputTextView.font = UIFont.systemFont(ofSize: 16)
            
        }
        
        evInputView.textViewDidChanged()
        
    }
    
    func epDeleteTextFromTheBack() {
        
        autoreleasepool {
            
            let mutableStr = NSMutableAttributedString(attributedString: evInputView.inputTextView.attributedText)
            
            if mutableStr.length > 0 {
                
                mutableStr.deleteCharacters(in: NSRange(location: mutableStr.length-1, length: 1))
                
                evInputView.inputTextView.attributedText = mutableStr
                evInputView.selectedRange = NSRange(location: mutableStr.length, length: 0)
                
            }
            
        }
        
    }
    
}

// MARK: - YLInputViewDelegate
extension YLReplyView{
    
    // 按钮点击
    func epBtnClickHandle(_ inputViewBtnState:YLInputViewBtnState) {
        
        switch inputViewBtnState {
        case .record:
            updateReplyViewState(YLReplyViewState.record)
            break
        case .face:
            updateReplyViewState(YLReplyViewState.face)
            break
        case .more:
            updateReplyViewState(YLReplyViewState.more)
            break
        case .keyboard:
            updateReplyViewState(YLReplyViewState.input)
            break
        }
    }
    
    // 发送操作
    func epSendMessageText() {
        sendMessageText()
    }
    
}


// MARK: - keyboard show hide
extension YLReplyView{
    
    @objc fileprivate func keyboardWillShow(_ not:NSNotification) {
        
        if let info:NSDictionary = not.userInfo as NSDictionary? {
            if let value:NSValue = info.object(forKey: "UIKeyboardFrameEndUserInfoKey") as! NSValue? {
                
                let keyboardRect:CGRect? = value.cgRectValue
                
                if evInputView.inputTextView.isFirstResponder {
                    editInputViewConstraintWithBottom(-(keyboardRect?.size.height)!)
                    perform(#selector(YLReplyView.efDidRecoverReplyViewStateForEdit), with: nil, afterDelay: 0.0)
                }
            }
        }
        
    }
    
    @objc fileprivate func keyboardWillHide(_ not:NSNotification) {
        
        if  evReplyViewState != YLReplyViewState.face &&
            evReplyViewState != YLReplyViewState.more &&
            evReplyViewState != YLReplyViewState.record &&
            evReplyViewState != YLReplyViewState.normal {
            
            if evInputView.inputTextView.isFirstResponder {
                editInputViewConstraintWithBottom(0)
            }
            
        }
    }
}










