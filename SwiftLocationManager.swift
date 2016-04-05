//
//  SwiftLocationManager.swift
//  SwiftLocationManager
//
//  Created by lengshengren on 16/4/4.
//  Copyright © 2016年 Rnning. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
public enum LocationServiceStatus :Int {
    case Available
    case Undetermined
    case Denied
    case Restricted
    case Disabled
}

public typealias userCLLocation = ( (location: CLLocation?) -> Void)
public typealias cityString = ( (city: String? ) -> Void)
private let DistanceAndSpeedCalculationInterval = 5.0;
private let SwiftLocationManagerSharedInstance = SwiftLocationManager()

public class SwiftLocationManager: NSObject,CLLocationManagerDelegate{
    //创建一个单例
    public class var sharedInstance:SwiftLocationManager{
       return SwiftLocationManagerSharedInstance
    }
    public var userLocation: CLLocation?
    
    //定义闭包变量
    private var onUserCLLocation: userCLLocation?
    private var onCityString:cityString?
    //上一次定位时间
    public var LastDistanceAndSpeedCalculation:Double = 0
    //获取定位状态
    class var status:LocationServiceStatus {
        if !CLLocationManager.locationServicesEnabled(){
            return .Disabled //请到设置里开启定位服务
        }else{
            switch CLLocationManager.authorizationStatus(){
            case .NotDetermined:
                return .Undetermined //用户还没有做选择
            case .Denied:
                 return .Denied      //用户拒绝授权
            case .Restricted:
                 return .Restricted  //应用拒接使用定位服务
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                return .Available  //始终授权位置服务 和当使用App时候授权位置服务
            }
            
        }
    }
    
    
    //创建一个 CLLocationManager 对象
    private var locationManager:CLLocationManager!
    
    //初始化 CLLocationManager
    override private init() {
        super.init()
        locationManager = CLLocationManager()
        
        //精度最高
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //距离改变1000 米后再次定位
        locationManager.distanceFilter = 1000
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.delegate = self
        startLocation()
    }
    
    //开始定位
    public func startLocation()  {
        locationManager.startUpdatingLocation()
      }
    
    //停止定位
    public func stopLocation()  {
        locationManager.stopUpdatingLocation()
    }
    
    //MARK:- locationManager Delegate
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("定位发生异常:\(NSError.description())")
    }
    
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count > 0 else{
            return
        }
   
        //过滤连续定位问题
        if LastDistanceAndSpeedCalculation > 0 {
            guard NSDate .timeIntervalSinceReferenceDate() - LastDistanceAndSpeedCalculation  > DistanceAndSpeedCalculationInterval else{
                
                return;
            }
        }

        LastDistanceAndSpeedCalculation = NSDate .timeIntervalSinceReferenceDate()
      let location = CLLocation(latitude: locations.last!.coordinate.latitude, longitude: locations.last!.coordinate.longitude)
        print(location.coordinate.latitude)
        print(location.coordinate.longitude)
        userLocation = location
        onUserCLLocation!(location:userLocation)
        reverseGeocode(location)
    }
    
    
    func reverseGeocode(currLocation: CLLocation!) {
      
        let geocoder = CLGeocoder()
        var placemark:CLPlacemark?
        geocoder.reverseGeocodeLocation(currLocation, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
                return
            }
            let pm = placemarks! as [CLPlacemark]
            if (pm.count > 0){
                placemark = placemarks![0]
                let city:String = placemark!.locality! as String
                self.onCityString!(city: city)
                print(city)
                self.stopLocation()
            }else{
                print("No Placemarks!")
            }
        })
    }
    
    //获取经纬度和城市
    func getUserLocationInfo(cllocation:userCLLocation,city:cityString) -> Void {
        startLocation()
        onUserCLLocation = cllocation;
        onCityString = city;
    }
    
    //获取经纬度
    func getUserCCLocation(cllocation:userCLLocation) -> Void {
        startLocation()
        onUserCLLocation = cllocation;
    }
   

}



