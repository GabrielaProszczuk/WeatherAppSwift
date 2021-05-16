//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 06/05/2021.
//

import Foundation
struct WeatherModel{
    var records: Array<WeatherRecord> = []
     
    init(cities: Array<String>){
        records = Array<WeatherRecord>()
        for city in cities{
            records.append(WeatherRecord(cityName: city))
        }
    }
    struct WeatherRecord: Identifiable{
        var id: UUID = UUID()
        var cityName: String
        var weatherState: String = "not clear"
        var temperature: Float = Float.random(in: -10...30)
        var humidity: Float = Float.random(in: 0...100)
        var windSpeed: Float = Float.random(in: 0...20)
        var windDirection: Float = Float.random(in: 0..<360)
    }
    
    mutating func refresh(record: WeatherRecord){
        var i = 0
        for rec in records{
            if(rec.cityName==record.cityName){
                records[i].temperature = Float.random(in: -10...30)
                print("Refreshing record: \(record)")
            }
            i += 1
        }
    }
}
