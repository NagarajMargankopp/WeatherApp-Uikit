//
//  weatherUtility.swift
//  Weather
//
//  Created by Margankopp, Nagaraj (Contractor) on 29/05/23.
//

import Foundation
import  UIKit

struct WeatherList:Codable{
    var coord : CoordinateInfo
    var weather : [WeatherInfo]
    var main : MainInfo
    var wind : WindInfo
    var visibility : Int
    var name:String
    
}
struct WeatherInfo:Codable{
    var main : String
    var description : String
    var icon : String
}
struct MainInfo:Codable {
    var temp : Double
    var temp_min : Double
    var temp_max : Double
    var pressure : Int
    var humidity : Int
    var feels_like : Double
}
struct CoordinateInfo:Codable {
    var lon:Double
    var lat:Double
}
struct WindInfo:Codable {
    var speed : Double
    var deg : Float
}
struct WeatherUtility:Codable{
    static var shared = WeatherUtility()
    private init(){
        
    }
    func getImageFromWeb(iconName:String,completion: @escaping(UIImage?)->Void){
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(iconName)@2x.png") else{
            print("Invalid Url")
            return
        }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else{
                print("Failed to retrive image data")
                return
            }
            if let image = UIImage(data: imageData){
                
                completion(image)
            }else{
                print("Failed to get image from data")
            }
        }
       
    }
    func setUpWeatherApi(lat:Double,long:Double,handler: @escaping([WeatherList])->Void ) {
        let WebLink = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=dc8606b5294e9f24b042383e39d8ccaa&units=metric"
        print(WebLink)
        let session = URLSession.shared
       
        if  let url = URL(string: WebLink){
            
            let task = session.dataTask(with: url) { data, respose, err in
                
                if err ==  nil{
                    print("Request Succesfull")
                    let statusCode = (respose as! HTTPURLResponse).statusCode
                    switch statusCode{
                    case 200...299:
                        print("Success")
                        
                        let weatherList = parseData(jsonRespose: data)
                       // print("WeatherList:\(weatherList.count)")
                        print(data!)
                        handler(weatherList)
                    case 300...399:
                        print("Redirection")
                    case 400...499:
                        print("Client error")
                    case 500...599:
                        print("Server error")
                    default:
                        print("Unknown error")
                        
                    }
                }
            }
            task.resume()
        }else{
            print("Invalid URL")
        }
        
        func parseData(jsonRespose:Data?) -> [WeatherList]{
            guard let jsonData=jsonRespose else{
                return []
            }
            do{
                let weatherList =  try JSONDecoder().decode(WeatherList.self, from: jsonData)
//                print(weatherList)
            return [weatherList]
            }catch{
                print("check")
                print("\(error.localizedDescription)")
            }
            
            return []
            
        }
        
        
        
    }
}
