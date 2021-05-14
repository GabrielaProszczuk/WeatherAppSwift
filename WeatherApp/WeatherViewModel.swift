//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 13/05/2021.
//

import Foundation
class WeatherViewModel: ObservableObject{
    @Published private(set) var model: WeatherModel = WeatherModel(cities: ["Paris","Berlin","Venice","Minsk","London","Lublin"])
    
    var records: Array<WeatherModel.WeatherRecord>{
        model.records
    }
    
    func refresh(record: WeatherModel.WeatherRecord){
       // objectWillChange.send()
        model.refresh(record: record)
    }
}
