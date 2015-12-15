//
//  CurrentWeather.swift
//  Stormy
//
//  Created by Taylor Martin on 12/15/15.
//  Copyright © 2015 Taylor Martin. All rights reserved.
//

import Foundation

struct CurrentWeather {
    
    let temperature: Int
    let humidity: Int
    let precipProbability: Int
    let summary: String
    
    init(weatherDictionary: [String: AnyObject]) {
        temperature = weatherDictionary["temperature"] as! Int
        humidity = weatherDictionary["humidity"] as! Int
        precipProbability = weatherDictionary["precipProbability"] as! Int
        summary = weatherDictionary["summary"] as! String
    }
    
}