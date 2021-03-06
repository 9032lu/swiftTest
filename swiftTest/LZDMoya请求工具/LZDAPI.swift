//
//  LZDAPI.swift
//  swiftTest
//
//  Created by ZhangTu on 2018/12/5.
//  Copyright © 2018年 Test. All rights reserved.
//

import Foundation
import Moya

enum LZDAPI {
    
// MARK: - 用户登录
    case User_loginByPhone(paramer:[String:Any])
    //用户上传头像
    case uploadHeaderImage(paramer:[String:Any],imageData:Data)
    
    
    
}

extension LZDAPI:TargetType{
    var baseURL: URL {
      
       return URL.init(string: (Moya_baseURL))!
    }
    
    var path: String {
        switch self {
 
        case .User_loginByPhone:
            return "hongYan/user/loginByPhone.html"
        case .uploadHeaderImage(_):
            return "/file/user/upload.jhtml"
            
        
        }
    }
    
    var method: Moya.Method {
//        switch self {
//        case .easyRequese:
//            return .get
//        default:
            return .post

//        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        var params: [String: Any] = [:]

        switch self {
    
            
        case let .User_loginByPhone(paramer):
            params = paramer
            
        case .uploadHeaderImage(let paramer, let imageData):
            ///name 和fileName 看后台怎么说，   mineType根据文件类型上百度查对应的mineType

            let formData = MultipartFormData.init(provider: .data(imageData), name: "file", fileName: "hangge.png", mimeType: "image/png")
            
            return .uploadCompositeMultipart([formData], urlParameters: paramer)
            
        }
        
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return ["Content-Type":"application/x-www-form-urlencoded"]

    }
    
    
}
