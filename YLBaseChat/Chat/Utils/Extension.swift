//
//  Extension.swift
//  YLBaseChat
//
//  Created by yl on 17/5/24.
//  Copyright © 2017年 yl. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Date
extension Date {

    // 返回聊天室的时间
    func getShowFormat() -> String {
        
        let requestDate = self
        
        //获取当前时间
        let calendar = Calendar.current
        //判断是否是今天
        if calendar.isDateInToday(requestDate as Date) {
            //获取当前时间和系统时间的差距(单位是秒)
            //强制转换为Int
            let since = Int(Date().timeIntervalSince(requestDate as Date))
            //  是否是刚刚
            if since < 60 {
                return "刚刚"
            }
            //  是否是多少分钟内
            if since < 60 * 60 {
                return "\(since/60)分钟前"
            }
            //  是否是多少小时内
            return "\(since / (60 * 60))小时前"
        }
        
        //判断是否是昨天
        var formatterString = " HH:mm"
        if calendar.isDateInYesterday(requestDate as Date) {
            formatterString = "昨天" + formatterString
        } else {
            //判断是否是一年内
            formatterString = "MM-dd" + formatterString
            //判断是否是更早期
            
            let comps = calendar.dateComponents([Calendar.Component.year], from: requestDate, to: Date())
            
            if comps.year! >= 1 {
                formatterString = "yyyy-" + formatterString
            }
        }
        
        //按照指定的格式将日期转换为字符串
        //创建formatter
        let formatter = DateFormatter()
        //设置时间格式
        formatter.dateFormat = formatterString
        //设置时间区域
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale!
        
        //格式化
        return formatter.string(from: requestDate as Date)
    }
}

// MARK: - UIImage
extension UIImage {

    func yl_scaleToSize(_ size:CGSize) -> UIImage {
    
        // 创建一个bitmap的context
        // 并把它设置成为当前正在使用的context
        UIGraphicsBeginImageContext(size);
        // 绘制改变大小的图片
        self.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        // 从当前context中创建一个改变大小后的图片
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        // 返回新的改变大小后的图片
        return img;

        
    }
    
}
