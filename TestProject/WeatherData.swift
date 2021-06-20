//
//  WeatherData.swift
//  TestProject
//
//  Created by Mihailo Jovanovic on 19.6.21..
//

import Foundation

enum OpenWeatherError: Error {
    case offline
    case invalidApiKey //401
    case invalidApiRequest //404
    case maxAttemptsReached //429
    case genericError
}

extension OpenWeatherError {
    var errorDescription: String {
        switch self {
        case .offline:
            return "You appear to be offline. Check your internet connection."
        case .invalidApiKey:
            return "Your API key for Open Weather App is invalid, missing or not activated yet."
        case .invalidApiRequest:
            return "Your API request for Open Weather App is invalid."
        case .maxAttemptsReached:
            return "Too many attempts. Please try again later."
        case .genericError:
            return "Oops, Something went wrong! Please try again later."
        }
    }
}

class WeatherData: NSObject {
    static let shared = WeatherData()
    
    let weatherManager = WeatherManager()
    var fiveWeatherData: FiveWeatherModel? {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("fiveWeatherDataDidChange"), object: nil)
        }
    }
    var sections: [String] {
        return getAllSections()
    }

    private override init() {}
    
    func getAllSections() -> [String] {
        guard let dateList = fiveWeatherData?.list.map({ $0.dt_txt }) else { return [] }
            var convertedDates: [String] = []
            
            for dateString in dateList {
                let date = dateString.dateFormater()
                if !convertedDates.contains(date) {
                    convertedDates.append(date)
                }
            }
            return convertedDates
    }
    
    func createWeatherdataDictonary() -> [String: [CurrentWeatherModel]]{
        guard let currentWeatherModel = fiveWeatherData?.list else { return [:]}
        var weatherDataDictionary: [String: [CurrentWeatherModel]] = [:]
        for section in sections {
            let modelsInSection = currentWeatherModel.filter {
                let modelDate = $0.dt_txt.dateFormater()
                return UtilityHelper.compareDates(first: modelDate, second: section)
            }
            weatherDataDictionary[section] = modelsInSection
        }
        
        return weatherDataDictionary
    }
    
    func getWeatherData(longitude: Double, latitude: Double, completionHandler: ((FiveWeatherModel?, OpenWeatherError?) -> Void)?) {
        weatherManager.getFiveDaysWeather(longitude: longitude, latitude: latitude) { fiveWeatherData, error in
            guard error == nil else {
                let openWeatherError = self.parseError(error: error! as NSError)
                completionHandler?(nil, openWeatherError)
                return
            }
            self.fiveWeatherData = fiveWeatherData
            completionHandler?(fiveWeatherData, nil)
        }
    }
    
    func parseError(error: NSError) -> OpenWeatherError {
        /*
         Second approach would be to get localized description from Error
         Without parsing it to NSError
         */
        switch error.code {
        case -1009:
            return .offline
        case 401:
            return .invalidApiKey
        case 404:
            return .invalidApiRequest
        case 429:
            return .maxAttemptsReached
        default:
            return .genericError
        }
    }
}
