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
    case startRun(time: String, id: String, name: String)
    case endRun(time: String, id: String, name: String)
    case startLap(time: String, id: String, name: String, lapID: String)
    case endLap(time: String, id: String, name: String, lapID: String)
    case getRunID
    case updateBMS(time: String, batLvl: String, batTemp: String, powerCons: String)
    case updateWheel(time: String, rpm: String)
    case updateGPS(time: String, lat: String, long: String)
    
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
        case .updateBMS:
            return "updateBmsData"
        case .updateWheel:
            return "updateWheelData"
        case .updateGPS:
            return "updateGpsData"
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
        case .updateBMS:
            return .post
        case .updateWheel:
            return .post
        case .updateGPS:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getRunID:
            return .request
        case .startRun(let time, let id, let name):
            return .requestParameters(bodyParameters: ["timestamp": time,
                                                       "run_id": id,
                                                       "run_name": name], urlParameters: nil)
        case .startLap (let time, let id, let name, let lapID):
            return .requestParameters(bodyParameters: ["timestamp": time,
                                                       "run_id": id,
                                                       "run_name": name,
                                                       "lap_id": lapID], urlParameters: nil)
        case .endRun(let time, let id, let name):
            return .requestParameters(bodyParameters: ["timestamp": time,
                                                       "run_id": id,
                                                       "run_name": name], urlParameters: nil)
        case .endLap(let time, let id, let name, let lapID):
            return .requestParameters(bodyParameters: ["timestamp": time,
                                                       "run_id": id,
                                                       "run_name": name,
                                                       "lap_id": lapID], urlParameters: nil)
        case .updateBMS(let time, let batLvl, let batTemp, let powerCons):
            return .requestParameters(bodyParameters: ["timestamp": time,
                                                       "batt_lvl": batLvl,
                                                       "batt_temp": batTemp,
                                                       "power_consump": powerCons], urlParameters: nil)
        case .updateWheel(let time, let rpm):
            return .requestParameters(bodyParameters: ["timestamp": time,
                                                       "w_rpm": rpm], urlParameters: nil)
        case .updateGPS(let time, let lat, let long):
            return .requestParameters(bodyParameters: ["timestamp": time,
            "lat": lat,
            "long": long], urlParameters: nil)
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
}

