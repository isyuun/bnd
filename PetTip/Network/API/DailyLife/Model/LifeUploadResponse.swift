//
//  LifeUploadResponse.swift
//  PetTip
//
//  Created by carebiz on 1/21/24.
//

import Foundation

struct LifeUploadResponse: Codable {
    let data: [PhotoData]
    let statusCode: Int
    let detailMessage, resultMessage, resHeaders: String?
}

// MARK: - PhotoData
//struct PhotoData: Codable {
//    let flmPstnLat: String?
//    let filePathNm: String
//    let flmPstnLot: String?
//    let orgnlAtchFileNm, atchFileNm: String
//    let atchFileSz: Int
//    let fileExtnNm: String
//}
