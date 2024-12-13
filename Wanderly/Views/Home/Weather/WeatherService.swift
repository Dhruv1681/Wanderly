//
//  WeatherService.swift
//  Wanderly
//
//  Created by Dhruv Soni on 13/12/24.
//

import Foundation

struct WeatherResponse: Decodable {
    let current: CurrentWeather
}

struct CurrentWeather: Decodable {
    let temp_c: Double
    let condition: WeatherCondition
}

struct WeatherCondition: Decodable {
    let text: String
    let icon: String
}

class WeatherService {
    private let apiKey = "8e4a0bd1012cfef02debb5f3051581fc"
    private let baseURL = "https://api.weatherapi.com/v1"

    func fetchWeather(for location: String, completion: @escaping (CurrentWeather?) -> Void) {
        let urlString = "\(baseURL)/current.json?key=\(apiKey)&q=\(location)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
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
}
