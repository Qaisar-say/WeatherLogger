//
//  WeatherDetailViewController.swift
//  WeatherLogger
//
//  Created by Qaisar Rizwan on 1/17/20.
//  Copyright © 2020 Qaisar Rizwan. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    var detailTemprature: Int32? = nil
    var detailCity: String? = ""
    var detailCondition: Int32? = nil
    var detailConuntry: String? = ""
    var detailDescription: String? = ""
    var detailHumidity: Int32? = nil
    var detailMain: String? = ""

    @IBOutlet var tempratureLabel: UILabel!
    @IBOutlet var weatherIconName: UIImageView!
    @IBOutlet var country: UILabel!
    @IBOutlet var city: UILabel!
    @IBOutlet var humidity: UILabel!
    @IBOutlet var descriptionLong: UILabel!
    @IBOutlet var main: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tempratureLabel.text = String("\(detailTemprature!)°C")
        let iconName = updateWeatherIcon(condition: Int(detailCondition!))
        self.weatherIconName.image = UIImage(named: String(iconName))
        self.country.text = detailConuntry
        self.city.text = detailCity
        self.descriptionLong.text = detailDescription
        self.main.text = detailMain
        self.humidity.text = String("\(detailHumidity!)")
        
    }
    
    func updateWeatherIcon(condition: Int) -> String {
           
       switch (condition) {
       
           case 0...300 :
               return "tstorm1"
           
           case 301...500 :
               return "light_rain"
           
           case 501...600 :
               return "shower3"
           
           case 601...700 :
               return "snow4"
           
           case 701...771 :
               return "fog"
           
           case 772...799 :
               return "tstorm3"
           
           case 800 :
               return "sunny"
           
           case 801...804 :
               return "cloudy2"
           
           case 900...903, 905...1000  :
               return "tstorm3"
           
           case 903 :
               return "snow5"
           
           case 904 :
               return "sunny"
           
           default :
               return "dunno"
           }

       }

}
