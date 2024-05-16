//
//  PetList.swift
//  PetTip
//
//  Created by carebiz on 12/10/23.
//

import Foundation

// struct PetList {
//     var _pets: [Pet]
// 
//     var pets: [Pet]
//     {
//         get {
//             self._pets
//         } set(pets) {
//             self._pets = pets
//         }
//     }
// }
class PetList {
    private var _pets: [Pet]

    var pets: [Pet] {
        get {
            return _pets
        } set {
            _pets = newValue
        }
    }

    init(pets: [Pet]) {
        self._pets = pets
    }
}
