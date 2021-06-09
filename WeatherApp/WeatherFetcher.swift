//
//  WeatherFetcher.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 09/06/2021.
//

import Foundation
import Combine

class MetaWeatherFetcher {
    func fetchWeather(forId city: String) -> AnyPublisher<MetaWeatherResponse, Error> {
        let url = URL(string: "https://www.metaweather.com/api/location/"+city+"/")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .receive(on: RunLoop.main)
            .decode(type: MetaWeatherResponse.self, decoder:JSONDecoder())
            .eraseToAnyPublisher()
    }
}
