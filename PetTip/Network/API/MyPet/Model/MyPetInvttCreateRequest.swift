//
//  MyPetInvttCreate.swift
//  PetTip
//
//  Created by carebiz on 1/5/24.
//

import Foundation

// struct MyPetInvttCreateRequest: Encodable {
//     let pet: [Pet]
//     let relBgngDt: String
//     let relEndDt: String
// }

struct MyPetInvttCreateRequest: Encodable {
    let pet: [PetInfo]
    let relBgngDt: String
    let relEndDt: String
}

