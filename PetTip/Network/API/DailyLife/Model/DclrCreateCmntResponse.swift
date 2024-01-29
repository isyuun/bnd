//
//  DclrCreateCmntResponse.swift
//  PetTip
//
//  Created by carebiz on 12/29/23.
//

import Foundation

struct DclrCreateCmntResponse: Codable {
    let data: [CmntList]
    let statusCode: Int
    let resultMessage: String
    let detailMessage: JSONNull?
}

extension DclrCreateCmntResponse {
    var toDomain: DclrCreateCmnt {
        return DclrCreateCmnt(data: data)
    }
}
