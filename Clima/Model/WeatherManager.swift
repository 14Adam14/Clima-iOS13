//
//  WeatherManager.swift
//  Clima
//
//  Created by user213083 on 2/4/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation




protocol WeatherManagerDelegate {
    
    func didUpdateWeather(weather: WeatherModel)
}





struct WeatherManager {
    
   
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=3a175ce966ad0206541f2c517110dbb4&units=metric"
    
    
    var delegate: WeatherManagerDelegate?
    
    
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
                   if let weather = self.parseJSON(weatherData: safeData) {
                       self.delegate?.didUpdateWeather(weather: weather)
                    }
                    
                }
            }
            //4 start task
            task.resume()
        }
    }
    
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
        let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let name = decodeData.name
            
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
            
            
        } catch {
            print(error)
            return nil
        }
    }
    
   
    

}


