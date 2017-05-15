//
//  BaseChatVC.swift
//  YLBaseChat
//
//  Created by yl on 17/5/12.
//  Copyright © 2017年 yl. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class BaseChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    // 表单
    var tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    
    var dataArray = Array<Message>()
    
    var userInfo:UserInfo!
    
    deinit {
        print("====\(self)=====>被释放")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        
        title = "聊天室"
        
        layoutUI()
        
        loadData()
    }
    
    
    func layoutUI() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
    }
    
    func loadData() {
        
        dataArray += userInfo.messages
        
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!

        let message = dataArray[indexPath.row]

        let messageBody = message.messageBody
        
        if(message.direction == MessageDirection.MessageDirectionSend.rawValue){
            cell.textLabel?.text = "我:  " + (messageBody?.text)!
        }else{
            cell.textLabel?.text = "对方: " + (messageBody?.text)!
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}
