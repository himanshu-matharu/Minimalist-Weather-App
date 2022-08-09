//
//  WidgetEntry.swift
//  WidgetExtension
//
//  Created by Himanshu Matharu on 2022-08-08.
//

import WidgetKit

struct WidgetEntry: TimelineEntry{
    let date: Date
    let weather: WeatherModel
    let widgetUrl: URL?
}
