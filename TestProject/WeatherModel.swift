//
//  WeatherModel.swift
//  TestProject
//
//  Created by Mihailo Jovanovic on 19.6.21..
//

import Foundation

struct FiveWeatherModel: Codable {
    let cnt: Int
    let list: [CurrentWeatherModel]
    let city: City
}

struct CurrentWeatherModel: Codable {
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let pop: Double
    let dt_txt: String
}

struct Main: Codable {
    let temp: Double
    let pressure: Int
    let humidity: Int
}

struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
}
struct  City:Codable {
    let name: String
    let country: String
}
