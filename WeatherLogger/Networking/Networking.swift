//
//  Networking.swift
//  WeatherLogger
//
//  Created by Qaisar Rizwan on 1/14/20.
//  Copyright © 2020 Qaisar Rizwan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import CoreData


class Networking {
    static let instence = Networking()
    var weatherDataInfo:[WeatherData] = []
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    //Mark: - Networking
    /******************************************/
    func getWeatherData(url: String, parameters:[String: String],completion: @escaping  CompletionHandeler){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the weather data")
                let weatherJSON:JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                completion(true)
            }else {
                print("Error \(String(describing: response.result.error))")
                print("Connection Issues")
                completion(false)
            }
        }
    }
    
    //Mark: - JSON Parsing
    /******************************************/
    func updateWeatherData(json:JSON){
        
        guard let managedContext = self.appDelegate?.persistentContainer.viewContext else { return }
        let localData = WeatherData(context: managedContext)
        
        if let tempResult =  json["main"]["temp"].double{
            let temprature = Int(tempResult - 273.15)
            let city = json["name"].stringValue
            let condition = json["weather"][0]["id"].intValue
            let country = json["sys"]["country"].stringValue
            let description = json["weather"][0]["description"].stringValue
            let humidity = json["main"]["humidity"].intValue
            let main = json["weather"][0]["main"].stringValue
            let todayDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let DateInFormat = dateFormatter.string(from: todayDate)
           
            localData.city = city
            localData.temprature = Int32(temprature)
            localData.condition = Int32(condition)
            localData.country = country
            localData.discript = description
            localData.humidity = Int32(humidity)
            localData.main = main
            localData.date = DateInFormat
   
            do{
                try managedContext.save()
                print("data is saved in LOCAL DB")
            }catch{
                debugPrint("could not save: \(error.localizedDescription)")
            }
            
        }else{
            print("Weahter Unavailable")
        }
    }
    
    func fetch(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<WeatherData>(entityName: "WeatherData")
        
        do {
            weatherDataInfo = try managedContext.fetch(fetchRequest)
            print("Successfully fetched data.")
            completion(true)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    
    
}
