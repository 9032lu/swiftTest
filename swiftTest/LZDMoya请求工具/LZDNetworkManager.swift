//
//  LZDNetworkManager.swift
//  swiftTest
//
//  Created by ZhangTu on 2018/12/5.
//  Copyright © 2018年 Test. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON

/// 请求时长
private var requestTimeOut:Double = 30
///成功数据的回调
typealias successCallback = ((String) -> (Void))
///失败的回调
typealias failedCallback = ((String) -> (Void))
///网络错误的回调
typealias errorCallback = (() -> (Void))



///网络请求的基本设置,这里可以拿到是具体的哪个网络请求，可以在这里做一些设置

private let myEndpointClosure = {(target:LZDAPI) ->Endpoint in
    ///这里把endpoint重新构造一遍主要为了解决网络请求地址里面含有? 时无法解析的bug https://github.com/Moya/Moya/issues/1198
    let url = target.baseURL.absoluteString+target.path
    
    /*
     如果需要在每个请求中都添加类似token参数的参数请取消注释下面代码
     👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇
     */
    //    let additionalParameters = ["token":"888888"]
    //    let defaultEncoding = URLEncoding.default
    //    switch target.task {
    //        ///在你需要添加的请求方式中做修改就行，不用的case 可以删掉。。
    //    case .requestPlain:
    //        task = .requestParameters(parameters: additionalParameters, encoding: defaultEncoding)
    //    case .requestParameters(var parameters, let encoding):
    //        additionalParameters.forEach { parameters[$0.key] = $0.value }
    //        task = .requestParameters(parameters: parameters, encoding: encoding)
    //    default:
    //        break
    //    }
    /*
     👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆
     如果需要在每个请求中都添加类似token参数的参数请取消注释上面代码
     */
    
    var endpoint = Endpoint.init(url: url,
                                 sampleResponseClosure: {.networkResponse(200, target.sampleData)},
                                 method: target.method,
                                 task: target.task,
                                 httpHeaderFields: target.headers)
    
    
    requestTimeOut = 30//每次请求都会调用endpointClosure 到这里设置超时时长 也可单独每个接口设置
    
//    switch target {
//    case .easyRequese:
//        return endpoint
//      case .register:
//        requestTimeOut = 5
//        return endpoint
//    default:
        return endpoint

//    }
  
    
}


private let requestClosure = {(endpoint:Endpoint,done:MoyaProvider.RequestResultClosure) in
    
    do{
        var request = try endpoint.urlRequest()
        //设置请求时长
        request.timeoutInterval = requestTimeOut
        //打印请求参数
        if let requestData = request.httpBody{
            print("\(request.url!)"+"\n"+"\(request.httpMethod ?? "")"+"发送参数"+"\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
        }else{
            print("\(request.url!)"+"\(String(describing: request.httpMethod))")
        }
        done(.success(request))

    }catch {
        done(.failure(MoyaError.underlying(error, nil)))

    }
    
}

/*   设置ssl
 let policies: [String: ServerTrustPolicy] = [
 "example.com": .pinPublicKeys(
 publicKeys: ServerTrustPolicy.publicKeysInBundle(),
 validateCertificateChain: true,
 validateHost: true
 )
 ]
 */

// 用Moya默认的Manager还是Alamofire的Manager看实际需求。HTTPS就要手动实现Manager了
//private public func defaultAlamofireManager() -> Manager {
//
//    let configuration = URLSessionConfiguration.default
//
//    configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
//
//    let policies: [String: ServerTrustPolicy] = [
//        "ap.grtstar.cn": .disableEvaluation
//    ]
//    let manager = Alamofire.SessionManager(configuration: configuration,serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
//
//    manager.startRequestsImmediately = false
//
//    return manager
//}


/// NetworkActivityPlugin插件用来监听网络请求，界面上做相应的展示
///但这里我没怎么用这个。。。 loading的逻辑直接放在网络处理里面了

private let netWorkPlugin = NetworkActivityPlugin.init { (changeType, targetType) in
    print("networkPlugin \(changeType)")
    //targetType 是当前请求的基本信息
    switch (changeType) {
    case .began:
        print("开始请求网络")
        SVProgressHUD.show();

    case .ended:
        SVProgressHUD.dismiss()
        print("结束")
    }
  
}

// https://github.com/Moya/Moya/blob/master/docs/Providers.md  参数使用说明
//stubClosure   用来延时发送网络请求

////网络请求发送的核心初始化方法，创建网络请求对象
let Provider = MoyaProvider.init(endpointClosure: myEndpointClosure, requestClosure: requestClosure, plugins: [netWorkPlugin], trackInflights: false)

/// 最常用的网络请求，只需知道正确的结果无需其他操作时候用这个
///
/// - Parameters:
///   - target: 网络请求
///   - completion: 请求成功的回调
func LZDNetWorkRequest( target: LZDAPI, completion: @escaping successCallback ) {
    
    LZDNetWorkRequest(target, cache: false, cacheHandle: nil, completion: completion, failed: nil, errorResult: nil)
}

/// 需要知道成功或者失败的网络请求， 要知道code码为其他情况时候用这个
///
/// - Parameters:
///   - target: 网络请求
///   - completion: 成功的回调
///   - failed: 请求失败的回调
func LZDNetWorkRequest(_ target: LZDAPI, completion: @escaping successCallback , failed:failedCallback?) {
    LZDNetWorkRequest(target, cache: false, cacheHandle: nil, completion: completion, failed: failed, errorResult: nil)

}

/// 使用moya的请求封装
///
/// - Parameters:
///   - API: 要使用的moya请求枚举（TargetType）
///   - target: TargetType里的枚举值
///   -cache: 是否缓存
///   -cacheHandle: 需要单独处理缓存的数据时使用，（默认为空，使用success处理缓存数据）
///   - success: 成功的回调
///   - error: 连接服务器成功但是数据获取失败
///   - failure: 连接服务器失败

func LZDNetWorkRequest(_ target: LZDAPI,cache: Bool = false, cacheHandle :((String)->Void)? = nil, completion: @escaping successCallback , failed:failedCallback?, errorResult:errorCallback?){
    

    if  cache,let data = LZDSaveFiles.read(path: target.path) {
        //cacheHandle不为nil则使用cacheHandle处理缓存，否则使用success处理

        if let block = cacheHandle{
            
            
            block(String(data: data, encoding: String.Encoding.utf8)!)
        }else{
            
            completion(String(data: data, encoding: String.Encoding.utf8)!)
        }
        
    }else{
        
    }
    
    
    //先判断网络是否有链接 没有的话直接返回--代码略
        if !isNetworkConnect {
        print("提示用户网络似乎出现了问题")

        return
    }
    
    
    //这里显示loading图
    
    Provider.request(target) { (result) in
        //隐藏hud
        switch result{
        case let .success(response):
            do{
                let jsonData = try JSON(data: response.data)
                print(jsonData)
                //               这里的completion和failed判断条件依据不同项目来做，为演示demo我把判断条件注释了，直接返回completion。
                
                completion(String(data: response.data, encoding: String.Encoding.utf8)!)
                
//                print("flag不为1000 HUD显示后台返回message"+"\(jsonData[RESULT_MESSAGE].stringValue)")
                
//                    if jsonData[RESULT_CODE].stringValue == "1"{
//                        completion(String(data: response.data, encoding: String.Encoding.utf8)!)
//                    }else{
//
//                    if failed != nil{
//                        failed?(String(data: response.data, encoding: String.Encoding.utf8)!)
//                        }
//                    }
                
            } catch {
                
                print("数据解析失败\(response)")
            }
        case let .failure(error):
            guard let error = error as? CustomStringConvertible else {
                //网络连接失败，提示用户
                print("网络连接失败")
                break
            }
            if errorResult != nil {
                errorResult!()
            }
        }
   
        
    }
    
}

/// 基于Alamofire,网络是否连接，，这个方法不建议放到这个类中,可以放在全局的工具类中判断网络链接情况
/// 用get方法是因为这样才会在获取isNetworkConnect时实时判断网络链接请求，如有更好的方法可以fork
var isNetworkConnect: Bool {
    get{
        let network = NetworkReachabilityManager()
        return network?.isReachable ?? true //无返回就默认网络已连接
    }
}


/// Demo中并未使用，以后如果有数组转json可以用这个。
struct JSONArrayEncoding: ParameterEncoding {
    static let `default` = JSONArrayEncoding()
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        
        guard let json = parameters?["jsonArray"] else {
            return request
        }
        
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        request.httpBody = data
        
        return request
    }
}
