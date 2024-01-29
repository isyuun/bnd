//
//  QnACreateRequest.swift
//  PetTip
//
//  Created by carebiz on 1/13/24.
//

import Foundation

struct QnACreateRequest: Encodable {
    let bbsSn: Int
    let files: [PhotoData]
    let pstCn: String
    let pstSeCd: String
    let pstTtl: String
}
