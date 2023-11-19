//
//  WeatherModel.swift
//  Project 2 ios-1
//
//  Created by Andrew Ananda on 17/11/2023.
//

import Foundation



struct WeatherResponse: Codable {
    let location: Location
    let current: Weather
}

struct Location: Codable {
    let name: String
}

struct Weather: Codable {
    let temp_c: Float
    let temp_f: Float
    let condition: WeatherCondition
}

struct WeatherCondition: Codable {
    let text: String
    let code: Int
    
    
    var conditionName:String{ //computed property
        switch code {
        case 200...1003:
            return "cloud"
        case 1183...1190:
            return "cloud.drizzle"
        case 1195...1200:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 1000:
            return "sun"
        case 1006...1010:
            return "cloud.fill"
        default:
            return "cloud"
        }
    }
    
}



struct WeatherModel {
    let conditionId:Int
    let cityName:String
    let temperature:Double
    
    var temperatureString:String{
        return String(format: "%.1f", temperature)
    }
    
    var conditionName:String{
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
}
