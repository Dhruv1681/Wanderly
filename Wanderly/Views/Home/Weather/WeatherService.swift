//
//  WeatherService.swift
//  Wanderly
//
//  Created by Dhruv Soni on 13/12/24.
//

import Foundation
import CoreLocation

struct WeatherResponse: Decodable {
    let main: Main
    let weather: [WeatherCondition]
    
    var current: CurrentWeather {
        return CurrentWeather(temp_c: main.temp, condition: weather.first!)
    }
}

struct Main: Decodable {
    let temp: Double
}

struct WeatherCondition: Decodable {
    let description: String
    let icon: String
    
    var iconURL: URL? {
        return URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
    }
}

struct CurrentWeather {
    let temp_c: Double
    let condition: WeatherCondition
}

// Geocoding Response Model
struct GeocodeResponse: Decodable {
    let name: String
    let lat: Double
    let lon: Double
}

class WeatherService {
    private let apiKey = "8e4a0bd1012cfef02debb5f3051581fc"
    private let baseURL = "https://api.openweathermap.org/data/2.5"

    // Fetch weather details (if needed later)
    func fetchWeather(for location: String, completion: @escaping (CurrentWeather?) -> Void) {
        let urlString = "\(baseURL)/weather?q=\(location)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            do {
                let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(response.current)
            } catch {
                print("Error decoding weather data: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    // Fetch coordinates for a location
    func fetchCoordinates(for location: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(location)&limit=1&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL for geocoding")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            do {
                let results = try JSONDecoder().decode([GeocodeResponse].self, from: data)
                if let firstResult = results.first {
                    let coordinates = CLLocationCoordinate2D(latitude: firstResult.lat, longitude: firstResult.lon)
                    completion(coordinates)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error decoding geocoding data: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
