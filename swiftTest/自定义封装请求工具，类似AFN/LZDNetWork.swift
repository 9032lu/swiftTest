//
//  LZDNetWork.swift
//  swiftTest
//
//  Created by ZhangTu on 2018/12/3.
//  Copyright © 2018年 Test. All rights reserved.
//

import UIKit
import Alamofire

class LZDNetWork: NSObject {

    struct responseData {
        var request:URLRequest?
        var response:HTTPURLResponse?
        var json:AnyObject?
        var error:NSError?
        var data:Data?
        
    }
    
    class  func requestWith(Method method:Alamofire.HTTPMethod, URL url:String,Paramer paramer:[String:Any]?,handler: @escaping (responseData)-> Void)   {
        
        let reachAble = LZDNetworkReachability.reachAbility.reachAble
        
        if reachAble {
            
            let manager = Alamofire.SessionManager.default;
            manager.session.configuration.timeoutIntervalForRequest = 10
            
                SVProgressHUD.show()
                manager.request(url, method: method, parameters: paramer, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {(response)in
                SVProgressHUD.dismiss()
                    if (response.result.error != nil){
                        print("erro:\(response.result.error ?? "请求出错！" as! Error)")
                        
                    }else{
                        
                        let json:AnyObject! = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as AnyObject
                        if nil != json {
                            
                            let  res = responseData(request: response.request, response: response.response, json: json, error: response.error as NSError?, data: response.data)
                            
                            handler(res)
                        }
                    }
                    
               
                
                
                
            })
            
            
            
            
        }
    }
    
    
}
