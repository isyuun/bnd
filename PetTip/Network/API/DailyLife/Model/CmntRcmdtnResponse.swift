//
//  CmntRcmdtnResponse.swift
//  PetTip
//
//  Created by carebiz on 12/26/23.
//

import Foundation

struct CmntRcmdtnResponse: Codable {
    let data: [CmntList] //[CmntRcmdtnData]
    let statusCode: Int
    let resultMessage: String
    let detailMessage: JSONNull?
}

extension CmntRcmdtnResponse {
    var toDomain: CmntRcmdtn {
        return CmntRcmdtn(data: data)
    }
}
