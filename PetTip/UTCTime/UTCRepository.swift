//
//  UTCRepository.swift
//  PetTip
//
//  Created by carebiz on 11/22/23.
//

import Foundation

class UTCRepository {
    
    func fetchNow(onCompleted: @escaping (UTCTimeEntity) -> Void) {
        
        let url = "http://worldclockapi.com/api/json/utc/now"
        
        URLSession.shared.dataTask(with: URL(string: url)!) { data, _, _ in
            guard let data = data else { return }
            guard let entity = try? JSONDecoder().decode(UTCTimeEntity.self, from: data) else { return }
            onCompleted(entity)
        }.resume()
    }
}
