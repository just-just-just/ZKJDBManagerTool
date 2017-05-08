//
//  ViewController.swift
//  ZKJDBManagerTool
//
//  Created by zkj on 2017/5/8.
//  Copyright © 2017年 zkj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 创建db
        let manager: ZKJDBManager = ZKJDBManager(withDBName: "testDB")
        // 单个插入
        manager.insert(object: "this is first data", intoTable: "testTable")
        // 批量插入
        manager.insert(objects: ["this is second data", 1, 5.3, ["string1", "string2"], ["key1": "value1", "key2": "value2"]], intoTable: "testTable")
        // 查询全部
        print("all items :")
        let results = manager.queryAll(fromTable: "testTable")
        for item in results! {
            let dbItem: ZKJDBItem = item as! ZKJDBItem
            dbItem.itemDescription()
        }
        // 按id查询
        print("id item :")
        let result = manager.query(byId: 1, fromTable: "testTable")
        result?.itemDescription()
        // 按type查询
        print("type item :")
        let results2 = manager.query(byType: "String", fromTable: "testTable")
        for item2 in results2! {
            let dbItem: ZKJDBItem = item2
            dbItem.itemDescription()
        }
        // delete by id
        manager.delete(byId: 1, fromTable: "testTable")
        print("delete id items :")
        let results3 = manager.queryAll(fromTable: "testTable")
        for item3 in results3! {
            let dbItem: ZKJDBItem = item3 as! ZKJDBItem
            dbItem.itemDescription()
        }
        // delete by type
        manager.delete(byType: "String", fromTable: "testTable")
        print("delete type items :")
        let results4 = manager.queryAll(fromTable: "testTable")
        for item4 in results4! {
            let dbItem: ZKJDBItem = item4 as! ZKJDBItem
            dbItem.itemDescription()
        }
        // update
        manager.update(byId: 3, withObject: 9.5, fromTable: "testTable")
        print("update items :")
        let results5 = manager.queryAll(fromTable: "testTable")
        for item5 in results5! {
            let dbItem: ZKJDBItem = item5 as! ZKJDBItem
            dbItem.itemDescription()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

