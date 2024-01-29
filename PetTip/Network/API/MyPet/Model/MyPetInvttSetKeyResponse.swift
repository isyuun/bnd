//
//  MyPetInvttSetKeyResponse.swift
//  PetTip
//
//  Created by carebiz on 1/6/24.
//

import Foundation

struct MyPetInvttSetKeyResponse: Codable {
    let data: String?
    let statusCode: Int
    let detailMessage: String?
    let resultMessage: String
    let resHeaders: JSONNull?
}
