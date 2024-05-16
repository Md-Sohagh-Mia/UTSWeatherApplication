//
//  WeatherServiceAPI.swift
//  iOSWeatherApp
//
//  Created by Md Sohagh Mia on 10/05/2024.
//

import Foundation

class WeatherServiceAPI {
    /// Get the current weather forecast for a given city.
    func weatherbyCityORCoordinates(city: String, byCoordinates: Bool, lat: Double, long: Double, completion: @escaping (WeatherResponse?) -> ()) {
        
        let coordsUrl = Constants.openWeatherAPIUrl + "lat=\(lat)&lon=\(long)" + "&appid=\(Constants.APIKey)" + "&units=metric"
        let cityUrl = Constants.openWeatherAPIUrl + "q=\(city)" + "&appid=\(Constants.APIKey)" + "&units=metric"
        
        guard let url = byCoordinates ? URL(string: coordsUrl) : URL(string: cityUrl) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)
            if let weatherResponse = weatherResponse {
                let weatherData = weatherResponse
                completion(weatherData)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    /// Get the weather forecast using zip and country code.
    func weatherByZipCode(zip: String, country_code: String, completion: @escaping (WeatherResponse?) -> ()) {
        
        let zipUrl = Constants.openWeatherAPIUrl + "zip=\(zip),\(country_code)" + "&appid=\(Constants.APIKey)" + "&units=metric"
        
        guard let url = URL(string: zipUrl) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)
            if let weatherResponse = weatherResponse {
                let weatherData = weatherResponse
                completion(weatherData)
                
            } else {
                completion(nil)
            }
        }.resume()
    }
}

