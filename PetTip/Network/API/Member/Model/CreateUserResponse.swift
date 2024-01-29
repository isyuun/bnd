//
//  CreateUserResponse.swift
//  PetTip
//
//  Created by carebiz on 1/18/24.
//

import Foundation

struct CreateUserResponse: Codable {
    let data: CreateUserData?
    let statusCode: Int
    let detailMessage, resultMessage, resHeaders: String?
}

// MARK: - CreateUserData
struct CreateUserData: Codable {
    let status: Bool
    let message: String
    let failReason: JSONNull?
    let userID, ncknm: String
}
