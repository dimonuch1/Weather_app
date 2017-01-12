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

protocol OpenWeatherMapDelegate {
    func updateWeatherInfo(weatherJson: JSON)
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
