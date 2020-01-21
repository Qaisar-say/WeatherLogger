//
//  ViewController.swift
//  WeatherLogger
//
//  Created by Qaisar Rizwan on 1/14/20.
//  Copyright © 2020 Qaisar Rizwan. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData


class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var tableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    //TODO: Declare  variables here
    var params:[String: String] = [:]
    var latitude = String()
    var longitude = String()
    
    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: TableView Delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        //TODO: Setup location manager here
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        Networking.instence.fetch { (complete) in
            if complete{
                self.tableView.reloadData()
            }
        }
    }
    
    //Mark: - Location manager delegate methods
    /******************************************/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            latitude = String(location.coordinate.latitude)
            longitude = String(location.coordinate.longitude)
            
            params = ["lat": latitude, "lon": longitude, "appid": APP_ID]
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Unavailable \(error)")
    }
    
    @IBAction func Save(_ sender: UIButton) {
        Networking.instence.getWeatherData(url: WEATHER_URL, parameters: params, completion: { (success) in
            Networking.instence.fetch { (complete) in
                if complete{
                    self.tableView.reloadData()
                }
            }
        })
        
    }
}

//Mark: - TableView Delegate Methods
/******************************************/

extension WeatherViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Networking.instence.weatherDataInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? WeatherTableViewCell {
            let dta = Networking.instence.weatherDataInfo[indexPath.row]
            cell.configureCell(data:dta)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as! WeatherDetailViewController
        let weatherInfo = Networking.instence.weatherDataInfo[indexPath.row]
        detailView.detailTemprature = weatherInfo.temprature
        detailView.detailCondition = weatherInfo.condition
        detailView.detailConuntry = weatherInfo.country
        detailView.detailCity = weatherInfo.city
        detailView.detailDescription = weatherInfo.discript
        detailView.detailMain = weatherInfo.main
        detailView.detailHumidity = weatherInfo.humidity
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let managedContext = self.appDelegate?.persistentContainer.viewContext else { return }
            let requestDel = NSFetchRequest<WeatherData>(entityName: "WeatherData")
            requestDel.returnsObjectsAsFaults = false
            do {
                let weatherObj = try managedContext.fetch(requestDel)
                managedContext.delete(weatherObj[indexPath.row] as NSManagedObject)
                print("deleted")
                try managedContext.save()
            } catch {
                print("Failed")
            }
            Networking.instence.weatherDataInfo.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

