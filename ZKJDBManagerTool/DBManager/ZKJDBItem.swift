//
//  ZKJDBItem.swift
//  SwiftDemo
//
//  Created by zkj on 2017/5/4.
//  Copyright © 2017年 zkj. All rights reserved.
//

import UIKit

class ZKJDBItem: NSObject {
    
    var itemId: Int?
    var itemObject: Any?
    var itemType: String?
    var itemCreateTime: String?

    open func itemDescription() {
        print("itemDescription:{\n\titemId: \(itemId ?? -1)\n\titemObject: \(itemObject ?? "nil value")\n\titemType: \(itemType ?? "nil type")\n\titemCreateTime: \(itemCreateTime ?? "-1")\n}\n")
    }
}
