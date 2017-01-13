//
//  OpenWeatherMap.swift
//  Weather2
//
//  Created by dima on 09/01/2017.
//  Copyright © 2017 dima. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

protocol OpenWeatherMapDelegate {
    func updateWeatherInfo(weatherJson: JSON)
    func failure()
}


class OpenWeatherMap {
    
    let weatherUrl = "http://api.openweathermap.org/data/2.5/weather"
    
    //let weatherUrl = "http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=2ea1fff5de0959c6314dcdae7c279d18"
    
    var nameCity: String?
    var temp: Int?
    //var description: String
    //var currentTime: String?
    //var icon: UIImage?
    
    var delegate: OpenWeatherMapDelegate!
    
    /*
    func getWeatherFor(_ city: String) {
        
        let params = ["q":city]
        
        request(weatherUrl, method: .get, parameters: params).responseJSON{ respouns in
            switch respouns.result {
            case .failure(let error): print(error)
            case .success:
                //let weatherJson = JSON(respouns.result.value)
                let weatherJson = JSON(respouns.result.value)
                if let name = weatherJson["name"].string{
                    self.nameCity = name
                }
                DispatchQueue.main.async {
                    self.delegate.updateWeatherInfo()
                }
            default:print("")
            }
        }
    }
    */
    
    
    
    
    //Work
    
    
    func weatherFor(geo: CLLocationCoordinate2D) {
        //http://api.openweathermap.org/data/2.5/forecast/daily?lat=35&lon=139&cnt=10&mode=json&appid=b1b15e88fa797225412429c1c50c122a1
        let params = ["lat" : geo.latitude,"lon" : geo.longitude]
        
    }
    
    func getWeatherFor(_ city: inout String) {
        
        setRequest(city: &city)
        
        
        /*
        Alamofire.request("https://httpbin.org/get").responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
            /*
            let res = response.result.value
            let res2 = JSON(res)
            if let name = res2["name"].string {
                self.nameCity = name
            }
            
            DispatchQueue.main.async(execute: {
                self.delegate.updateWeatherInfo()
            })
        }
 */
    */

}
    
    
    func setRequest(city: inout String){
        city = city.capitalized
        let gorod = self.weatherUrl + "?q=" + city + "&appid=2ea1fff5de0959c6314dcdae7c279d18"
        
        Alamofire.request(gorod).responseJSON { (response) in
            if let json = response.result.value{
                let weatherJSON = JSON(json)

                /*
                print(json)
                print("=================================")
                let weatherJSON = JSON(json)
                print(weatherJSON)
                print("=================================")
                */
                
                
                if let name = weatherJSON["name"].string {
                    self.nameCity = name
                }
                
                if let temperatura = weatherJSON["main"]["temp"].double {
                    self.temp = Int(temperatura - 273.15)
                }
                
                DispatchQueue.main.async(execute: {
                    self.delegate.updateWeatherInfo(weatherJson: weatherJSON)
                })
            } else {
                self.delegate.failure()
            }
    }
}
    
    //==============================================
        
        /*
        request(gorod, method: .get, parameters: params).responseJSON{ (response) in
            //proverka
            if let json = response.result.value{
                
                let weatherJSON = JSON(json)
                
                if let name = weatherJSON["name"].string {
                    self.nameCity = name
                }
                
            DispatchQueue.main.async(execute: {
                self.delegate.updateWeatherInfo()
            })
                
            } else {
                print("Error")
            }
        }
 */
        
    
    
    /*
     init(weatherJson:NSDictionary){
     //name temp
     nameCity = weatherJson["name"] as! String
     let main = weatherJson["main"] as! NSDictionary
     temp = main["temp"] as! Int
     
     //description
     let weather = weatherJson["weather"] as! NSArray
     let zero = weather[0] as! NSDictionary
     description = zero["description"] as! String
     
     //currentTime
     let dt = weatherJson["dt"] as! Int
     currentTime = timeFromUnix(dt)
     
     //icon
     let strIcon = zero["icon"] as! String
     icon = weatherIcon(strIcon)
     
     }
     */
    func updateWeatherIcon(condition: Int, nightTime: Bool) ->UIImage{
        var imageName: String
        switch (condition,nightTime) {
                //Thunderstorm
            case let(x,y) where x < 300 && y == true: imageName = "11n"
            case let(x,y) where x < 300 && y == false: imageName = "11d"
                //Drizle
            case let(x,y) where x < 500 && y == true: imageName = "09n"
            case let(x,y) where x < 500 && y == false: imageName = "09n"
                //Rain
            case let(x,y) where x <= 504 && y == true: imageName = "10n"
            case let(x,y) where x <= 504 && y == false: imageName = "10d"
            
            case let(x,y) where x == 511 && y == true: imageName = "13n"
            case let(x,y) where x == 511 && y == false: imageName = "13d"
            
            case let(x,y) where x < 600 && y == true: imageName = "09n"
            case let(x,y) where x < 600 && y == false: imageName = "09d"
            
            //Snow
            case let(x,y) where x < 700 && y == true: imageName = "13n"
            case let(x,y) where x < 700 && y == false: imageName = "13n"
            
            //Atmosphere
            case let(x,y) where x < 800 && y == true: imageName = "50n"
            case let(x,y) where x < 800 && y == false: imageName = "50d"
            
            //Clouds
            case let(x,y) where x == 800 && y == true: imageName = "01n"
            case let(x,y) where x == 800 && y == false: imageName = "01d"
            
            case let(x,y) where x == 801 && y == true: imageName = "02n"
            case let(x,y) where x == 801 && y == false: imageName = "02d"
            
            case let(x,y) where x > 802 && x < 804 && y == true: imageName = "03n"
            case let(x,y) where x > 800 && x < 804 && y == true: imageName = "03d"
            
            case let(x,y) where x == 804 && y == true: imageName = "04n"
            case let(x,y) where x == 804 && y == false: imageName = "04d"
            
            //Additional
            case let(x,y) where x < 1000 && y == true: imageName = "11n"
            case let(x,y) where x < 1000 && y == false: imageName = "11d"
        
        case let(x,y): imageName = "none"
        
        default: imageName = "none"
        }
        
        let iconImage = UIImage(named: imageName)
        return iconImage!
    }
    
    /*
    func weatherIcon(_ stringIcon: String) -> UIImage {
        
        let imageName: String
        
        switch stringIcon {
        case "01d": imageName = "01d"
        case "02d": imageName = "02d"
        case "03d": imageName = "03d"
        case "04d": imageName = "04d.png"
        case "09d": imageName = "09d"
        case "10d": imageName = "10d"
        case "11d": imageName = "11d"
        case "13d": imageName = "13d"
        case "50d": imageName = "50d"
        case "01n": imageName = "01n"
        case "02n": imageName = "02n"
        case "03n": imageName = "03n"
        case "04n": imageName = "04n"
        case "09n": imageName = "09n"
        case "10n": imageName = "10n"
        case "11n": imageName = "11n"
        case "13n": imageName = "13n"
        case "50n": imageName = "50n"
        default: imageName = "none"
        }
        
        let iconImage = UIImage(named: imageName)
        return iconImage!
    }
 */
 
    func isTimeNight(weatherJson: JSON) -> Bool {
        var nigthTime = false
        let nowTime = NSDate().timeIntervalSince1970
        let sunrise = weatherJson["sys"]["sunrise"].doubleValue
        let sunset = weatherJson["sys"]["sunset"].doubleValue
        
        //?????????????????????
        
        if nowTime < sunrise || nowTime > sunset {
            nigthTime = true
        }
        return nigthTime
}
    func timeFromUnix(_ unixTime:Int) -> String {
        let timeInSecond = TimeInterval(unixTime)
        let weatherDate = Date(timeIntervalSince1970: timeInSecond)
        
        let dateFormator = DateFormatter()
        dateFormator.dateFormat = "HH:mm"
        
        return dateFormator.string(from: weatherDate)
    }
    
    
    func convertTempe(country:String, temperatura: Double) -> Int {
        
        if country == "US"{
            return Int(((temperatura - 273.15)*1.8) + 32.0)
        } else {
            return Int(temperatura - 273.15)
        }
    }

}
