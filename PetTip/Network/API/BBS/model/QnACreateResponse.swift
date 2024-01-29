//
//  QnACreateResponse.swift
//  PetTip
//
//  Created by carebiz on 1/13/24.
//

import Foundation

struct QnACreateResponse: Codable {
    let data: String?
    let statusCode: Int
    let detailMessage: String?
    let resultMessage: String
    let resHeaders: String?
}
