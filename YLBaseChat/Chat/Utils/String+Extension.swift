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

// MARK: - String 拓展
extension String {
    
    // text 转 NSAttributedString
    func yl_conversionAttributedString() -> NSMutableAttributedString? {
        
        let content = self;
        
        if (content.characters.count == 0) {
            return nil;
        }
        
        let path = Bundle.main.path(forResource: "emojiImage.plist", ofType: nil)
        let emojiDic = NSDictionary(contentsOfFile: path!)
        
        let mutableText = NSMutableAttributedString(string: content)
        
        // 识别网址
        let regexURL = try! NSRegularExpression(pattern: "[a-zA-z]+://[^\\s]*", options: NSRegularExpression.Options(rawValue: 0))
        
        let regexArrayURL = regexURL.matches(in: content, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0,length: content.characters.count))
        
        for result:NSTextCheckingResult in regexArrayURL {
            
            let range = result.range
            
            let border = YYTextBorder(fill: UIColor.lightGray, cornerRadius: 0)
            let highlight = YYTextHighlight()
            highlight.setColor(UIColor.blue)
            highlight.setBackgroundBorder(border)
            
            mutableText.yy_setColor(UIColor.blue, range: range)
            mutableText.yy_setTextHighlight(highlight, range: range)
            
        }
        
        // 识别表情
        let regex = try! NSRegularExpression(pattern: "\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]", options: NSRegularExpression.Options(rawValue: 0))
        
        var regexArray:Array = regex.matches(in: content, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0,length: content.characters.count))

        let size = CGSize(width: 18, height: 18)
        let font = UIFont.systemFont(ofSize: 16)
        
        regexArray = regexArray.reversed()
        for result:NSTextCheckingResult in regexArray {
            
            let range = result.range
            let name = emojiDic?[content.substring(with: yl_range(range)!)]
            
            let img = UIImage(named: name as! String)?.yl_scaleToSize(size)
            let attachment = NSMutableAttributedString.yy_attachmentString(withContent: img, contentMode: .center, attachmentSize: size, alignTo: font, alignment: YYTextVerticalAlignment.center)
            
            mutableText.replaceCharacters(in: range, with: attachment)
            
        }
        
        return mutableText
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
