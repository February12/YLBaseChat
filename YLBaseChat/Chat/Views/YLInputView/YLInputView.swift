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
let defaultInputViewBtnWH = 30.0
let defaultInputViewBtnBottom = 7.5

let defaultTextViewMaxH = 100.0
let defaultTextViewMinH = 35.0

enum YLInputViewBtnState:Int{
    
    case record = 101 // 录音
    case face         // 表情
    case more         // 更多
    case keyboard     // 键盘
    
}

protocol YLInputViewDelegate:NSObjectProtocol {
    
    // 按钮点击
    func epBtnClickHandle(inputViewBtnState:YLInputViewBtnState)
    // 删除操作
    func epDidDeleteTextView() -> Bool
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
    
    var inputTextView = YLPTextView.init(frame: CGRect.zero)
    
    var recordBtn:UIButton!
    var recordOperationBtn:UIButton!
    
    var faceBtn:UIButton!
    var moreBtn:UIButton!
    var keyboardBtn:UIButton!
    var selectedRange:NSRange = NSRange.init(location: 0, length: 0)
    
    var textViewFrame = YLTextViewFrame()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        efLayoutUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    // 初始化UI
    func efLayoutUI() {
        
        layer.borderColor = Definition.colorFromRGB(rgb: 0xdcdcdc).cgColor
        layer.borderWidth = 1
        backgroundColor = Definition.colorFromRGB(rgb: 0xf2f2f2)
        isUserInteractionEnabled = true
        
        // 录音按钮
        recordBtn = createBtn(imageName: "foot_sound")
        recordBtn.tag = YLInputViewBtnState.record.rawValue
        
        recordBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(defaultInputViewBtnWH)
            make.left.equalTo(5)
            make.bottom.equalTo(-defaultInputViewBtnBottom)
        }
        
        textViewFrame.left = 42
        
        // 更多
        moreBtn = createBtn(imageName: "foot_more")
        moreBtn.tag = YLInputViewBtnState.more.rawValue
        
        moreBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(defaultInputViewBtnWH)
            make.right.equalTo(-5)
            make.bottom.equalTo(-defaultInputViewBtnBottom)
        }
        
        // 表情
        faceBtn = createBtn(imageName: "btn_expression")
        faceBtn.tag = YLInputViewBtnState.face.rawValue
        
        faceBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(defaultInputViewBtnWH)
            make.right.equalTo(moreBtn.snp.left).offset(-8)
            make.bottom.equalTo(-defaultInputViewBtnBottom)
        }
        
        // 键盘
        keyboardBtn = createBtn(imageName: "btn_keyboard")
        keyboardBtn.tag = YLInputViewBtnState.keyboard.rawValue
        keyboardBtn.isHidden = false
        
        // 输入框
        inputTextView.backgroundColor = UIColor.white
        inputTextView.clipsToBounds = true
        inputTextView.layer.cornerRadius = 5.0
        inputTextView.layer.borderColor = Definition.colorFromRGB(rgb: 0xdcdcdc).cgColor
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
    func createBtn(imageName:String)-> UIButton {
    
        let btn = UIButton()
        btn.setBackgroundImage(UIImage.init(named: imageName), for: UIControlState.normal)
        
        btn.addTarget(self, action: #selector(YLInputView.btnClickHandle(btn:)), for: UIControlEvents.touchUpInside)
        
        addSubview(btn)
        
        return btn
    }
    
    // 按钮点击处理
    func btnClickHandle(btn:UIButton){
        delegate?.epBtnClickHandle(inputViewBtnState: YLInputViewBtnState.init(rawValue: btn.tag)!)
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
        delegate?.epBtnClickHandle(inputViewBtnState: YLInputViewBtnState.keyboard)
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
        
//        if(text.characters.count == 0){
//            return (delegate?.epDidDeleteTextView())!
//        }
        
        return true
    }
    
}













