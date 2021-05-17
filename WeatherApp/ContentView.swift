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
    let radius: CGFloat = 25.0
    let sizeRatio: CGFloat = 0.4
    let xDiv: CGFloat = 4
    let yDiv: CGFloat = 2
    let priority: Double = 100
    let widthRatio: CGFloat = 0.75
    let height: CGFloat = 70
    var body: some View{

            ZStack{
                RoundedRectangle(cornerRadius: radius)
                    .stroke()
                HStack{
                    //font and position are bind to size of window
                    GeometryReader{ geometry in
                        Text(image)
                            .font(.system(size: sizeRatio*geometry.size.height))
                            .position(x: geometry.size.width/xDiv, y: geometry.size.height/yDiv)
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
                        
                    }.layoutPriority(priority)
                    Spacer()
                 
                    GeometryReader{ geometry in
                        Text("🔄")
                            .font(.system(size: sizeRatio*geometry.size.height))
                            .onTapGesture {
                                viewModel.refresh(record: record)
                            }
                        .position(x: geometry.size.width*widthRatio, y: geometry.size.height/yDiv)
                    }
                    }
            }.frame(height: height)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel())
    }
}
