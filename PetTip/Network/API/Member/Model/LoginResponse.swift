//
//  LoginResponse.swift
//  PetTip
//
//  Created by carebiz on 12/10/23.
//

import Foundation

struct LoginResponse: Codable {
    let data: LoginDataClass
    let statusCode: Int
    let resultMessage, detailMessage: JSONNull?
}

// MARK: - DataClass
struct LoginDataClass: Codable {
    let status: Bool
    let message, failReason: JSONNull?
    let accessToken, refreshToken, tokenType, scope: String
    let userID, nckNm, email: String
    let appKeyVl: String?

    enum CodingKeys: String, CodingKey {
        case status, message, failReason, accessToken, refreshToken, tokenType, scope
        case userID = "userId"
        case nckNm, email, appKeyVl
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

extension LoginResponse {
    var toDomain: Login {
        return Login(userId: data.userID, nckNm: data.nckNm, email: data.email, accessToken: data.accessToken, refreshToken: data.refreshToken)
    }
}
