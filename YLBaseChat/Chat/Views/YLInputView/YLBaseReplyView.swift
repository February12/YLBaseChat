//
//  YLBaseReplyView.swift
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

class YLBaseReplyView: UIView,YLInputViewDelegate {
    
    var evInputView:YLInputView! // 输入框
    
    var evReplyViewState:YLReplyViewState = YLReplyViewState.normal
    
    var evFacePanelView:UIView!  // 表情面板
    var evMorePanelView:UIView!  // 更多面板
  
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        efLayoutUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func efLayoutUI() {
    
        // 默认大小
        frame = CGRect.init(x: 0, y: 0, width: YLScreenWith, height: YLScreenHeight)
        backgroundColor = UIColor.clear
        
        evInputView = YLInputView.init(frame: CGRect.zero)
        evInputView.delegate = self
        
        addSubview(evInputView)
        
        editInputViewConstraintWithBottom(0)
     
        evFacePanelView = efAddFacePanelView()
        editPanelViewConstraintWithPanelView(evFacePanelView)
        
        evMorePanelView = efAddMorePanelView()
        editPanelViewConstraintWithPanelView(evMorePanelView)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(YLBaseReplyView.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(YLBaseReplyView.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
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
}


// MARK: - 子类需要重写
extension YLBaseReplyView{

    // 添加表情面板
    func efAddFacePanelView() -> UIView {
        let faceView = UIView()
        faceView.backgroundColor = UIColor.white
        return faceView
    }
    
    // 添加更多面板
    func efAddMorePanelView() -> UIView {
        let panelView = UIView()
        panelView.backgroundColor = UIColor.white
        return panelView
    }
    
    // 恢复普通状态
    func efDidRecoverReplyViewStateForNormal() {}
    
    // 恢复编辑状态
    func efDidRecoverReplyViewStateForEdit() {}
    
}


// MARK: - 状态切换
extension YLBaseReplyView{
    
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
            
            perform(#selector(YLBaseReplyView.efDidRecoverReplyViewStateForNormal), with: nil, afterDelay: 0.0)
            
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
            
            perform(#selector(YLBaseReplyView.efDidRecoverReplyViewStateForEdit), with: nil, afterDelay: 0.0)
            
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
            
            perform(#selector(YLBaseReplyView.efDidRecoverReplyViewStateForEdit), with: nil, afterDelay: 0.0)
            
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
            
            perform(#selector(YLBaseReplyView.efDidRecoverReplyViewStateForEdit), with: nil, afterDelay: 0.0)
            
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

// MARK: - YLInputViewDelegate
extension YLBaseReplyView{
    
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
    func epSendMessageText() {}
    // 文本框完成高度适配
    func epTextViewAutoHeightComplated() {}
}


// MARK: - keyboard show hide
extension YLBaseReplyView{

    @objc fileprivate func keyboardWillShow(_ not:NSNotification) {
    
        if let info:NSDictionary = not.userInfo as NSDictionary? {
            if let value:NSValue = info.object(forKey: "UIKeyboardFrameEndUserInfoKey") as! NSValue? {
                
                let keyboardRect:CGRect? = value.cgRectValue
                
                if evInputView.inputTextView.isFirstResponder {
                    editInputViewConstraintWithBottom(-(keyboardRect?.size.height)!)
                    perform(#selector(YLBaseReplyView.efDidRecoverReplyViewStateForEdit), with: nil, afterDelay: 0.0)
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










