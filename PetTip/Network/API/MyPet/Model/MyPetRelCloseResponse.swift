//
//  MyPetRelCloseResponse.swift
//  PetTip
//
//  Created by carebiz on 1/28/24.
//

import Foundation

struct MyPetRelCloseResponse: Codable {
    let data: String?
    let statusCode: Int
    let detailMessage: String?
    let resultMessage: String
    let resHeaders: JSONNull?
}
