# SwiftLocationManager
swift locationManager

使用方法

      获取城市和经纬度
       SwiftLocationManager.sharedInstance.getUserLocationInfo({ (location) in
        
        print(location?.coordinate.latitude)
        print(location?.coordinate.longitude)
        
        }) { (city) in
         print(city)
        }
        
      获取经纬度
        SwiftLocationManager.sharedInstance.getUserCCLocation { (location) in
            print(location?.coordinate.latitude)
            print(location?.coordinate.longitude)
        }
        
      判读是否开启定位服务
        if SwiftLocationManager.status == LocationServiceStatus.Disabled {
            print("请到设置里隐身开启定位服务")
        }
