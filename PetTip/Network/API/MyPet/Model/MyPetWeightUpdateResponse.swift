//
//  MyPetWeightUpdateResponse.swift
//  PetTip
//
//  Created by carebiz on 1/27/24.
//

import Foundation

struct MyPetWeightUpdateResponse: Codable {
    let data: String?
    let statusCode: Int
    let detailMessage: String?
    let resultMessage: String
    let resHeaders: JSONNull?
}
