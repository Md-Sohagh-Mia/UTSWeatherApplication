//
//  WeatherViewModel.swift
//  iOSWeatherApp
//
//  Created by Md Sohagh Mia on 10/05/2024.
//

import Foundation

class WeatherViewModel: ObservableObject {
    private var weatherServiceAPI: WeatherServiceAPI!
    @Published var city_name: String = ""
    @Published var weatherResponse = WeatherResponse.init(name: "", dt: 0, timezone: 0, main: Main(), wind: Wind(), weather: [], sys: Sys())
    @Published var dayTime: Bool = true
    var weatherDate: Int = 0

    /// Initialize the WeatherServiceAPI
    init() {
        self.weatherServiceAPI = WeatherServiceAPI()
        weatherDate = self.weatherResponse.dt
    }
    
    /// Format the date properly (e.g. Thursday, Feb 29, 2024)
    private func dateFormatter(timeStamp: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(timeStamp)))
    }
    
    /// The the current time in 12-hour format with the right timezone (e.g. 9:00 PM)
    private func getTime(timeStamp: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = TimeZone(secondsFromGMT: self.weatherResponse.timezone)
        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(timeStamp)))
    }
    
    /// Get the date returned by the API
    var date: String {
        return self.dateFormatter(timeStamp: self.weatherResponse.dt)
    }
    
    /// Get the sunrise date
    var sunrise: String {
        if let sunrise = self.weatherResponse.sys.sunrise {
            return self.getTime(timeStamp: sunrise)
        }
        return ""
    }
    
    /// Get the sunset date
    var sunset: String {
        if let sunset = self.weatherResponse.sys.sunset {
            return self.getTime(timeStamp: sunset)
        }
        return ""
    }
    
    /// Get the temperature
    var temperature: String {
        if let temp = self.weatherResponse.main.temp {
            return String(format: "%.0f", temp)
        } else {
            return "0"
        }
    }
    
    /// Get the min temp.
    var temp_min: String {
        if let temp_min = self.weatherResponse.main.temp_min {
            return String(format: "%.0f", temp_min)
        } else {
            return "0"
        }
    }
    
    /// Get the max temp
    var temp_max: String {
        if let temp_max = self.weatherResponse.main.temp_max {
            return String(format: "%.0f", temp_max)
        } else {
            return "0"
        }
    }
    
    /// Get the feels like temp
    var feels_like: String {
        if let feels_like = self.weatherResponse.main.feels_like {
            return String(format: "%.0f", feels_like)
        } else {
            return "0"
        }
    }
    
    /// Get the feels like temp
    var pressure: String {
        if let pressure = self.weatherResponse.main.pressure {
            return String(pressure)
        } else {
            return "0"
        }
    }
    
    /// Get the humidity
    var humidity: String {
        if let humidity = self.weatherResponse.main.humidity {
            return String(format: "%.0f", humidity)
        } else {
            return ""
        }
    }
    
    /// Get the wind speed.
    var wind_speed: String {
        if let wind_speed = self.weatherResponse.wind.speed {
            return String(format: "%.0f", wind_speed)
        } else {
            return "0"
        }
    }
    
    /// Get the country code
    var country_code: String {
        if let country_code = self.weatherResponse.sys.country {
            return country_code
        } else {
            return ""
        }
    }
    
    /// Get the weather condition icon.
    var weatherIcon: String {
        if self.weatherResponse.weather.count != 0 {
            if let weatherIcon: String = self.weatherResponse.weather[0].icon {
                switch weatherIcon {
                    case "01d":
                        return "clear_sky_day"
                    case "01n":
                        return "clear_sky_night"
                    case "02d":
                        return "few_clouds_day"
                    case "02n":
                        return "few_clouds_night"
                    case "03d":
                        return "scattered_clouds"
                    case "03n":
                        return "scattered_clouds"
                    case "04d":
                        return "broken_clouds"
                    case "04n":
                        return "broken_clouds"
                    case "09d":
                        return "shower_rain"
                    case "09n":
                        return "shower_rain"
                    case "10d":
                        return "rain_day"
                    case "10n":
                        return "rain_night"
                    case "11d":
                        return "thunderstorm_day"
                    case "11n":
                        return "thunderstorm_night"
                    case "13d":
                        return "snow"
                    case "13n":
                        return "snow"
                    case "50d":
                        return "mist"
                    case "50n":
                        return "mist"
                    default:
                        return "clear_sky_day"
                }
            }
        }
        return "clear_sky_day"
    }
    
    /// Get the weather description
    var description: String {
        if self.weatherResponse.weather.count != 0 {
            if let description: String = self.weatherResponse.weather[0].description {
                return description
            }
        }
        return ""
        
    }
    
    /// Determine the background image to be loaded based on whether it's night or day time.
    var loadBackgroundImage: Bool {
        if let sunset = self.weatherResponse.sys.sunset {
            if self.weatherResponse.dt >= sunset {
                return false
            } else {
                return true
            }
        }
        return true
        
    }
    
    /// Concatenate the city and country code (City of Balanga, PH).
    var city_country: String {
        if self.weatherResponse.name != "" && country_code != "" {
            return self.weatherResponse.name + ", " + self.country_code
        }
        return "-"
    }
    
    /// City name
    var cityName: String = ""
    
    /// Search for city
    public func search(searchText: String) {
        /// You need to add the 'addingPercentEncoding' property so you can search for cities
        /// with space between words, otherwise it will only work on single word cities.
        if let city = searchText.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
            fetchWeatherDetails(city: city, byCoordinates: false, lat: 0.0, long: 0.0)
        }
    }
    
    /// Get the current weather by zip code.
    public func getWeatherByZipCode(by zip: String, country_code: String) {
        self.weatherServiceAPI.weatherByZipCode(zip: zip, country_code: country_code) { weather in
            if let weather = weather {
                DispatchQueue.main.async {
                    self.weatherResponse = weather
                }
            }
        }
    }
    
    /// Fetch the weather by city or coordinates
    public func fetchWeatherDetails(city: String, byCoordinates: Bool, lat: Double, long: Double) {
        /// Trigger the getWeather service from the WeatherServiceAPI.swift
        self.weatherServiceAPI.weatherbyCityORCoordinates(city: city, byCoordinates: byCoordinates, lat: lat, long: long) { weather  in
            
            if let weather = weather {
                DispatchQueue.main.async {
                    self.weatherResponse = weather
                }
            }
        }
    }
}
