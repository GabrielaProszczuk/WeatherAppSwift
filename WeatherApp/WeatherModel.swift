//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 06/05/2021.
//

import Foundation
import Combine
struct WeatherModel{
    var records: Array<WeatherRecord> = []
     
    init(cities: Array<String>, weatherStates: Array<String>){
        records = Array<WeatherRecord>()
        //creating new records by given data
        var storage = Set<AnyCancellable>()
        for (city,state) in zip(cities,weatherStates){
            let request = URLRequest(url: URL(string: "https://www.metaweather.com/api/location/44418/")!)
            URLSession.shared.dataTaskPublisher(for: request)
                .sink(receiveCompletion: { _ in print("completion")}
                      , receiveValue: {print ($0)}
                ).store(in: &storage)
               
            records.append(WeatherRecord(cityName: city, weatherState: state))
        }
        print(storage)
    }
    struct WeatherRecord: Identifiable{
        var id: UUID = UUID()
        var cityName: String
        var weatherState: String 
        var temperature: Float = Float.random(in: -10...30)
        var humidity: Float = Float.random(in: 0...100)
        var windSpeed: Float = Float.random(in: 0...20)
        var windDirection: Float = Float.random(in: 0..<360)
        //variables added to change view after tapping
        var showing: String = "Temperature"
        var value: Float = Float.random(in: -10...30)
        var unit: String = "℃"
    }
    
    mutating func refresh(record: WeatherRecord){
        var i = 0
        for rec in records{
            //refresh shown variable
            if(rec.cityName==record.cityName){
                    if(records[i].showing=="Temperature"){
                        records[i].temperature = Float.random(in: -10...30)
                        records[i].value = records[i].temperature
                    }else if(records[i].showing=="Humidity"){
                        records[i].humidity = Float.random(in: 0...100)
                        records[i].value = records[i].humidity
                    }else if(records[i].showing=="Wind Speed"){
                        records[i].windSpeed = Float.random(in: 0...20)
                        records[i].value = records[i].windSpeed
                    }else if(records[i].showing == "Wind Direction"){
                        records[i].windDirection = Float.random(in: 0..<360)
                        records[i].value = records[i].windDirection
                    }
            }
            i += 1
        }
    }
    
    //find and change shown variable
    mutating func change(record: WeatherRecord){
        var i = 0
        for rec in records{
            if(rec.cityName==record.cityName){
                if(records[i].showing=="Temperature"){
                    records[i].showing = "Humidity"
                    records[i].value = records[i].humidity
                    records[i].unit = "g/m3"
                }else if(records[i].showing=="Humidity"){
                    records[i].showing = "Wind Speed"
                    records[i].value = records[i].windSpeed
                    records[i].unit = "km/h"
                }else if(records[i].showing=="Wind Speed"){
                    records[i].showing = "Wind Direction"
                    records[i].value = records[i].windDirection
                    records[i].unit = ""
                }else if(records[i].showing == "Wind Direction"){
                    records[i].showing = "Temperature"
                    records[i].value = records[i].temperature
                    records[i].unit = "℃"
                    
                }
            }
            i += 1
        }
    }
}
