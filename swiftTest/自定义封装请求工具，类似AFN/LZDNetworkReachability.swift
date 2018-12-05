//
//  LZDNetworkReachability.swift
//  swiftTest
//
//  Created by ZhangTu on 2018/12/3.
//  Copyright © 2018年 Test. All rights reserved.
//

import UIKit
import Alamofire

class LZDNetworkReachability: NSObject {

    static let reachAbility = LZDNetworkReachability()
    
    var reachAble:Bool = {
        
        var reach = true
        let manager = NetworkReachabilityManager(host: "www.baidu.com")
        manager?.listener = { status in
            switch status{
                
            case .unknown:
                reach = false
            case .notReachable:
                reach = false
            case .reachable(.wwan):
                reach = true
                
            print("wwan")
            case .reachable(.ethernetOrWiFi):
                reach = true
                print("ethernetOrWiFi")

            }
            
        }
        manager?.startListening()
        
     return reach
    }()
    
    
}
