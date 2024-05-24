//
//  MyPetInvttCreate.swift
//  PetTip
//
//  Created by carebiz on 1/5/24.
//

import Foundation

// MARK: - Datum
struct PetInvtt: Codable {
    let ownrPetUnqNo, petNm: String
    // let petRelUnqNo: Int
    // let petRprsImgAddr, petTypCd: String?
    // let age, petKindNm, sexTypNm: String
    // let wghtVl: Double
}

// struct MyPetInvttCreateRequest: Encodable {
//     let pet: [Pet]
//     let relBgngDt: String
//     let relEndDt: String
// }

struct MyPetInvttCreateRequest: Encodable {
    let pet: [PetInvtt]
    let relBgngDt: String
    let relEndDt: String
}

