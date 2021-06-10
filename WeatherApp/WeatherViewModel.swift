//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 13/05/2021.
//
import Combine
import Foundation
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    var cities = ["44418","1118370", "455825", "2122265", "2391279", "1528488", "742676", "565346", "368148", "638242", "862592"]
    @Published private(set) var model = WeatherModel()
    var fetcher = MetaWeatherFetcher()
    private var cancellables: Set<AnyCancellable> = []
    private var set: Set<AnyCancellable> = []
    let locationManager: CLLocationManager;
    @Published var nearestCity: String?;
    @Published var lastSeenLocation: CLLocation?;
    
    var records: Array<WeatherModel.WeatherRecord> {
        model.records
    }
    override init() {
       locationManager = CLLocationManager()
       locationManager.requestWhenInUseAuthorization()
       super.init()
       locationManager.delegate = self
       for city in cities {
            fetcher.fetchWeather(forId: city)
                .sink(receiveCompletion: { _ in},
                      receiveValue: { value in self.model.records.append(WeatherModel.WeatherRecord(response: value))
                })
                .store(in: &cancellables)
        }
        
    }


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus, didUpdateLocations locations: [CLLocation]) {
        if (status == .authorizedWhenInUse || status == .authorizedAlways) {
            lastSeenLocation = locations.first;
                if let lastLocation = self.lastSeenLocation {
                    let geocoder = CLGeocoder()
                    geocoder.reverseGeocodeLocation(lastLocation,
                        completionHandler: { (placemarks, error) in
                            if error == nil {
                                let firstLocation = placemarks?[0]
                                self.nearestCity = firstLocation?.locality;
                                }
                            })
                    }
        }
    }

    func refresh(city: String) {
            objectWillChange.send()
            fetcher.fetchWeather(forId: city)
                .map { res in
                    WeatherModel.WeatherRecord(response: res)
                }
                .sink(receiveCompletion: { _ in
                }, receiveValue: { res in
                    self.model.refresh(city: city, record: res)})
                .store(in: &set)
        }
    
    func change(record: WeatherModel.WeatherRecord){
        model.change(record: record)
    }
}
