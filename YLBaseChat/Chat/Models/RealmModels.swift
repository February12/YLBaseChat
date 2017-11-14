//
//  RealmModels.swift
//  YLBaseChat
//
//  Created by yl on 17/5/9.
//  Copyright © 2017年 yl. All rights reserved.
//

import UIKit
import RealmSwift

// 自定义拷贝
extension Object {
    @objc func clone() -> Object {
        return Object()
    }
}

// 消息方向类型
enum MessageDirection:Int{
    case send = 1 // 发送的消息
    case receive  // 接收的消息
    
}
// 消息体类型
enum MessageBodyType:Int{
    case text = 1
    case image
    case voice
    
}

// 用户model
class Conversation: Object {
    
    @objc dynamic var conversationId = NSUUID().uuidString // 用户id
    
    @objc dynamic var nickname = "" // 昵称
    
    let messages = List<Message>()  // 用户对应的聊天消息
    
    override static func primaryKey() -> String? {
        return "conversationId"
    }
    
    override func clone() -> Conversation {
        let conversation = Conversation()
        conversation.conversationId = conversationId
        conversation.nickname = nickname
        for message in messages {
            conversation.messages.append(message.clone())
        }
        
        return conversation
    }
}

// 消息model
class Message: Object {
    
    @objc dynamic var messageId = NSUUID().uuidString // 消息id
    
    @objc dynamic var timestamp = ""   // 时间戳
    
    @objc dynamic var direction = 0    // 消息方向
    
    @objc dynamic var messageBody:MessageBody! // 消息体
    
    override static func primaryKey() -> String? {
        return "messageId"
    }
    
    override func clone() -> Message {
        let message = Message()
        message.messageId = messageId
        message.timestamp = timestamp
        message.direction = direction
        message.messageBody = messageBody.clone()
        return message
    }
}

// 消息体
class MessageBody: Object {
    
    @objc dynamic var type = 0
    // 文字
    @objc dynamic var text = ""
    // 图片
    @objc dynamic var image:NSData? = nil
    // 语音
    @objc dynamic var voicePath = ""
    @objc dynamic var voiceDuration = 0
    
    override func clone() -> MessageBody {
        let messageBody = MessageBody()
        messageBody.type = type
        messageBody.text = text
        messageBody.image = image
        messageBody.voicePath = voicePath
        messageBody.voiceDuration = voiceDuration
        return messageBody
    }
}


