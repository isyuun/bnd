//
//  RefreshTokenResponse.swift
//  PetTip
//
//  Created by carebiz on 12/10/23.
//

import Foundation

struct RefreshTokenResponse: Codable {
    let data: RefreshTokenDataClass
    let statusCode: Int
    let resultMessage, detailMessage: JSONNull?
}

// MARK: - DataClass
struct RefreshTokenDataClass: Codable {
    let status: Bool
    let message, failReason: JSONNull?
    let accessToken, refreshToken, userID, nckNm: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case status, message, failReason, accessToken, refreshToken
        case userID = "userId"
        case nckNm, email
    }
}

extension RefreshTokenResponse {
    var toDomain: RefreshToken {
        return RefreshToken(accessToken: data.accessToken, refreshToken: data.refreshToken)
    }
}

