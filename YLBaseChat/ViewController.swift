//
//  ViewController.swift
//  YLBaseChat
//
//  Created by yl on 17/5/9.
//  Copyright © 2017年 yl. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var tableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
    
    var dataArray = Array<Conversation>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataArray += RealmManagers.shared.selectModel(Conversation.self,predicate: nil)
        
        if dataArray.count == 0 {
            addData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        
    }
    
    func addData() {
        
        let conversation = Conversation()
        conversation.nickname = "龙五"
        
        RealmManagers.shared.addSynModel(conversation.clone())
        
        let message = Message()
        message.timestamp = "1494573288"
        message.direction = MessageDirection.receive.rawValue
        
        let messageBody = MessageBody()
        messageBody.type = MessageBodyType.text.rawValue
        messageBody.text = "第一条消息[鲜花]庆祝一下https://github.com/zhuyunlongYL/YLBaseChat 点击一下吧"
        
        message.messageBody = messageBody
        
        conversation.messages.append(message)
        RealmManagers.shared.addSynModel(conversation.clone())
        
        dataArray += RealmManagers.shared.selectModel(Conversation.self,predicate: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let conversation = dataArray[indexPath.row]
        
        cell.textLabel?.text = conversation.nickname
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let baseChatVC = BaseChatVC()
        
        let conversation = dataArray[indexPath.row]
        
        baseChatVC.conversation = conversation
        
        self.navigationController?.pushViewController(baseChatVC, animated: true)
    }
}

