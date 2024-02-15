//
//  TrmnlMngResponse.swift
//  PetTip
//
//  Created by carebiz on 2/15/24.
//

import Foundation

struct TrmnlMngResponse: Codable {
    let data: String?
    let statusCode: Int
    let detailMessage, resultMessage, resHeaders: String?
}
