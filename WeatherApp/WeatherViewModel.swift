//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 13/05/2021.
//
import Combine
import Foundation

class WeatherViewModel: ObservableObject{
    var cities = ["523920","1118370", "455825", "2122265", "2391279", "1528488", "742676", "565346", "368148", "638242", "862592"]
    @Published private(set) var model = WeatherModel()
    var fetcher = MetaWeatherFetcher()
    private var cancellables: Set<AnyCancellable> = []
    
    var records: Array<WeatherModel.WeatherRecord> {
        model.records
    }
    init() {
        for city in cities {
            fetcher.fetchWeather(forId: city)
                .sink(receiveCompletion: { _ in},
                      receiveValue: { value in self.model.records.append(WeatherModel.WeatherRecord(response: value))
                })
                .store(in: &cancellables)
        }
    }
    
    func refresh(record: WeatherModel.WeatherRecord){
        model.refresh(record: record)
    }
    
    func change(record: WeatherModel.WeatherRecord){
        model.change(record: record)
    }
}
