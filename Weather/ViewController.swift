//
//  ViewController.swift
//  Weather
//
//  Created by Margankopp, Nagaraj (Contractor) on 29/05/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController{
    var Info = [WeatherList] ()

    @IBOutlet weak var cityL: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var tempL: UILabel!
    @IBOutlet weak var mainL: UILabel!
    @IBOutlet weak var maxminTempL: UILabel!
    @IBOutlet weak var speedL: UILabel!
    @IBOutlet weak var feelsL: UILabel!
    @IBOutlet weak var humidityL: UILabel!
    @IBOutlet weak var pressureL: UILabel!
    @IBOutlet weak var visibilityL: UILabel!
    @IBOutlet weak var descripL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currentWeather()
       
        let gradientlayer = CAGradientLayer()
        gradientlayer.frame = view.bounds
        
        gradientlayer.colors = [UIColor.systemBlue.cgColor,UIColor.white.cgColor]
        gradientlayer.startPoint = CGPoint(x:0.0,y: 0.0)
        gradientlayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientlayer, at: 0)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func showAlert() {
        let alertVC = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Search", style: .default) { _ in
            let geoCoder = CLGeocoder()
            guard let place = alertVC.textFields?.first?.text else{
                print("Enter correct city")
                return
            }
            print(place)
            geoCoder.geocodeAddressString(place) { geodata, _ in
                let lat:Double
                let long:Double
                lat = geodata![0].location?.coordinate.latitude ?? 0
                long = geodata![0].location?.coordinate.longitude ?? 0
                WeatherUtility.shared.setUpWeatherApi(lat: lat, long: long) { weatherArray in
                    self.Info = weatherArray
                    print(weatherArray)
                    DispatchQueue.main.async {
                        self.cityL.text = weatherArray[0].name
                        self.tempL.text = "\(weatherArray[0].main.temp)"
                        self.mainL.text = weatherArray[0].weather[0].main
                        self.maxminTempL.text = "\(weatherArray[0].main.temp_max)°C/\(weatherArray[0].main.temp_min)°C"
                        self.feelsL.text = "\(weatherArray[0].main.feels_like)°C"
                        self.humidityL.text = "\(weatherArray[0].main.humidity)%"
                        self.pressureL.text = "\(weatherArray[0].main.pressure) hPa"
                        let visible = weatherArray[0].visibility / 1000
                        self.visibilityL.text = "\(visible) km"
                        self.descripL.text = weatherArray[0].weather[0].description
                        self.speedL.text = "\(weatherArray[0].wind.speed) km/h"
                        let iconName = weatherArray[0].weather[0].icon
                        WeatherUtility.shared.getImageFromWeb(iconName: iconName) { imagedata in
                            DispatchQueue.main.async {
                                if let img = imagedata {
                                    self.imgV.image = img
                                }else{
                                    self.imgV.image = UIImage(named: "person")
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        alertVC.addAction(alertAction)
        present(alertVC, animated: true)
        alertVC.addTextField(){field  in
            field.placeholder = "Enter location"
            field.keyboardType = .default
            
        }
    }
    
    @IBAction func ResetB(_ sender: Any) {
        currentWeather()
        
    }
    
    @IBAction func addButton(_ sender: Any) {
        showAlert()
    }
    
    func currentWeather(){
        var currentLocation : CLLocation!
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            
            currentLocation = locManager.location
            //print(currentLocation)
        }
        
        var long = currentLocation.coordinate.longitude
       var lat = currentLocation.coordinate.latitude
         //print("\(long),\(lat)")
        
        WeatherUtility.shared.setUpWeatherApi(lat: lat, long: long) { weatherArray in
           
            self.Info = weatherArray
            print(weatherArray)
           
                DispatchQueue.main.async {
                    self.cityL.text = weatherArray[0].name
                    self.tempL.text = "\(weatherArray[0].main.temp)"
                    self.mainL.text = weatherArray[0].weather[0].main
                    self.maxminTempL.text = "\(weatherArray[0].main.temp_max)°C/\(weatherArray[0].main.temp_min)°C"
                    self.feelsL.text = "\(weatherArray[0].main.feels_like)°C"
                    self.humidityL.text = "\(weatherArray[0].main.humidity)%"
                    self.pressureL.text = "\(weatherArray[0].main.pressure) hPa"
                    let visible = weatherArray[0].visibility / 1000
                    self.visibilityL.text = "\(visible) km"
                    self.descripL.text = weatherArray[0].weather[0].description
                    self.speedL.text = "\(weatherArray[0].wind.speed) km/h"
                    let iconName = weatherArray[0].weather[0].icon
                    WeatherUtility.shared.getImageFromWeb(iconName: iconName) { imagedata in
                        DispatchQueue.main.async {
                            if let img = imagedata {
                                self.imgV.image = img
                            }else{
                                self.imgV.image = UIImage(named: "person")
                            }
                        }
                        
                    }
                }
        }
        
        
        
    }
   

}


