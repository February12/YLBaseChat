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
    var text:String?
    var range:NSRange?
}

// MARK: - String 拓展
extension String {
    
    // text 转 NSAttributedString (只需识别表情)
    func conversionAttributedString() -> NSMutableAttributedString? {
        
        let content = self;
        
        if (content.characters.count == 0) {
            return nil;
        }
        
        var tmpImageArray = Array<YLTextRange>()
        
        let regex = try! NSRegularExpression(pattern: "\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]", options: NSRegularExpression.Options(rawValue: 0))
        
        let regexArray = regex.matches(in: content, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0,length: content.characters.count))
        
        for result:NSTextCheckingResult in regexArray {
        
            let range = result.range
            
            tmpImageArray.append(YLTextRange(text: content.substring(with: yl_range(range)!),range: range))
            
        }
            
    
        return nil
    }
    
    // NSRange -> Range<String.Index>
    func yl_range(_ nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from..<to
    }
    
}
