//
//  ViewController.swift
//  YLBaseChat
//
//  Created by yl on 17/5/9.
//  Copyright © 2017年 yl. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    var tableView = UITableView.init(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
    
    var dataArray = Array<UserInfo>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataArray = dataArray + RealmManagers.shared.selectModel(UserInfo.self,predicate: nil)

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
       
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let userInfo = dataArray[indexPath.row]
        
        cell.textLabel?.text = userInfo.nickname
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let baseChatVC = BaseChatVC()
        let nav = UINavigationController.init(rootViewController: baseChatVC)
        
        self.present(nav, animated: true, completion: nil)
    }
}

