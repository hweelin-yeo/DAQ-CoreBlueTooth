//
//  NetworkRequestManager.swift
//  RR18_BlueToothProj
//
//  Created by Yeo Hwee Lin on 1/4/19.
//  Copyright © 2019 Yeo Hwee Lin. All rights reserved.
//

import Foundation
import Alamofire

struct response {
    var responseString: String?
}

protocol NetworkRequestHandlerDelegate {
    
    func handleFetchedData(response: String)
    
}

struct NetworkRequestManager {
    
    var baseUrl = "https://obscure-plateau-15593.herokuapp.com/"
    var delegate: NetworkRequestHandlerDelegate?
    
    func makeGetRequest(url: String) {
        Alamofire.request(url, method: .get)
            .responseData { response in
                // check for errors
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET")
                    print(response.result.error!)
                    return
                }
            }
            
            .responseString { response in
                if let error = response.result.error {
                    print(error)
                }
                if let value = response.result.value {
                    self.delegate?.handleFetchedData(response: value)
                }
        }
    }
    
    func makeGetRequestWithParameters(url: String, parameters: [String: String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters)
            .responseData { response in
                // check for errors
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET")
                    print(response.result.error!)
                    return
                }
            }
            
            .responseString { response in
                if let error = response.result.error {
                    print(error)
                }
                if let value = response.result.value {
                   self.delegate?.handleFetchedData(response: value)
                }
        }
    }
    
    func makePostRequest(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .post, parameters: parameters,
                          encoding: JSONEncoding.default)
            .responseData { response in
                // check for errors
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET")
                    print(response.result.error!)
                    return
                }
            }
            
            .responseString { response in
                if let error = response.result.error {
                    print(error)
                }
                if let value = response.result.value {
                    self.delegate?.handleFetchedData(response: value)
                }
        }
    }
}




