//
//  ZKJDBManager.swift
//  SwiftDemo
//
//  Created by zkj on 2017/4/27.
//  Copyright © 2017年 zkj. All rights reserved.
//

import UIKit
import SQLite

class ZKJDBManager: NSObject {
    
    // MARK: - CONFIG
    func defaultPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
    let DEFAULTE_DB_NAME                = "database"
    let dbId                            = Expression<Int64>("dbId")
    let dbObject                        = Expression<String>("dbObject")
    let dbType                          = Expression<String>("dbType") // String, Int, Float, [Any], [String: Any], nil
    let dbCreateTime                    = Expression<String>("dbCreateTime")
    
    // MARK: - PROPERTY
    var db: Connection?
    var tableHandler: Table?
    var dbPath: String?
    
    // MARK: - 初始化
    // 初始化db
    init(withDBName DBName: String) {
        super.init()
        
        if checkTableName(tableName: DBName) {
            db = try? Connection("\(defaultPath())/\(DBName).sqlite3")
            dbPath = "\(defaultPath())/\(DBName).sqlite3"
        } else {
            db = try? Connection("\(defaultPath())/\(DEFAULTE_DB_NAME).sqlite3")
            dbPath = "\(defaultPath())/\(DEFAULTE_DB_NAME).sqlite3"
        }
    }
    
    // 创建表
    func createTable(tableName: String) {
        
        if !checkTableName(tableName: tableName) {
            print("failed to create table: \(tableName)")
            return
        }
        
        tableHandler = Table.init(tableName)
        try! db?.run((tableHandler?.create(ifNotExists: true, block: { (table) in
            table.column(dbId, primaryKey: true)
            table.column(dbObject)
            table.column(dbType)
            table.column(dbCreateTime, unique: true)
        }))!)
    }
    
    // MARK: - INSERT
    // 单个插入
    func insert(object: Any, intoTable tableName: String) {
        
        createTable(tableName: tableName)
        
        let result: [String: String] = exchangeObjToStandardType(object: object)
        let resultObj: String = result["obj"]!
        let resultType: String = result["type"]!
        
        let insert = tableHandler?.insert(dbObject <- resultObj, dbCreateTime <- self.dateNowAsString(), dbType <- resultType)
        _ = (try! db?.run(insert!))!
        
    }
    
    // 批量插入
    func insert(objects: [Any], intoTable tableName: String) {
        
        createTable(tableName: tableName)
        
        for object in objects {
            
            let result: [String: String] = exchangeObjToStandardType(object: object)
            let resultObj: String = result["obj"]!
            let resultType: String = result["type"]!
            
            let insert = tableHandler?.insert(dbObject <- resultObj, dbCreateTime <- self.dateNowAsString(), dbType <- resultType)
            _ = (try! db?.run(insert!))!
            
        }
    }
    
    // MARK: - QUERY
    // 查询所有
    func queryAll(fromTable tableName: String) -> [Any]? {
        
        createTable(tableName: tableName)
        
        var result: [Any] = [Any].init()

        for table in (try! db?.prepare(tableHandler!))! {
            
            let dbItem: ZKJDBItem = ZKJDBItem()
            dbItem.itemId = Int.init(table[dbId])
            dbItem.itemType = table[dbType]
            dbItem.itemCreateTime = table[dbCreateTime]
            
            // String, Int, Float, [Any], [String: Any], nil
            if table[dbType] == "String" {
                dbItem.itemObject = table[dbObject]
            } else if table[dbType] == "Int" {
                let stringValue: String = table[dbObject]
                dbItem.itemObject = Int.init(stringValue)
            } else if table[dbType] == "Float" {
                let stringValue: String = table[dbObject]
                dbItem.itemObject = Float.init(stringValue)
            } else {
                let stringValue: String = table[dbObject]
                let jsonData: Data = stringValue.data(using: .utf8)!
                let resultObj: Any = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                dbItem.itemObject = resultObj
            }
            result.append(dbItem)
        }
        if result.count != 0 {
            return result
        }
        return nil
    }
    
    // 根据id查询
    func query(byId queryId: Int, fromTable tableName: String) -> ZKJDBItem? {
        
        createTable(tableName: tableName)
        
        let queryIdInt64 = Int64.init(queryId)
        for table in (try! db?.prepare(tableHandler!.filter(dbId == queryIdInt64)))! {
            
            let dbItem: ZKJDBItem = ZKJDBItem()
            dbItem.itemId = Int.init(table[dbId])
            dbItem.itemType = table[dbType]
            dbItem.itemCreateTime = table[dbCreateTime]
            
            // String, Int, Float, [Any], [String: Any], nil
            if table[dbType] == "String" {
                dbItem.itemObject = table[dbObject]
            } else if table[dbType] == "Int" {
                let stringValue: String = table[dbObject]
                dbItem.itemObject = Int.init(stringValue)
            } else if table[dbType] == "Float" {
                let stringValue: String = table[dbObject]
                dbItem.itemObject = Float.init(stringValue)
            } else {
                let stringValue: String = table[dbObject]
                let jsonData: Data = stringValue.data(using: .utf8)!
                let resultObj: Any = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                dbItem.itemObject = resultObj
            }
            return dbItem
        }
        return nil
    }
    
    // 根据类别查询
    func query(byType queryType: String, fromTable tableName: String) -> [ZKJDBItem]? {
        
        createTable(tableName: tableName)
        
        var result: [ZKJDBItem]? = [ZKJDBItem].init()
        for table in (try! db?.prepare(tableHandler!.filter(dbType == queryType)))! {
            
            let dbItem: ZKJDBItem = ZKJDBItem()
            dbItem.itemId = Int.init(table[dbId])
            dbItem.itemType = table[dbType]
            dbItem.itemCreateTime = table[dbCreateTime]
            
            // String, Int, Float, [Any], [String: Any], nil
            if table[dbType] == "String" {
                dbItem.itemObject = table[dbObject]
            } else if table[dbType] == "Int" {
                let stringValue: String = table[dbObject]
                dbItem.itemObject = Int.init(stringValue)
            } else if table[dbType] == "Float" {
                let stringValue: String = table[dbObject]
                dbItem.itemObject = Float.init(stringValue)
            } else {
                let stringValue: String = table[dbObject]
                let jsonData: Data = stringValue.data(using: .utf8)!
                let resultObj: Any = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                dbItem.itemObject = resultObj
            }
            result?.append(dbItem)
        }
        if result?.count != 0 {
            return result
        }
        return nil
    }
    
    // MARK: - UPDATE
    // 根据id修改
    func update(byId updateId: Int, withObject object: Any, fromTable tableName: String) {
        
        createTable(tableName: tableName)
        
        let updateIdInt64 = Int64.init(updateId)
    
        let result: [String: String] = exchangeObjToStandardType(object: object)
        let resultObj: String = result["obj"]!
        let resultType: String = result["type"]!
        
        // 优化点：id不存在的时候应当不再进行update
        let update = tableHandler?.filter(dbId == updateIdInt64)
        try! db?.run((update?.update(dbObject <- resultObj, dbType <- resultType, dbCreateTime <- dateNowAsString()))!)
    }
    
    // MARK: - DELETE
    func delete(byId deleteId: Int, fromTable tableName: String) {
        
        createTable(tableName: tableName)
        
        // 优化点：id不存在的时候应当不再进行delete
        let deleteIdInt64 = Int64.init(deleteId)
        try! db?.run((tableHandler?.filter(dbId == deleteIdInt64).delete())!)
    }
    
    func delete(byType deleteType: String, fromTable tableName: String) {
        
        createTable(tableName: tableName)
        try! db?.run((tableHandler?.filter(dbType == deleteType).delete())!)
    }
    // 删除整张表
    func drop(dropTable tableName: String) {
        
        createTable(tableName: tableName)
        try! db?.run((tableHandler?.drop(ifExists: true))!)
    }
    
    // MARK: - Tool Func
    // 检查tableName是否不合法
    func checkTableName(tableName: String) -> Bool {
        if (tableName.contains(" ")) || tableName.characters.count == 0 {
            print("table name: \(tableName) format error")
            return false
        }
        return true
    }
    // date转string
    func dateNowAsString() -> String {
        let nowDate = Date()
        let timeInterval = nowDate.timeIntervalSince1970 * 1000
        let timeString: String = String(timeInterval)
        return timeString
    }
    // 获取存储类型
    func exchangeObjToStandardType(object: Any) -> [String: String] {
        
        var resultObj: String?
        var resultType: String?
        
        if object is String {
            // string类型
            resultObj = object as? String
            resultType = "String"
        } else if object is Int || object is Int64 {
            // int类型
            resultObj = String.init(format: "%d", object as! CVarArg)
            resultType = "Int"
        } else if object is Double || object is Float {
            // float类型
            resultObj = String.init(format: "%lf", object as! CVarArg)
            resultType = "Float"
        } else {
            
            var insertObj: Any?
            var insertType: String?
            
            if let array = object as? [Any] {
                // array类型
                insertObj = array
                insertType = "[Any]"
            } else if let dictionary = object as? [String: Any] {
                // dictionary类型
                insertObj = dictionary
                insertType = "[String: Any]"
            } else {
                // nil类型
                insertObj = nil
                insertType = "nil"
            }
            
            let jsonData: Data = try! JSONSerialization.data(withJSONObject: insertObj!, options: .init(rawValue: 0))
            let json: String = String.init(data: jsonData, encoding: .utf8)!
            
            resultObj = json
            resultType = insertType
        }
        
        return ["obj": resultObj!, "type": resultType!]
    }
}






















