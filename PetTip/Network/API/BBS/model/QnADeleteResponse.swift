//
//  QnADeleteResponse.swift
//  PetTip
//
//  Created by carebiz on 1/12/24.
//

import Foundation

struct QnADeleteResponse: Codable {
    let data: String?
    let statusCode: Int
    let detailMessage: String?
    let resultMessage: String
    let resHeaders: String?
}
