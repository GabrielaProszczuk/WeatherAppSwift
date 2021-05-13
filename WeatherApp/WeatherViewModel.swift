//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 13/05/2021.
//

import Foundation
class WeatherViewModel{
    private(set) var model: WeatherModel = WeatherModel(cities: ["Paris","Berlin","Venice","Minsk","London","Lublin"])
    var records: Array<WeatherModel.WeatherRecord>{
        model.records
    }
    func refresh(record: WeatherModel.WeatherRecord){
        model.refresh(record: record)
    }
}
