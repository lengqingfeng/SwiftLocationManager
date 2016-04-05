//
//  ViewController.swift
//  SwiftLocationManager
//
//  Created by lengshengren on 16/4/4.
//  Copyright © 2016年 Rnning. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       SwiftLocationManager.sharedInstance.getUserLocationInfo({ (location) in
        
        print(location?.coordinate.latitude)
        print(location?.coordinate.longitude)
        
        }) { (city) in
        print(city)
        }
        
        if SwiftLocationManager.status == LocationServiceStatus.Disabled {
            print("请到设置里隐身开启定位服务")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

