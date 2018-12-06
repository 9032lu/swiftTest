//
//  LZDSaveFiles.swift
//  swiftTest
//
//  Created by ZhangTu on 2018/12/6.
//  Copyright © 2018年 Test. All rights reserved.
//

import Foundation

class LZDSaveFiles {

    class func save(path: String,data: Data) {
        let pathUrl = handlePathUrl(path)
        //拿到本地文件url
        let manager = FileManager.default
        var url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        url?.appendPathComponent("cache/")
        
        if let urlStr = url?.absoluteString,manager.isExecutableFile(atPath: urlStr) == false{
            try? manager.createDirectory(at: url!, withIntermediateDirectories: true, attributes: nil)
            
        }
        
        url?.appendPathComponent(pathUrl)
        
        do {
            
            try data.write(to: url!)
            
            print("保存到本地\(pathUrl)")
            
        }catch{
            print("保存到本地文件失败")
        }
 
    }
    
    class func read(path:String) -> Data? {
        
        let pathUrl = handlePathUrl(path)
        let mannager = FileManager.default
        var url = mannager.urls(for: .documentDirectory, in: .userDomainMask).first
        url?.appendPathComponent(pathUrl)
        if let dataRead = try? Data(contentsOf: url!) {
            print("读取本地文件成功")
            return dataRead
        }else{
            print("文件不存在，读取本地文件失败")

        }
  
        return nil
    }
    
   class func handlePathUrl(_ url:String) -> String {
        return url.replacingOccurrences(of: "/", with: "")
    }
    
    
}
