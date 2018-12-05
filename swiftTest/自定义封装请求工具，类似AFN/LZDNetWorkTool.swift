//
//  LZDNetWorkTool.swift
//  swiftTest
//
//  Created by ZhangTu on 2018/12/3.
//  Copyright © 2018年 Test. All rights reserved.
//

import UIKit
import SwiftyJSON

class LZDNetWorkTool: NSObject {

    static let tool = LZDNetWorkTool()
    
    struct result {
        var success:Bool = false
        var msg : String?
        var data : [String:Any]?
        var code : String?
        
    }
    
    
    var localPara:[String:Any]? =  ["libraryId":"2","userId":"2356","token":"239e4d7ba1bfe07ae2364fd834058cdd","page":"1","cardNumber":"wangfeng","keyword":"傅玉璋","batchId":"2"]

    
    func handleResponse(JSON json:JSON) -> result {
        
        if LZDUtil.isBlankString(String: json["msg"].string) != "" {
            SVProgressHUD .showInfo(withStatus: json["msg"].string)

        }
        return result(success: true, msg: json["msg"].string, data: json["data"].dictionary, code: json["code"].string)
       
        
    }
    
    
    
    func verifyUserToken(_ comp:@escaping (result)->Void)  {
        
        LZDNetWork.requestWith(Method: .post, URL: HOST+verifyUserToken_Api, Paramer: localPara) { (res) in
            do{
                let json = try JSON(data: res.data!)
                if JSON.null != json {
                    
                    let aResult = self.handleResponse(JSON: json)
                    comp(aResult)
                    
                }

                
            }catch{
                
            }
            
            
        }
        
    }
    
    
}
