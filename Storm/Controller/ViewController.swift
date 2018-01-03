//
//  ViewController.swift
//  Storm
//
//  Created by Lillie Zhou on 1/2/18.
//  Copyright © 2018 Lillie Zhou. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "214c997ae0bddf761fcf343056b9ff3d"
    let locationManager = CLLocationManager()
    let weatherModel = WeatherModel()

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIconLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    // Inform delegate that new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params: [String: String] = ["lat": latitude, "long": longitude, "appid": APP_ID]
            let weatherURL = "\(WEATHER_URL)?lat=\(latitude)&lon=\(longitude)"
            getCurrentWeatherData(url: weatherURL, parameters: params)
        }
    }
    
    // Inform delegate that location data could not be retrieved
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }
    
    // Send an HTTP request (GET) to OpenWeatherMap
    func getCurrentWeatherData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                let weatherJSON: JSON = JSON(response.result.value!)
                self.parse(json: weatherJSON)
            } else {
                self.cityLabel.text = "Connection issues"
            }
        }
    }
    
    // Parse the JSON response
    func parse(json: JSON) {
        if let temperatureData = json["main"]["temp"].double {
            let fahrenheitValue = Int(temperatureData - 273.15) * 9/5 + 32
            weatherModel.temperature = fahrenheitValue
            weatherModel.city = json["name"].stringValue
            let weatherCondition = json["weather"][0]["id"].intValue
            weatherModel.icon = weatherModel.updateWeatherIcon(condition: weatherCondition)
            weatherModel.description = json["weather"][0]["description"].stringValue
            updateUIWithWeatherData()
            print(json)
        } else {
            temperatureLabel.text = "Weather N/A"
        }
    }
    
    // Update the UI to reflect the current weather data
    func updateUIWithWeatherData() {
        cityLabel.text = weatherModel.city!
        temperatureLabel.text = "\(weatherModel.temperature!) ℉"
        weatherIconLabel.text = weatherModel.icon!
        weatherDescriptionLabel.text = String(weatherModel.description!)
    }
}

