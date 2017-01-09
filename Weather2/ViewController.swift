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


class ViewController: UIViewController, OpenWeatherMapDelegate {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    var openWeather:OpenWeatherMap = OpenWeatherMap()
    
    @IBAction func cityTappedButom(_ sender: UIBarButtonItem) {
    
        displayCity()
        
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.openWeather.delegate = self
        
        /*
         let stringURL = NSURL(string: url)
         
         let weatherObject = NSData(contentsOfURL: stringURL!)
         
         //print(weatherObject)
         
         let session = NSURLSession.sharedSession()
         
         let task = session.downloadTaskWithURL(stringURL!) { (location:NSURL?, response:NSURLResponse?, error:NSError?) in
         //print(response)
         
         let weatherData = NSData(contentsOfURL: stringURL!)
         
         do {
         let weatherJson = try NSJSONSerialization.JSONObjectWithData(weatherData!, options: []) //as! NSDictionary
         //print(weatherJson)
         
         
         let weather = OpenWeatherMap(weatherJson: weatherJson as! NSDictionary)
         
         print(weather.nameCity)
         print(weather.temp)
         print(weather.description)
         print(weather.currentTime!)
         print(weather.icon!)
         
         
         dispatch_async(dispatch_get_main_queue(), {
         self.iconImageView.image = weather.icon!
         })
         
         
         } catch {
         NSLog("Error:  \((error as NSError).localizedDescription)")
         }
         
         }
         
         //каждую задачу необходимо запускать
         task.resume()
         */
        
        
        
        
        
        
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
                self.openWeather.getWeatherFor(textField.text!)
            }
        }
        
        alert.addAction(ok)
        
        //background text
        alert.addTextField { (textField) -> Void in
            textField.placeholder = "City name"
        }
        
        
        self.present(alert, animated: true, completion: nil)
        
        
        ///////////
        
        
    }
    
    //MARK: OpenWeatherMapDelegate
    func updateWeatherInfo() {
        print(openWeather.nameCity)
    }
    
    /*
     func getWeatherFor(city:String) {
     print(city)
     }
     */
    
}


