//
//  WeatherManager.swift
//  Clima
//
//  Created by user213083 on 2/4/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation


struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=3a175ce966ad0206541f2c517110dbb4&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        //1 create url
        if let url = URL(string: urlString) {
            //2 create urlSession
            let session = URLSession(configuration: .default)
            //3 give task to session
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                    
                }
            }
            //4 start task
            task.resume()
        }
    }
    
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
        let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodeData.main.temp)
            print(decodeData.weather[0].description)
            print(decodeData.main.humidity)
        } catch {
            print(error)
        }
    }
    
    
}
