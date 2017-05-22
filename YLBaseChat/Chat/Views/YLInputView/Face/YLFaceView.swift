//
//  YLFaceView.swift
//  YLBaseChat
//
//  Created by yl on 17/5/22.
//  Copyright © 2017年 yl. All rights reserved.
//

import UIKit

class YLFaceView: UIView {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    fileprivate var emojiDic:NSDictionary!
    fileprivate var emojiImages = Array<String>()
    
    override func awakeFromNib() {
        layoutUI()
    }
    
    fileprivate func layoutUI() {
        backgroundColor = UIColor.white
        
        let path = Bundle.main.path(forResource: "emojiImage.plist", ofType: nil)
        emojiDic = NSDictionary.init(contentsOfFile: path!)
        
        for i in 0...25 {
            emojiImages.append("emot_ic_\(i)")
        }
        
        // UIScrollView
        scrollView.backgroundColor = UIColor.white
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize.init(width: YLScreenWidth*2, height: 0)
        
        for index in 0...1 {
            
            let view:UIView = UIView.init(frame: CGRect.init(x: 10 + YLScreenWidth * CGFloat(index), y: 5, width: YLScreenWidth - 20, height: 170))
            view.backgroundColor = UIColor.clear
            scrollView.addSubview(view)
            
            let everypages:Int = 20
            let everyrows:Int = 7
            let row:Int = 3
            
            for i in 0...(row - 1) {
                
                for j in 0...(everyrows - 1) {
                    let w:CGFloat = 38.0
                    let space = (view.frame.size.width - CGFloat(everyrows) * w)/CGFloat(everyrows + 1)
                    let btn:UIButton = UIButton.init(frame: CGRect.init(x:space + (space + w) * CGFloat(j), y: CGFloat(i) * (w + 10) + 10, width: ceil(w), height: ceil(w)))
                    btn.backgroundColor = UIColor.clear
                    
                    if i * everyrows + j + index * everypages > emojiImages.count {
                        return
                    }else{
                        
                        if (i * everyrows + j == everypages) ||
                            (i * everyrows + j + index * everypages == emojiImages.count) {
                            
                            btn.setImage(UIImage.init(named: "delete_expression"), for: UIControlState.normal)
                            btn.tag = 1000
                        }else{
                
                            btn.setImage(UIImage.init(named: emojiImages[i * everyrows + j + index * everypages]), for: UIControlState.normal)
                            btn.tag = i * everyrows + j + index * everypages
                        }
                        
                        btn.addTarget(self, action: #selector(YLFaceView.emojiSelected(_:)), for: UIControlEvents.touchUpInside)
                        
                        view.addSubview(btn)
                        
                    }
                    
                }
                
            }
            
            
        }
        
    }
    
    @objc fileprivate func emojiSelected(_ btn:UIButton){
    
    }
    
    @IBAction func sendBtn(_ sender: UIButton) {
    }
}
