//
//  EndPointType.swift
//  RR18_BlueToothProj
//
//  Created by Yeo Hwee Lin on 3/2/19.
//  Copyright © 2019 Yeo Hwee Lin. All rights reserved.
//  Credits: https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

public enum api {
    case startRun
    case endRun
    case startLap
    case endLap
    case getRunID
}

extension api: EndPointType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://obscure-plateau-15593.herokuapp.com/") else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .startRun:
            return "startRun"
        case .endRun:
            return "endRun"
        case .startLap:
            return "startLap"
        case .endLap:
            return "endLap"
        case .getRunID:
            return "getRunID"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .startRun:
            return .post
        case .endRun:
            return .post
        case .startLap:
            return .post
        case .endLap:
            return .post
        case .getRunID:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getRunID():
            return .request
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
}

