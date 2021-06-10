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

  
    var fetcher = MetaWeatherFetcher()
    var cities = ["44418","1118370", "455825", "646099", "721943", "1528488", "742676", "565346", "368148", "638242", "862592"]
    let locationManager: CLLocationManager;
    
    @Published var closestLoc: String?;
    @Published var lastLoc: CLLocation?;
    @Published private(set) var model = WeatherModel()
    
    //Cancellables
    private var cancellables: Set<AnyCancellable> = []
    private var set: Set<AnyCancellable> = []
    private var cancelNew: Set<AnyCancellable> = []
    private var locCancellable: Set<AnyCancellable> = []
    
    var records: Array<WeatherModel.WeatherRecord> {
        model.records
    }
    
    override init() {
       locationManager = CLLocationManager()
       locationManager.requestWhenInUseAuthorization()
       super.init()
       locationManager.delegate = self
       locationManager.startUpdatingLocation()
        
       for city in cities {
            fetcher.fetchWeather(forId: city)
                .sink(receiveCompletion: { _ in},
                      receiveValue: { value in self.model.records.append(WeatherModel.WeatherRecord(response: value))
                })
                .store(in: &cancellables)
        }
        
    }

    //aktualna lokalizacja
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let status = CLLocationManager.authorizationStatus();
        if (status != .denied && status != .restricted) {
            lastLoc = locations.first;
            checkCity()
        }
    }

    func checkCity() {
            if let location = self.lastLoc {
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location, completionHandler: {
                    (placemarks, error) in
                        if error == nil {
                            let firstLocation = placemarks?[0]
                            self.closestLoc = firstLocation?.locality
                            }
                        })

                let long = String(location.coordinate.longitude)
                let latt = String(location.coordinate.latitude)
                
                
                var woeid = ""
                fetcher.fetchCity(forId: latt, forId: long)
                    .sink(receiveCompletion: { _ in
                    }, receiveValue: { record in
                        woeid = String(record[0].woeid)
                        self.fetcher.fetchWeather(forId: woeid)
                            .sink(receiveCompletion: { _ in},
                                  receiveValue: { res in
                                    self.model.records[0] = WeatherModel.WeatherRecord(response: res)
                                    if let closest = self.closestLoc {
                                        self.model.records[0].cityName = String(closest) +  "(" + String(record[0].title) + ")" }
                                    self.model.refresh(city: self.model.records[0].woeId, record: self.model.records[0])
                            })
                            .store(in: &self.cancelNew)
                        
                    })
                    .store(in: &locCancellable)
                
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
