//
//  WidgetView.swift
//  WidgetExtension
//
//  Created by Himanshu Matharu on 2022-08-08.
//

import SwiftUI
import WidgetKit

struct WidgetView: View{
    let weather: WeatherModel
    let widgetUrl: URL?
    
    var body: some View{
        ZStack{
            Color(UIColor(named: "WidgetBackground") ?? .white)
            HStack(alignment: .center, spacing: nil) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(weather.cityName.uppercased()).font(.system(size: 12.0))
                    Text(String(format: "%.0f",weather.tempNow)).font(.custom("HelveticaNeue-Bold", size: 50.0))
                    Text(weather.description.uppercased()).font(.system(size: 12.0))
                }
                .foregroundColor(.white)
                .padding([.top,.bottom])
                .padding([.trailing,.leading],20)
                Spacer()
            }
        }
        .widgetURL(widgetUrl)
    }
}

struct WidgetEntryView: View{
    var entry: WidgetTimelineProvider.Entry
    
    var body: some View{
        WidgetView(weather: entry.weather, widgetUrl: entry.widgetUrl)
    }
}
