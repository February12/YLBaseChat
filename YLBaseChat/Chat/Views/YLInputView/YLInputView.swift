//
//  YLInputView.swift
//  YLBaseChat
//
//  Created by yl on 17/5/15.
//  Copyright © 2017年 yl. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

let defaultInputViewH = 46.0
private let defaultInputViewBtnWH = 30.0
private let defaultInputViewBtnBottom = 7.5

private let defaultTextViewMaxH = 100.0
private let defaultTextViewMinH = 35.0

enum YLInputViewBtnState:Int{
    
    case record = 101 // 录音
    case face         // 表情
    case more         // 更多
    case keyboard     // 键盘
    
}

protocol YLInputViewDelegate:NSObjectProtocol {
    
    // 按钮点击
    func epBtnClickHandle(_ inputViewBtnState:YLInputViewBtnState)
    // 发送操作
    func epSendMessageText()
}

struct YLTextViewFrame {
    var top = 5
    var bottom = -5
    var left = 10
    var right = -81
}

class YLInputView: UIView,UITextViewDelegate {
   
    weak var delegate:YLInputViewDelegate?
    
    private var inputTextView = YLPTextView.init(frame: CGRect.zero)
    
    private var recordBtn:UIButton!
    private var recordOperationBtn:UIButton!
    
    private var faceBtn:UIButton!
    private var moreBtn:UIButton!
    private var keyboardBtn:UIButton!
    private var selectedRange:NSRange = NSRange.init(location: 0, length: 0)
    
    private var textViewFrame = YLTextViewFrame()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        efLayoutUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    // 初始化UI
    private func efLayoutUI() {
        
        layer.borderColor = Definition.colorFromRGB(0xdcdcdc).cgColor
        layer.borderWidth = 1
        backgroundColor = Definition.colorFromRGB(0xf2f2f2)
        isUserInteractionEnabled = true
        
        // 录音按钮
        recordBtn = createBtn("foot_sound")
        recordBtn.tag = YLInputViewBtnState.record.rawValue
        
        recordBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(defaultInputViewBtnWH)
            make.left.equalTo(5)
            make.bottom.equalTo(-defaultInputViewBtnBottom)
        }
        
        textViewFrame.left = 42
        
        // 更多
        moreBtn = createBtn("foot_more")
        moreBtn.tag = YLInputViewBtnState.more.rawValue
        
        moreBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(defaultInputViewBtnWH)
            make.right.equalTo(-5)
            make.bottom.equalTo(-defaultInputViewBtnBottom)
        }
        
        // 表情
        faceBtn = createBtn("btn_expression")
        faceBtn.tag = YLInputViewBtnState.face.rawValue
        
        faceBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(defaultInputViewBtnWH)
            make.right.equalTo(moreBtn.snp.left).offset(-8)
            make.bottom.equalTo(-defaultInputViewBtnBottom)
        }
        
        // 键盘
        keyboardBtn = createBtn("btn_keyboard")
        keyboardBtn.tag = YLInputViewBtnState.keyboard.rawValue
        keyboardBtn.isHidden = false
        
        // 输入框
        inputTextView.backgroundColor = UIColor.white
        inputTextView.clipsToBounds = true
        inputTextView.layer.cornerRadius = 5.0
        inputTextView.layer.borderColor = Definition.colorFromRGB(0xdcdcdc).cgColor
        inputTextView.layer.borderWidth = 1
        inputTextView.delegate = self
        inputTextView.font = UIFont.systemFont(ofSize: 16)
        inputTextView.returnKeyType = UIReturnKeyType.send
        
        addSubview(inputTextView)
        
        inputTextView.snp.remakeConstraints { (make) in
            make.top.equalTo(textViewFrame.top)
            make.bottom.equalTo(textViewFrame.bottom)
            make.left.equalTo(textViewFrame.left)
            make.right.equalTo(textViewFrame.right)
        }
        
        
        recordOperationBtn = UIButton()
        recordOperationBtn.setTitle("按住 说话", for: UIControlState.normal)
        recordOperationBtn.setTitle("松开 结束", for: UIControlState.selected)
        recordOperationBtn.setBackgroundImage(UIImage.init(named: "bg_talk_presstalk")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5), resizingMode: UIImageResizingMode.stretch), for: UIControlState.normal)
        recordOperationBtn.setBackgroundImage(UIImage.init(named: "bg_talk_presstalk_pressed")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5), resizingMode: UIImageResizingMode.stretch), for: UIControlState.selected)
        recordOperationBtn.isHidden = true
        
        addSubview(recordOperationBtn)
        
        recordOperationBtn.snp.makeConstraints { (make) in
            make.top.equalTo(textViewFrame.top)
            make.bottom.equalTo(textViewFrame.bottom)
            make.left.equalTo(textViewFrame.left)
            make.right.equalTo(textViewFrame.right)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(YLInputView.textViewDidChanged), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    // 创建按钮
    private func createBtn(_ imageName:String)-> UIButton {
    
        let btn = UIButton()
        btn.setBackgroundImage(UIImage.init(named: imageName), for: UIControlState.normal)
        
      btn.addTarget(self, action: #selector(YLInputView.btnClickHandle(_:)), for: UIControlEvents.touchUpInside)
        
        addSubview(btn)
        
        return btn
    }
    
    // 按钮点击处理
    func btnClickHandle(_ btn:UIButton){
        delegate?.epBtnClickHandle(YLInputViewBtnState.init(rawValue: btn.tag)!)
    }
    
    // textView 文本内容改变
    func textViewDidChanged() {
        perform(#selector(YLInputView.updateDisplayByInputContentTextChange), with: nil, afterDelay: 0.1)
    }
    
    func updateDisplayByInputContentTextChange() {
        
        var height = ceilf(Float(inputTextView.sizeThatFits(inputTextView.frame.size).height))
        
        if(height <= Float(defaultTextViewMinH)){
            height = Float(defaultTextViewMinH)
        }else if(height >= Float(defaultTextViewMaxH)){
            height = Float(defaultTextViewMaxH)
        }
        
        inputTextView.snp.remakeConstraints { (make) in
            make.top.equalTo(textViewFrame.top)
            make.bottom.equalTo(textViewFrame.bottom)
            make.left.equalTo(textViewFrame.left)
            make.right.equalTo(textViewFrame.right)
            make.height.equalTo(height)
        }
        
        layoutIfNeeded()
    }
    
    // textView Delegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        delegate?.epBtnClickHandle(YLInputViewBtnState.keyboard)
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        selectedRange = textView.selectedRange
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n"){
            delegate?.epSendMessageText()
            return false
        }
                
        return true
    }
    
}













