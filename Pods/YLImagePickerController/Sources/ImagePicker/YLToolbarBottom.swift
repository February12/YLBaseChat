//
//  YLToolbarBottom.swift
//  YLImagePickerController
//
//  Created by yl on 2017/9/1.
//  Copyright © 2017年 February12. All rights reserved.
//

import UIKit

class YLToolbarBottom: UIView {
    
    @IBOutlet weak var sendBtn: UIButton!
    
    var sendBtnDefaultColor: UIColor?
    
    override func awakeFromNib() {
        sendBtnDefaultColor = sendBtn.backgroundColor
    }
    
    func sendBtnIsSelect(_ isSelect: Bool) {
        if isSelect == false {
            sendBtn.backgroundColor = UIColor.lightGray
            sendBtn.isEnabled = false
        }else {
            sendBtn.backgroundColor = sendBtnDefaultColor
            sendBtn.isEnabled = true
        }
    }
    
    // 根据xib初始化
    class func loadNib() -> YLToolbarBottom {
        
        if let toolbar = Bundle.yl_imagePickerNibBundle().loadNibNamed("YLToolbarBottom", owner: nil, options: nil)?.first as? YLToolbarBottom {
            return toolbar
        }else {
            return YLToolbarBottom()
        }
        
    }
}
