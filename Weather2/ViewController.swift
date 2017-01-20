//
//  ViewController.swift
//  Weather2
//
//  Created by dima on 09/01/2017.
//  Copyright © 2017 dima. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import CoreLocation


class ViewController: UIViewController, OpenWeatherMapDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var cityNameLabel:UILabel!
    @IBOutlet weak var timelabel:UILabel!
    @IBOutlet weak var templabel:UILabel!
    @IBOutlet weak var speedWindLabel:UILabel!
    @IBOutlet weak var humiditylabel:UILabel!
    @IBOutlet weak var descriptionlabel:UILabel!
    

    let locationManager:CLLocationManager = CLLocationManager()
    
    var openWeather:OpenWeatherMap = OpenWeatherMap()
    var hud = MBProgressHUD()
    @IBAction func cityTappedButom(_ sender: UIBarButtonItem) {
    
        displayCity()
        
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.openWeather.delegate = self
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func displayCity() {
        
        
        //alert
        let alert = UIAlertController(title: "City", message: "Enter name city", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancel = UIAlertAction(title: "Cacel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(cancel)
        
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
            (action) -> Void in
            
            
            if let textField = (alert.textFields?.first)! as? UITextField {
                //self.getWeatherFor(textField.text!)
                self.activityIndecator()
                self.openWeather.getWeatherFor(&textField.text!)
            }
        }
        
        alert.addAction(ok)
        
        //background text
        alert.addTextField { (textField) -> Void in
            textField.placeholder = "City name"
        }
        
        
        self.present(alert, animated: true, completion: nil)

        
    }
    
    
    func activityIndecator() {
        hud.label.text = "Loading..."
        hud.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2)
        hud.dimBackground = true
        self.view.addSubview(hud)
        hud.show(animated: true)
    }
    
    
    //MARK: OpenWeatherMapDelegate
    func updateWeatherInfo(weatherJson:JSON) {
        
        if let tempResult = weatherJson["main"]["temp"].double {
            
            
            
            
            hud.hide(animated: true)
            
            
            
            
            //get country
            let country = weatherJson["sys"]["country"].stringValue
            
            
            
            //get city name
            let cityName = weatherJson["name"].stringValue
            print(cityName)
            self.cityNameLabel.text = "\(cityName), \(country)"
            
            
            
            //get temp
            let temperatura = openWeather.convertTempe(country: country, temperatura: tempResult)
            
            
            //get time
            
            let time = weatherJson["dt"].intValue
            
            
            
            
            
            print(temperatura)
            print(weatherJson["wind"]["speed"])
            //get icon
            
            let weather = weatherJson["weather"][0]
            let condition = weather["id"].intValue
            let nightTime = openWeather.isTimeNight(weatherJson: weatherJson)
            let icon = openWeather.updateWeatherIcon(condition: condition, nightTime: nightTime)
            self.iconImageView.image = icon
            
            
        } else {
            print("Unable load weather info")
        }
        
    }
    
    
    func failure() {
        
        //No connection internet
        let netWorkController = UIAlertController(title: "Error", message: "No connection", preferredStyle: UIAlertControllerStyle.alert)
        
        let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        netWorkController.addAction(okButton)
        self.present(netWorkController, animated: true, completion: nil)
        
    }
    
    
    
    //MARK - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location)
        
        var curentLocation = locations.last as! CLLocation!
        
        if let cur = curentLocation?.horizontalAccuracy, cur > 0 {
            
            //stop updating location
            locationManager.stopUpdatingLocation()
            
            let coords = CLLocationCoordinate2DMake((curentLocation?.coordinate.latitude)!, (curentLocation?.coordinate.longitude)!)
            
            self.openWeather.weatherFor(geo: coords)
            print(coords)
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        print("We cant get you location")
    }
}


