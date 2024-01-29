//
//  MyPetCreateResponse.swift
//  PetTip
//
//  Created by carebiz on 1/8/24.
//

import Foundation

struct MyPetCreateResponse: Codable {
    let data: String?
    let statusCode: Int
    let detailMessage: String?
    let resultMessage: String
    let resHeaders: JSONNull?
}
