//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 06/05/2021.
//

import Foundation
struct WeatherModel{
    var records: Array<WeatherRecord> = []
     
    init(cities: Array<String>)
    {
        records: Array<WeatherRecord>
        for city in cities{
            records.append(WeatherRecord(cityName: city))
        }
    }
    struct WeatherRecord{
        var cityName: String
        var weatherState: String = "clear"
        var temperature: Float = Float.random(in: -10...30)
        var humidity: Float = Float.random(in: 0...100)
        var windSpeed: Float = Float.random(in: 0...20)
        var windDirection: Float = Float.random(in: 0..<360)
    }
    
    func refresh(record: WeatherRecord){
        print("Refreshing record: \(record)")
    }
}
