//
//  ContentView.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 06/05/2021.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel: WeatherViewModel
    var imageState: [String: String] = [
                      "clear": "☀️",
                      "lightCloud":"🌤",
                      "heavyCloud":"☁️",
                      "thunderstorm":"🌩",
                      "showers":"🌦",
                      "lightRain":"🌧",
                      "heavyRain":"⛈",
                      "snow":"❄️",
                      "sleet":"🌨",
                      "hail":"💨"
        
    ]
    var data: String = ""
    var body: some View {
        ScrollView(.vertical){
            VStack{
            
                ForEach(viewModel.records){ rec in
                    //checking if records state exist in dictionary
                    if((imageState[rec.weatherState]) == "☀️" || (imageState[rec.weatherState]) == "🌤" ||
                        (imageState[rec.weatherState]) == "☁️" ||
                        (imageState[rec.weatherState]) == "🌧" ||
                        (imageState[rec.weatherState]) == "🌦" ||
                        (imageState[rec.weatherState]) == "⛈" ||
                        (imageState[rec.weatherState]) == "❄️" ||
                        (imageState[rec.weatherState]) == "🌩" ||
                        (imageState[rec.weatherState]) == "💨"){
                        
                        WeatherRecordView(record: rec, viewModel: viewModel, image: imageState[rec.weatherState]!)
                        
                    }
                    else{
                        WeatherRecordView(record: rec, viewModel: viewModel, image: "﹖")
                        
                    }
                }
            }.padding()
        }
    }
}

struct WeatherRecordView: View{
    var record: WeatherModel.WeatherRecord
    var viewModel: WeatherViewModel
    var image: String
    
    var body: some View{

            ZStack{
                RoundedRectangle(cornerRadius: 25.0)
                    .stroke()
                HStack{
                    GeometryReader{ geometry in
                        Text(image)
                            .font(.system(size: 0.5*geometry.size.width))
                    }
                        
                    //Spacer allows icons to be aligned to left and right side
                    Spacer()
                    VStack{
                        Text(record.cityName)
                        Text("\(record.showing) : \(record.value,  specifier: "%.2f")")
                            .font(.caption)
                            .onTapGesture {
                                //changing variable
                                viewModel.change(record: record)
                            }
                        
                    }.layoutPriority(100)
                    Spacer()
                    Text("🔄")
                        .font(.largeTitle)
                        .onTapGesture {
                            viewModel.refresh(record: record)
                        }
                }.frame(width: 250)
            }.frame(height: 70)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel())
    }
}
