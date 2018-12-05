//
//  MainViewController.swift
//  swiftTest
//
//  Created by ZhangTu on 2018/11/30.
//  Copyright © 2018年 Test. All rights reserved.
//

import UIKit
import Moya

class MainViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    var topView : UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "首页";
        print("asda","我的")
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 186/255, blue: 89/255, alpha: 1)
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 30)];
        topView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        topView.backgroundColor = UIColor.red
        topView.isUserInteractionEnabled = true
        view.addSubview(topView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToOneVC))
        topView.addGestureRecognizer(tap)
        
        
        
        
       
            tableView.tableFooterView = UIView(frame: CGRect.zero)


        testZhiHuDailyAPI()///演示moya+handyJSON的使用，个人感觉handyJSON转模型比swifterJSON方便很多




    }

    @objc func goToOneVC() {
        
        let oneVC = OneViewController();
        
        
        navigationController?.pushViewController(oneVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID");
        if (cell == nil) {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cellID")
            
        }
        
        cell?.textLabel?.text = NSString.localizedStringWithFormat("%d", indexPath.row) as String;
        return cell!;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func testZhiHuDailyAPI()  {
    
        LZDNetWorkRequest(target: .easyRequese) { (responseString) -> (Void) in
            
            if let dailyItem = [LZDItem].deserialize(from: responseString, designatedPath: "stories"){
                dailyItem.forEach({ (item) in
                    print("模型属性--\(item?.title ?? "模型无title")" )

                })
                
                
            }
        }
    }
  
    @IBAction func testApiClick(_ sender: UIButton) {
        testApi()
        
    }
    @IBAction func uploadImgClick(_ sender: Any) {
        uploadImage()
    }
    
    @IBAction func needFailerClick(_ sender: Any) {
        needsFailedAndErrorCondition()
        
    }
    
    func testApi() {
        
        var paraDict:[String:Any] = Dictionary()
        paraDict["app_type_"] = "1"
        paraDict["app_version_no_"] = "1.0.1"
        paraDict["platform_type_"] = "2"
        paraDict["ver_code_value_"] = nil

        
        LZDNetWorkRequest(target: .updataApi(paramer: paraDict)) { (responseString) -> (Void) in
            //后台flag为1000是后台的result code
            print(responseString)
        }
    }
    
    
    /// muti-form 多表单文件上传，这里使用的是png图片上传--接口地址是我瞎写的， 你按照实际后台地址写就行
    func uploadImage() {
        var para = [String:Any]() //参数按照后台约定就成
        para["token"] = "token"
        para["juid"] = "id"
        para["file_type_"] = "head"
        
        let image = UIImage(named: "image")
        
        let imageData = UIImage.jpegData(image!)(compressionQuality: 0.3) //把图片转换成data
        LZDNetWorkRequest(target: .uploadHeaderImage(paramer: para, imageData: imageData!)) { (resultString) -> (Void) in
            ///处理后台返回的json字符串
            print("uploadHeaderImage\(resultString)")
        }
        
     
    }

    
    /// 需要获取到网络请求失败，错误数据的情况
    func needsFailedAndErrorCondition() {
        var paraDict: [String:Any] = Dictionary()
        paraDict["app_type_"] = "1"
        paraDict["app_version_no_"] = "1.0.1"
        paraDict["platform_type_"] = "2"
        paraDict["ver_code_value_"] = nil
        
        LZDNetWorkRequest(.updataApi(paramer: paraDict), completion: { (resultString) -> (Void) in
            print("网络成功的数据")

        }, failed: { (str) -> (Void) in
            print("网络请求失败的数据(resultCode不为正确时)")
            /*
             也可以把成功和失败写在一个闭包里，获取后统一处理，但大多请求下只需要处理成功的数据，用上面第一个方法就行,数据处理已经在基本方法中处理好了。这种情况用的地方不多。可以根据自己的实际需求改写这个框架
             */
            
        }) { () -> (Void) in
            print("网络错误了")

        }
        
    }
    
}
