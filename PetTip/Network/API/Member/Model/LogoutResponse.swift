//
//  LogoutResponse.swift
//  PetTip
//
//  Created by carebiz on 1/18/24.
//

import Foundation

struct LogoutResponse: Codable {
    let data: String?
    let statusCode: Int
    let resultMessage, detailMessage: String?
}
