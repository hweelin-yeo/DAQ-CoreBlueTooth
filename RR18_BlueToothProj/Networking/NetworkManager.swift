//
//  NetworkManager.swift
//  RR18_BlueToothProj
//
//  Created by Yeo Hwee Lin on 3/2/19.
//  Copyright © 2019 Yeo Hwee Lin. All rights reserved.
//

import Foundation

struct NetworkManager {
    private let router = Router<api>()
    
    enum NetworkResponse: String {
        case success
        case authenticationError = "You need to be authenticated"
        case badRequest = "Bad Request"
        case outdated = "URL is outdated"
        case failed = "Network request failed"
        case noData = "Response returned with no data to decode"
        case unableToDecode = "We could not decpde the response"
    }
    
    enum Result<String> {
        case success
        case failure(String)
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    func getLatestRunID(completion: @escaping (_ runID: String?, _ error: String?) ->()) {
        router.request(.getRunID) { data, response, error in
            if error != nil {
                completion (nil, "Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
//                        let apiResponse = try JSONDecoder
                            completion(responseData.base64EncodedString(), nil)
                    }
                    
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
}
