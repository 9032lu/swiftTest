//
//  LZDItem.swift
//  swiftTest
//
//  Created by ZhangTu on 2018/12/5.
//  Copyright © 2018年 Test. All rights reserved.
//

import Foundation
import HandyJSON



class Top_storiesItem    : HandyJSON {
    var id: Int = 0
    var title: String!
    var type: Int = 0
    var ga_prefix: String!
    var multipic: String?

    var image: String!
    
    required init(){}
}

class StoriesItem    : HandyJSON {
    var id: Int = 0
    var title: String!
    var ga_prefix: String!
    var images: String!
    var type: Int = 0
    
    required init(){}

}

class LZDItemModel    : HandyJSON {
    var top_stories: [Top_storiesItem]!
    var stories: [StoriesItem]!
    var date: String!
    
    required init() {}
}


class LZDUserLoginModel: HandyJSON {
    var libraryName: String!
    var nickName: String!
    var bingStatus: Int = 0
    var libraryId: Int = 0
    var userCover: String!
    var userId: Int = 0
    var token: String!
    
    required init(){}
}

