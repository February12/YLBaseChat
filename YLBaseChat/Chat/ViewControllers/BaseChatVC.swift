//
//  BaseChatVC.swift
//  YLBaseChat
//
//  Created by yl on 17/5/12.
//  Copyright © 2017年 yl. All rights reserved.
//

import UITableView_FDTemplateLayoutCell
import Foundation
import UIKit
import SnapKit
import YYText

class BaseChatVC: UIViewController {
    
    // 上一次播放的语音
    fileprivate var oldChatVoiceMessage:Message? = nil
    
    // 表单
    var tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    
    fileprivate var dataArray = Array<Message>()
    
    var userInfo:UserInfo!
    
    fileprivate var chatView:ChatView = ChatView(frame: CGRect.zero)
    
    deinit {
        print("====\(self)=====>被释放")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.red
        
        title = "聊天室"
        
        layoutUI()
        
        loadData()
    }
    
    
    fileprivate func layoutUI() {
        
        chatView.delegate = self
        view.addSubview(chatView)
        
        chatView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        
        tableView.register(ChatTextCell.self, forCellReuseIdentifier: "ChatTextCell")
        tableView.register(ChatImageCell.self, forCellReuseIdentifier: "ChatImageCell")
        tableView.register(ChatVoiceCell.self, forCellReuseIdentifier: "ChatVoiceCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Definition.colorFromRGB(0xf2f2f2)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        chatView.insertSubview(tableView, at: 0)
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(chatView.evInputView.snp.top)
        }
        
    }
    
    // 加载数据
    fileprivate func loadData() {
        
        tableView.isScrollEnabled = false
        
        if dataArray.count == 0 {
            
            if let oldMessages = getDataArray(0, limit: 10) {
                
                dataArray += oldMessages
                
                tableView.reloadData()
                efScrollToLastCell()
            }
        }else {
            if let oldMessages = getDataArray(dataArray.count, limit: 10) {
                
                var messages = Array<Message>()
                
                messages += oldMessages
                messages += dataArray
                dataArray.removeAll()
                dataArray += messages
                
                tableView.reloadData()
                
                let rect = tableView.rectForRow(at: IndexPath(row: oldMessages.count - 1, section: 0))
                tableView.setContentOffset(CGPoint(x: 0, y: rect.origin.y), animated: false)
            }
            
        }
        
        tableView.isScrollEnabled = true
        
    }
    
    // 获取数组中的指定区域
    fileprivate func getDataArray(_ from:Int ,limit: Int) -> Array<Message>?{
        
        let array = userInfo.messages
        
        if from > array.count - 1 {
            return nil
        }else {
            var resultArray = Array<Message>()
            
            let to = array.count - 1 - from
            
            if to - limit + 1 > 0 {
                resultArray += array[(to - limit + 1)...to]
            }else {
                resultArray += array[0...to]
            }
            return resultArray
        }
        
        
    }
    
    // 滚到最后一行
    fileprivate func efScrollToLastCell() {
        if dataArray.count > 1 {
            tableView.scrollToRow(at: IndexPath(row: dataArray.count-1, section: 0), at: UITableViewScrollPosition.middle, animated: true)
        }
    }
    
    // 开始播放录音
    fileprivate func startPlaying(_ message:Message) {
        
        if message.messageBody.type == MessageBodyType.voice.rawValue {
            
            stopPlaying()
            oldChatVoiceMessage = message
            
            if let cell = getCellByMessage(message) as? ChatVoiceCell {
                
                cell.messageAnimationVoiceImageView.startAnimating()
                
                if let range = message.messageBody.voicePath.range(of: "Caches") {
                    let path = NSHomeDirectory() + "/Library/" + message.messageBody.voicePath.substring(from: range.lowerBound)
                    VoiceManager.shared.play(path, {[weak self] in
                        self?.stopPlaying()
                    })
                }
                
            }
        }
        
    }
    
    // 停止播放录音
    fileprivate func stopPlaying() {
        
        if let oldMessage = oldChatVoiceMessage {
            if let oldChatVoiceCell = getCellByMessage(oldMessage) as? ChatVoiceCell {
                oldChatVoiceCell.messageAnimationVoiceImageView.stopAnimating()
                oldChatVoiceMessage = nil
                VoiceManager.shared.stopPlay()
            }
        }
        
    }
    
    // 根据message 获取 cell
    fileprivate func getCellByMessage(_ message:Message) -> BaseChatCell? {
        
        if let index = dataArray.index(of: message) {
            if index >= 0 && index < dataArray.count {
                return tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! BaseChatCell?
            }
        }
        return nil
    }
}


// MARK: - UITableViewDelegate,UITableViewDataSource
extension BaseChatVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let message = dataArray[indexPath.row]
        
        if message.messageBody.type == MessageBodyType.text.rawValue {
            return tableView.fd_heightForCell(withIdentifier: "ChatTextCell", cacheBy: indexPath, configuration: { (cell) in
                (cell as? ChatTextCell)?.fd_enforceFrameLayout = true
                (cell as? ChatTextCell)?.updateMessage(message, idx: indexPath)
            })
        }else if message.messageBody.type == MessageBodyType.image.rawValue {
            return tableView.fd_heightForCell(withIdentifier: "ChatImageCell", cacheBy: indexPath, configuration: { (cell) in
                (cell as? ChatImageCell)?.fd_enforceFrameLayout = true
                (cell as? ChatImageCell)?.updateMessage(message, idx: indexPath)
            })
        }else if message.messageBody.type == MessageBodyType.voice.rawValue {
            return tableView.fd_heightForCell(withIdentifier: "ChatVoiceCell", cacheBy: indexPath, configuration: { (cell) in
                (cell as? ChatVoiceCell)?.fd_enforceFrameLayout = true
                (cell as? ChatVoiceCell)?.updateMessage(message, idx: indexPath)
            })
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:BaseChatCell!
        
        let message = dataArray[indexPath.row]
        
        if message.messageBody.type == MessageBodyType.text.rawValue {
            cell = tableView.dequeueReusableCell(withIdentifier: "ChatTextCell") as! ChatTextCell
        }else if message.messageBody.type == MessageBodyType.image.rawValue {
            cell = tableView.dequeueReusableCell(withIdentifier: "ChatImageCell") as! ChatImageCell
        }else if message.messageBody.type == MessageBodyType.voice.rawValue {
            cell = tableView.dequeueReusableCell(withIdentifier: "ChatVoiceCell") as! ChatVoiceCell
            cell.delegate = self
        }
        
        cell.updateMessage(message, idx: indexPath)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        // 检测是否显示时间
        if indexPath.row > 0 {
            let upMessage = dataArray[indexPath.row - 1]
            cell.updateTime(upMessage.timestamp)
        }else {
            cell.updateTime(nil)
        }
        
        // 检测语音是否结束
        if let oldMessage = oldChatVoiceMessage {
            if oldMessage.messageId == message.messageId {
                (cell as! ChatVoiceCell).messageAnimationVoiceImageView.startAnimating()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    
}


// MARK: - BaseChatCellDelegate
extension BaseChatVC:BaseChatCellDelegate {
    
    func epDidVoiceClick(_ message: Message) {
        
        if let oldMessage = oldChatVoiceMessage {
            
            if message.messageId == oldMessage.messageId {
                stopPlaying()
                return
            }
        }
        
        startPlaying(message)
    }
}

// MARK: - ChatViewDelegate
extension BaseChatVC:ChatViewDelegate {
    
    func epSendMessageText(_ text: String) {
        
        let message = Message()
        message.timestamp = String(Int(Date().timeIntervalSince1970))
        message.direction = MessageDirection.send.rawValue
        
        let messageBody = MessageBody()
        messageBody.type = MessageBodyType.text.rawValue
        messageBody.text = text
        
        message.messageBody = messageBody
        
        RealmManagers.shared.commitWrite {
            userInfo.messages.append(message)
        }
        
        dataArray.append(userInfo.messages.last!)
        tableView.insertRows(at: [IndexPath.init(row: dataArray.count-1, section: 0)], with: UITableViewRowAnimation.bottom)
        
        efScrollToLastCell()
    }
    
    func epSendMessageImage(_ images:[UIImage]?) {
        
        if let imgs = images {
            
            var indexPaths = Array<IndexPath>()
            
            for img in imgs {
                
                let message = Message()
                message.timestamp = String(Int(Date().timeIntervalSince1970))
                message.direction = MessageDirection.send.rawValue
                
                let messageBody = MessageBody()
                messageBody.type = MessageBodyType.image.rawValue
                messageBody.image = UIImagePNGRepresentation(img) as NSData?
                
                message.messageBody = messageBody
                
                RealmManagers.shared.commitWrite {
                    userInfo.messages.append(message)
                }
                
                dataArray.append(userInfo.messages.last!)
                
                indexPaths.append(IndexPath.init(row: dataArray.count-1, section: 0))
                
            }
            
            tableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.bottom)
            
            efScrollToLastCell()
            
        }
    }
    
    func ePSendMessageVoice(_ path: String? ,duration: Int) {
        
        if let path = path {
            
            let message = Message()
            message.timestamp = String(Int(Date().timeIntervalSince1970))
            message.direction = MessageDirection.send.rawValue
            
            let messageBody = MessageBody()
            messageBody.type = MessageBodyType.voice.rawValue
            messageBody.voicePath = path
            messageBody.voiceDuration = duration
            
            message.messageBody = messageBody
            
            RealmManagers.shared.commitWrite {
                userInfo.messages.append(message)
            }
            
            dataArray.append(userInfo.messages.last!)
            tableView.insertRows(at: [IndexPath.init(row: dataArray.count-1, section: 0)], with: UITableViewRowAnimation.bottom)
            
            efScrollToLastCell()
            
        }
    }
}


// MARK: - UIScrollViewDelegate
extension BaseChatVC:UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        chatView.efPackUpInputView()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y == -64){
            loadData()
        }
        
    }
    
}
