//
//  YLTouchesGestureRecognizer.swift
//  YLBaseChat
//
//  Created by yl on 17/5/18.
//  Copyright © 2017年 yl. All rights reserved.
//

import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass

class YLTouchesGestureRecognizer:UIGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        state = UIGestureRecognizerState.began
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        state = UIGestureRecognizerState.changed
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        state = UIGestureRecognizerState.ended
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        state = UIGestureRecognizerState.ended
    }
    
    override func reset() {
        state = UIGestureRecognizerState.possible
    }
    
}
