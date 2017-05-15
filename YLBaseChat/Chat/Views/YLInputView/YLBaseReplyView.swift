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
private let defaultPanelViewH = 210

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

class YLBaseReplyView: UIView {
    
    private var evInputView:YLInputView! // 输入框
    
    private var evReplyViewState:YLReplyViewState = YLReplyViewState.normal
    
    private var evFacePanelView:UIView!
    private var evMorePanelView:UIView!
}














