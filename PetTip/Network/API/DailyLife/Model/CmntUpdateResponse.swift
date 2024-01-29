//
//  CmntUpdateResponse.swift
//  PetTip
//
//  Created by carebiz on 12/28/23.
//

import Foundation

struct CmntUpdateResponse: Codable {
    let data: [CmntList]
    let statusCode: Int
    let resultMessage: String
    let detailMessage: JSONNull?
}

extension CmntUpdateResponse {
    var toDomain: CmntUpdate {
        return CmntUpdate(data: data)
    }
}
