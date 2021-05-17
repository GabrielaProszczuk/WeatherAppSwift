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
                        (imageState[rec.weatherState]) == "💨" ||
                        (imageState[rec.weatherState]) == "🌨"){
                        
                        WeatherRecordView(record: rec, viewModel: viewModel, image: imageState[rec.weatherState]!)
                        
                    }
                    else{
                        //if state doesn't exist
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
                    //font and position are bind to size of window
                    GeometryReader{ geometry in
                        Text(image)
                            .font(.system(size: 0.4*geometry.size.height))
                            .position(x: geometry.size.width/4, y: geometry.size.height/2)
                       // Spacer()
                    }
 
                    
                    //Spacer()
                    VStack(alignment: .leading){
                        Text(record.cityName)
                        Text("\(record.showing) : \(record.value,  specifier: "%.2f") \(record.unit)")
                            .font(.caption)
                            .onTapGesture {
                                //changing variable
                                viewModel.change(record: record)
                            }
                        
                    }.layoutPriority(100)
                    Spacer()
                 
                    GeometryReader{ geometry in
                        Text("🔄")
                            .font(.system(size: 0.4*geometry.size.height))
                            .onTapGesture {
                                viewModel.refresh(record: record)
                            }
                        .position(x: geometry.size.width*0.75, y: geometry.size.height/2)
                    }
                    }
            }.frame(height: 70)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel())
    }
}
