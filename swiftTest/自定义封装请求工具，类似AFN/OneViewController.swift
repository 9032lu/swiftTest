//
//  OneViewController.swift
//  swiftTest
//
//  Created by ZhangTu on 2018/11/30.
//  Copyright © 2018年 Test. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON

class LZDModel :HandyJSON{
   
    
    var tokenStatus: String?
    var msg: String?
    
   required init() {}
    
}

class OneViewController: UIViewController {
    var redView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "oneVC";
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: UIBarButtonItem.Style.plain, target: self, action: #selector(lzdgotoForword));

        
        let redView = UIView.init()
        redView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        self.view.addSubview(redView)
        self.redView = redView;
        
        redView.backgroundColor = UIColor.red
        
//        redView.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        redView.transform = CGAffineTransform.init(rotationAngle: 45)
        
//        UIViewAnimation1()
        requestData()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(requestData))
        
        self.redView.addGestureRecognizer(tap)
    }

    func UIViewAnimation1(){
        
        UIView.animateKeyframes(withDuration: 1, delay: 0.5, options: [.repeat,.autoreverse], animations: {
            
            self.redView.transform = CGAffineTransform(translationX: 0, y: -300)
            self.redView.transform = CGAffineTransform(rotationAngle: CGFloat(360))
            self.redView.backgroundColor = UIColor.green
            
        }) { (complete) in
            
        }
        
    }
  @objc  func lzdgotoForword() {
        
        self.navigationController?.popViewController(animated: true)
    }

    
    
  @objc  func requestData() {
    
        LZDNetWorkTool.tool.verifyUserToken { (result) in
            
            let lzdModel = LZDModel.deserialize(from: result.data!)
            
            
//            let data_dic = result.data! as [String:Any];
            print(result.data!["msg"]!,lzdModel?.msg ?? "as")

//            let lzdModel = LZDModel (with: result.data!)
//
            SVProgressHUD.showInfo(withStatus: lzdModel?.msg);

            
       
            
            print(result.data!)
            
        }
        


      
        
        
        
    }
   

}
