//
//  MyPetList.swift
//  PetTip
//
//  Created by carebiz on 12/10/23.
//

import Foundation

// struct MyPetList {1
//     var _myPets: [MyPet]
// 
//     var myPets: [MyPet]
//     {
//         get {
//             self._myPets
//         } set(myPets) {
//             self._myPets = myPets
//         }
//     }
// }
class MyPetList {
    private var _myPets: [MyPet]

    var myPets: [MyPet] {
        get {
            return _myPets
        } set {
            _myPets = newValue
        }
    }

    init(myPets: [MyPet]) {
        self._myPets = myPets
    }
}
