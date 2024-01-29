//
//  MyAuthenticator.swift
//  PetTip
//
//  Created by carebiz on 12/10/23.
//

import Foundation
import Alamofire

class MyAuthenticator: Authenticator {
    typealias Credential = MyAuthenticationCredential

    func apply(_ credential: Credential, to urlRequest: inout URLRequest) {
//        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
        urlRequest.headers.add(.authorization(credential.accessToken))
        urlRequest.addValue(credential.refreshToken, forHTTPHeaderField: "refresh-token")
    }

    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {
        return response.statusCode == 401
    }

    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: Credential) -> Bool {
//        let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
        let bearerToken = HTTPHeader.authorization(credential.accessToken).value
        return urlRequest.headers["Authorization"] == bearerToken
    }

    func refresh(_ credential: Credential, for session: Session, completion: @escaping (Result<Credential, Error>) -> Void) {
        
        
        
        let request = RefreshTokenRequest(refreshToken: UserDefaults.standard.value(forKey: "refreshToken")! as! String)
        MemberAPI.refreshToken(request: request) { refreshToken, error in
            if let refreshToken = refreshToken {
                let userDef = UserDefaults.standard
                userDef.set(refreshToken.accessToken, forKey: "accessToken")
                userDef.set(refreshToken.refreshToken, forKey: "refreshToken")
                userDef.synchronize()
                
                let newCredential = MyAuthenticationCredential(accessToken: UserDefaults.standard.value(forKey: "accessToken") as! String,
                                                            refreshToken: UserDefaults.standard.value(forKey: "refreshToken") as! String)
//                KeychainServiceImpl.shared.accessToken = refreshToken.accessToken
//                KeychainServiceImpl.shared.refreshToken = refreshToken.refreshToken
                completion(.success(newCredential))
            }
            
            if let error = error {
                completion(.failure(error))
            }
        }
    }
}
