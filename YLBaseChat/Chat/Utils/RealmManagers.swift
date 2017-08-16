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
    static let shared = RealmManagers()
    private init(){}
    
    // 提交事务
    func commitWrite(_ complated:() -> ()){
        let realm = try! Realm()
        try! realm.write {
            complated()
        }
    }
    
    // 同步保存数据
    func addSynModel(_ obj:Object){
        let realm = try! Realm()
        try! realm.write {
            realm.add(obj , update:true)
        }
    }
    
    // 异步保存数据
//    func addASynModel(_ obj:Object){
//        
//        DispatchQueue(label: "background").async {
//            autoreleasepool {
//            
//                let realm = try! Realm()
//                
//                realm.beginWrite()
//                
//                realm.add(obj , update:true)
//                
//                // 提交写入事务以确保数据在其他线程可用
//                try! realm.commitWrite()
//        
//            }
//        }
//    }
    
    // 查询数据
    func selectModel<T: Object>(_ type:T.Type ,predicate:NSPredicate?) -> Array<T>{
        let realm = try! Realm()
        
        var objs = Array<Object>()
        
        if(predicate == nil){
            for obj in realm.objects(type) {
                objs.append(obj.clone())
            }
        }else{
            for obj in realm.objects(type).filter(predicate!) {
                objs.append(obj.clone())
            }
        }
        
        return objs as! Array<T>
    }
    
    // 同步删除数据
    func deleteSynModel(_ obj:Object){
        let realm = try! Realm()
        try! realm.write {
            realm.delete(obj)
        }
    }
    
}
