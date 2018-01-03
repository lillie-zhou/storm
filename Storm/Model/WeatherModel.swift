//
//  WeatherModel.swift
//  Storm
//
//  Created by Lillie Zhou on 1/2/18.
//  Copyright © 2018 Lillie Zhou. All rights reserved.
//

import Foundation

class WeatherModel {
    var city: String?
    var icon: String?
    var description: String?
    var temperature: Int?
    
    func updateWeatherIcon(condition: Int) -> String {
        switch (condition) {
            
        case 0...300:
            return "⚡️"
            
        case 301...500:
            return "🌧"
            
        case 501...600:
            return "☔️"
            
        case 601...700:
            return "🌨"
            
        case 701...771:
            return "🌫"
            
        case 772...799:
            return "⚡️"
            
        case 800:
            return "☀️"
            
        case 801...804:
            return "🌥"
            
        case 900...903, 905...1000:
            return "⛈"
            
        case 903:
            return "❄️"
            
        case 904:
            return "☀️"
            
        default:
            return "N/A"
        }
    }
}
