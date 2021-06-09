//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 06/05/2021.
//

import Foundation
import Combine


struct WeatherModel{
    var set: Set<AnyCancellable> = []
    var records: Array<WeatherRecord> = []
    var fetcher = MetaWeatherFetcher()
        

    struct WeatherRecord: Identifiable{
        var id: UUID = UUID()
        var cityName: String
        var woeId: String
        var weatherState: String
        var temperature: Float
        var humidity: Float
        var windSpeed: Float
        var windDirection: Float
        //variables added to change view after tapping
        var showing: String = "Temperature"
        var value: Float
        var unit: String = "℃"
        
        init(response: MetaWeatherResponse){
            cityName = response.title
            woeId = String(response.woeid)
            weatherState = response.consolidatedWeather[0].weatherStateName
            temperature = Float(response.consolidatedWeather[0].theTemp)
            humidity = Float(response.consolidatedWeather[0].humidity)
            windSpeed = Float(response.consolidatedWeather[0].windSpeed)
            windDirection = Float(response.consolidatedWeather[0].windDirection)
            value = Float(response.consolidatedWeather[0].theTemp)
            //print(weatherState)
        }
    }
    
    mutating func refresh(city: String, record: WeatherRecord) {
        let i = records.firstIndex(where: { $0.woeId == city })
            if  i != nil{
                records[i!] = record
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
                    records[i].unit = "%"
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
