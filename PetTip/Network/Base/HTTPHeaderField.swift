//
//  HTTPHeaderField.swift
//  PetTip
//
//  Created by carebiz on 12/10/23.
//

import Foundation

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
}

enum ContentType: String {
    case json = "Application/json"
}
