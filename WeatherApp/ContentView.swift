//
//  ContentView.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 06/05/2021.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel: WeatherViewModel

    var body: some View {
        VStack{
    
            ForEach(viewModel.records){ rec in
                if(rec.weatherState == "clear"){
                    WeatherRecordView(record: rec, viewModel: viewModel, image: "☀️")
                    
                }else{
                    WeatherRecordView(record: rec, viewModel: viewModel, image: "⛈")                }
                
            
            }
        }.padding()
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
                Text(image)
                    .font(.largeTitle)
                VStack{
                    Text(record.cityName)
                    Text("Temperature: \(record.temperature, specifier: "%.2f")℃")
                        .font(.caption)
                }
                Text("🔄")
                    .font(.largeTitle)
                    .onTapGesture {
                        viewModel.refresh(record: record)
                    }
            }
}    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel())
    }
}
