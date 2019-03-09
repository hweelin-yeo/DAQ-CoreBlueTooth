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
                        let apiResponse = try JSONDecoder().decode(getRunIDAPIResponse.self, from: responseData)
                            completion(String(apiResponse.runID), nil)
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                    
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func startRun(time: String, id: String, name: String, completion: @escaping (_ res: String?, _ error: String?) ->()) {
        
        router.request(.startRun(time: time, id: id, name: name)) { data, response, error in
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
                        print(responseData)
                    
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func endRun(time: String, id: String, name: String) {
        
        router.request(.endRun(time: time, id: id, name: name)) { data, response, error in
            if error != nil {
                print("Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    print("success at ending run")
                    
                case .failure(let networkFailureError):
                    print ("failure at ending run with error \(networkFailureError)")
                }
            }
        }
    }
    
    func startLap(time: String, id: String, name: String, lapID: String) {
        
        router.request(.startLap(time: time, id: id, name: name, lapID: lapID)) { data, response, error in
            if error != nil {
                print("Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    print("success at starting run")
                    
                case .failure(let networkFailureError):
                    print ("failure at starting run with error \(networkFailureError)")
                }
            }
        }
    }
    
    func endLap(time: String, id: String, name: String, lapID: String) {
        
        router.request(.endLap(time: time, id: id, name: name, lapID: lapID)) { data, response, error in
            if error != nil {
                print("Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    print("success at ending lap")
                    
                case .failure(let networkFailureError):
                    print ("failure at ending lap with error \(networkFailureError)")
                }
            }
        }
    }
    
    func updateBMS(time: String, batLvl: String, batTemp: String, powerCons: String) {
        
        router.request(.updateBMS(time: time, batLvl: batLvl, batTemp: batTemp, powerCons: powerCons)) { data, response, error in
            if error != nil {
                print("Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    print("success at updating bms")
                    
                case .failure(let networkFailureError):
                    print ("failure at updating bms with error \(networkFailureError)")
                }
            }
        }
    }
    
    func updateGPS(time: String, lat: String, long: String) {
        
        router.request(.updateGPS(time: time, lat: lat, long: long)) { data, response, error in
            if error != nil {
                print("Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    print("success at updating gps")
                    
                case .failure(let networkFailureError):
                    print ("failure at updating gps with error \(networkFailureError)")
                }
            }
        }
    }
    
    func updateWheel(time: String, rpm: String) {
        
        router.request(.updateWheel(time: time, rpm: rpm) { data, response, error in
            if error != nil {
                print("Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    print("success at updating wheel")
                    
                case .failure(let networkFailureError):
                    print ("failure at updating wheel with error \(networkFailureError)")
                }
            }
        }
    }
    
}
