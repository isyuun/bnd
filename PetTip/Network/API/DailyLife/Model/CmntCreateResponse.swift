//
//  CmntCreateResponse.swift
//  PetTip
//
//  Created by carebiz on 12/24/23.
//

import Foundation

struct CmntCreateResponse: Codable {
    let data: [CmntList]?
    let statusCode: Int
    let resultMessage: String
    let detailMessage: JSONNull?
}

extension CmntCreateResponse {
    var toDomain: CmntCreate {
        return CmntCreate(cmntList: data)
    }
}
