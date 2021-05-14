//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 06/05/2021.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    var view = WeatherViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: view)
        }
    }
}
