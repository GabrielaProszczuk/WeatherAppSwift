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
    @Published private(set) var model: WeatherModel
    var fetcher: MetaWeatherFetcher
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        model = WeatherModel()
        fetcher = MetaWeatherFetcher()
        for city in cities {
                print("ID = \(city)")
                Just(city)
                    .sink ( receiveValue: fetchWeather(forId:))
                    .store(in: &cancellables)
            }
        }
        
     var records: Array<WeatherModel.WeatherRecord> {
            model.records
    }
        
    func fetchWeather(forId woeId: String) {
            fetcher.fetchWeather(forId: woeId)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    print(completion)
                }, receiveValue: { value in
                    self.model.records.append(WeatherModel.WeatherRecord(response: value))
                })
                .store(in: &cancellables)
        }
    

    
    func refresh(record: WeatherModel.WeatherRecord){
       // objectWillChange.send()
        model.refresh(record: record)
    }
    
    func change(record: WeatherModel.WeatherRecord){
        model.change(record: record)
    }
}
