//
//  RecordingView.swift
//  YLBaseChat
//
//  Created by yl on 17/6/2.
//  Copyright © 2017年 yl. All rights reserved.
//

import Foundation
import UIKit

fileprivate let view_wh:CGFloat = 128
fileprivate let volumn_tag:Int = 10

enum RecordingState:Int {
    case volumn = 1
    case cancel
    case timeTooShort
}

class RecordingView: UIView {
    
    var recordingState:RecordingState? {
        
        willSet(value){
            
            isHidden = false
            
            switch value {
                
            case .none:
                break
            case .some(RecordingState.cancel):
                if recordingState != value {
                    setupCancelSendView()
                }
                break
            case .some(RecordingState.volumn):
                if recordingState != value {
                    setupShowVolumnState()
                }
                break
            case .some(RecordingState.timeTooShort):
                if recordingState != value {
                    setupShowRecordingTooShort()
                }
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {[weak self] in
                    self?.isHidden = true
                }
                break
            }
  
        }
    }
    
    var volume:Float? {
       
        willSet(value) {
            
            if recordingState != RecordingState.volumn {return}
            
            if let volumnImage = viewWithTag(volumn_tag) {
                if let num = value {
                    volumnImage.yl_height = CGFloat(33.0 / 1.0 * num)
                    volumnImage.yl_y = volumnImage.yl_bottom - volumnImage.yl_height
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func layoutUI() {
        
        frame = CGRect(x: 0, y: 0, width: view_wh, height: view_wh)
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        recordingState = RecordingState.volumn
        
        setupShowVolumnState()
    }
    
    fileprivate func setupCancelSendView() {
        
        for view in subviews {
            view.removeFromSuperview()
        }
        
        let imageView = UIImageView(image: UIImage(named: "dd_cancel_send_record"))
        imageView.frame = CGRect(x: (view_wh - 45) / 2, y: 18, width: 45, height: 59)
        
        addSubview(imageView)
        
        let label = UILabel.init(frame: CGRect.init(x: 0, y: view_wh-33, width: view_wh, height: 23))
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "松开手指，取消发送"
        
        addSubview(label)
        
    }
    
    fileprivate func setupShowVolumnState() {
        
        for view in subviews {
            view.removeFromSuperview()
        }
        
        let imageView = UIImageView(image: UIImage(named: "ico_talk_hint_voice-tube"))
        imageView.frame = CGRect(x: 8, y: 18, width: 67, height: 67)
        
        addSubview(imageView)
        
        let label = UILabel.init(frame: CGRect.init(x: 0, y: view_wh-33, width: view_wh, height: 23))
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "手指上滑,取消发送"
        
        addSubview(label)
        
        
        let volumnImage = UIImageView(image: UIImage(named: "ico_talk_hint_volume"))
        volumnImage.frame = CGRect(x: imageView.yl_right + 6, y: imageView.yl_bottom - 33, width: 20, height: 33)
        volumnImage.contentMode = UIViewContentMode.bottom
        volumnImage.clipsToBounds = true
        
        volumnImage.tag = volumn_tag
        
        addSubview(volumnImage)
    }
    
    fileprivate func setupShowRecordingTooShort() {
        
        for view in subviews {
            view.removeFromSuperview()
        }
        
        let imageView = UIImageView(image: UIImage(named: "dd_record_too_short"))
        imageView.frame = CGRect(x: (view_wh - 22) / 2, y: 18, width: 22 * 0.8, height: 83 * 0.8)
        
        addSubview(imageView)
        
        let label = UILabel.init(frame: CGRect.init(x: 0, y: view_wh-33, width: view_wh, height: 23))
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "说话时间太短"
        
        addSubview(label)
        
    }
    
}
