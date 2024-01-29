//
//  MyPetInvttCreateResponse.swift
//  PetTip
//
//  Created by carebiz on 1/5/24.
//

import Foundation

struct MyPetInvttCreateResponse: Codable {
    let data: MyPetInvttCreateData
    let statusCode: Int
    let detailMessage: JSONNull?
    let resultMessage: String
    let resHeaders: JSONNull?
}

// MARK: - DataClass
struct MyPetInvttCreateData: Codable {
    let regPsbltyEndDt, invttKeyVl, regPsbltyBgngDt: String
}
