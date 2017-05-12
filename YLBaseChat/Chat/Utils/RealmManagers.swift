//
//  RealmManagers.swift
//  YLBaseChat
//
//  Created by yl on 17/5/11.
//  Copyright © 2017年 yl. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManagers{

    // 单例
    static let shared = RealmManagers.init()
    private init(){}
    
    // 同步保存数据
    func addSynModel(_ obj:Object){
        let realm = try! Realm()
        try! realm.write {
            realm.add(obj)
        }
    }
    
    // 异步保存数据
    func addASynModel(_ obj:Object){
        
        DispatchQueue(label: "background").async {
            autoreleasepool {
            
                let realm = try! Realm()
                
                realm.beginWrite()
                
                realm.add(obj)
                
                // 提交写入事务以确保数据在其他线程可用
                try! realm.commitWrite()
        
            }
        }
    }
    
    // 查询数据
    func selectModel<T: Object>(_ type:T.Type ,predicate:NSPredicate?) -> Results<T>{
        let realm = try! Realm()
        
        var objs:Results<T>!
        
        if(predicate == nil){
            objs = realm.objects(type)
        }else{
            objs = realm.objects(type).filter(predicate!)
        }
        
        return objs
    }
    
}
