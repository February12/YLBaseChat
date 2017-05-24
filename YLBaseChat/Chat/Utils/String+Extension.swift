//
//  String+Extension.swift
//  YLBaseChat
//
//  Created by yl on 17/5/24.
//  Copyright © 2017年 yl. All rights reserved.
//

import Foundation
import UIKit
import YYText

struct YLTextRange {
    
}

// MARK: - String 拓展
extension String {
    
    // text 转 NSAttributedString (只需识别表情)
    func conversionAttributedString() -> NSMutableAttributedString? {
        
        let content = self;
        
        if (content.characters.count == 0) {
            return nil;
        }
        
//        var tmpImageArray = Array<YLTextRange>()
        
        NSRegularExpression().enumerateMatches(in: "\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]", options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0,length: 15)) { (result:NSTextCheckingResult?, flags:NSRegularExpression.MatchingFlags, stop) in
            
            print("")
            
        }
        
        return nil
    }
    
}
