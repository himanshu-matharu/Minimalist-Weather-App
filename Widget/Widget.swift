//
//  Widget.swift
//  Widget
//
//  Created by Himanshu Matharu on 2022-08-08.
//

import WidgetKit
import SwiftUI

@main
struct MinimalistWeatherWidget: Widget{
    private let kind: String = "Widget"
    var body: some WidgetConfiguration{
        IntentConfiguration(kind: kind, intent: SelectCityIntent.self, provider: WidgetTimelineProvider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Minimalist Weather Widget")
        .description("Display the current weather of a location.")
        .supportedFamilies([.systemSmall])
    }
}

struct WeatherWidget_Previews: PreviewProvider{
    static var previews: some View{
        WidgetEntryView(entry: WidgetEntry(date: Date(), weather: WeatherModel(cityName: "Paris", tempNow: 26, tempLow: 23, tempHigh: 29, description: "Clear Sky"), widgetUrl: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
