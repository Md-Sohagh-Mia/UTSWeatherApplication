//
//  WeatherModel.swift
//  iOSWeatherApp
//
//  Created by Md Sohagh Mia on 10/05/2024.
//

import Foundation

/// Weather response structure
struct WeatherResponse: Codable {
    var name: String
    var dt: Int
    var timezone: Int
    var main: Main
    var wind: Wind
    var weather: [Weather]
    var sys: Sys
}

/// 'Main' weather object in the API response.
struct Main: Codable {
    var temp: Double?
    var humidity: Double?
    var temp_min: Double?
    var temp_max: Double?
    var pressure: Int?
    var feels_like: Double?
}

/// 'Wind' object in the API response.
struct Wind: Codable {
    var speed: Double?
}

/// 'Weather' object in the API response.
struct Weather: Codable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}

/// 'Sys' object in the API response.
struct Sys: Codable {
    var country: String?
    var sunrise: Int?
    var sunset: Int?
}
