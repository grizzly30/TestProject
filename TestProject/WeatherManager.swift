//
//  WeatherManager.swift
//  TestProject
//
//  Created by Mihailo Jovanovic on 19.6.21..
//

import Foundation

class WeatherManager {
    
    init() {}

    func getFiveDaysWeather(longitude: Double, latitude: Double, onCompletion: ((FiveWeatherModel?, Error?) -> Void)?) {
        let headers = [
          "x-rapidapi-host": "community-open-weather-map.p.rapidapi.com",
          "x-rapidapi-key": "d1bc09e81fmshfe1ead36318d57ap1b0de6jsnc6a76921b006"
        ]

        let url = String(format: "https://community-open-weather-map.p.rapidapi.com/forecast?units=metric&lat=%@&lon=%@", String(latitude),String(longitude))
        let request = NSMutableURLRequest(url: NSURL(string:url)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            onCompletion?(nil, error)
            return
          } else {
            if
                let unwrappedData = data,
                let weatherModel = self.parseJSON(unwrappedData) {
                onCompletion?(weatherModel, nil)
            }
          }
        })

        dataTask.resume()
    }
    

    func parseJSON(_ weatherData: Data)-> FiveWeatherModel? {
        let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(FiveWeatherModel.self, from: weatherData)

                    let cnt = decodedData.cnt
                    let list = decodedData.list
                    let city = decodedData.city
            
                    let weather = FiveWeatherModel(cnt: cnt, list: list, city: city)
            return weather
        }catch {
            return nil
        }
    }
}
