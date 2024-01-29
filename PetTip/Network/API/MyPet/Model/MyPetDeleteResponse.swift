//
//  MyPetDeleteResponse.swift
//  PetTip
//
//  Created by carebiz on 1/28/24.
//

import Foundation

struct MyPetDeleteResponse: Codable {
    let data: String?
    let statusCode: Int
    let detailMessage: String?
    let resultMessage: String
    let resHeaders: JSONNull?
}
