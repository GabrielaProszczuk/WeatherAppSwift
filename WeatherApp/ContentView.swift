//
//  ContentView.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 06/05/2021.
//

import SwiftUI

struct SheetView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button("Press to dismiss") {
            presentationMode.wrappedValue.dismiss()
        }
        .font(.title)
        .padding()
        .background(Color.white)
    }
}

struct ContentView: View {

    @ObservedObject var viewModel: WeatherViewModel
    var imageState: [String: String] = [
                      "Clear": "☀️",
                      "Light Cloud":"🌤",
                      "Heavy Cloud":"☁️",
                      "Thunderstorm":"🌩",
                      "Showers":"🌦",
                      "Light Rain":"🌧",
                      "Heavy Rain":"⛈",
                      "Snow":"❄️",
                      "Sleet":"🌨",
                      "Hail":"💨"
        
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
    @State  var showingSheet = false
    var image: String
    let radius: CGFloat = 25.0
    let sizeRatio: CGFloat = 0.4
    let xDiv: CGFloat = 2
    let yDiv: CGFloat = 2
    let priority: Double = 100
    let widthRatio: CGFloat = 0.6
    let widthRatio2: CGFloat = 0.5
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
                                viewModel.refresh(city: record.woeId)
                            }
                        .position(x: geometry.size.width*widthRatio, y: geometry.size.height/yDiv)
                    }
                    GeometryReader{ geo in
                        Button("MAP") {
                            showingSheet.toggle()
                        }
                        .sheet(isPresented: $showingSheet) {
                            SheetView()
                        }
                        .position(x: geo.size.width*widthRatio2, y: geo.size.height/yDiv)
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
