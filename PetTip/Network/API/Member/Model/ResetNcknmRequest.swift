//
//  ResetNcknmRequest.swift
//  PetTip
//
//  Created by carebiz on 1/3/24.
//

import Foundation

/*
{
  "ncknm": "바둑12",
  "userID": "12d3eff6-b780-4920-9bf2-f423048b836a"
}
*/

struct ResetNcknmRequest: Encodable {
    let ncknm: String
    let userID: String
}
