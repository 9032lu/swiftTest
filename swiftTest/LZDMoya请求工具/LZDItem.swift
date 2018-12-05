//
//  LZDItem.swift
//  swiftTest
//
//  Created by ZhangTu on 2018/12/5.
//  Copyright © 2018年 Test. All rights reserved.
//

import Foundation
import HandyJSON

class LZDItem: HandyJSON {
    var title:  String?
    var ga_prefix: String?
    var images: String?
    var multipic: String?
    var type: Int?
    var id: Int?
    
    //用HandyJSON必须要实现这个方法
    required init(){}
}
