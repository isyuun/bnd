//
//  WeatherResponse.swift
//  PetTip
//
//  Created by carebiz on 12/12/23.
//

import Foundation

struct WeatherResponse: Codable {
    let data: [WeatherData]
    let statusCode: Int
    let resultMessage: String
    let detailMessage: JSONNull?
}

struct WeatherData: Codable {
    let baseDate, baseTime, category, fcstDate: String
    let fcstTime, fcstValue, nx, ny: String
}

extension WeatherResponse {
    var toDomain: Weather {
        return Weather(items: data)
    }
}
