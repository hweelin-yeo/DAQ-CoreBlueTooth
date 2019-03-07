//
//  DataManager.swift
//  RR18_BlueToothProj
//
//  Created by Yeo Hwee Lin on 11/17/18.
//  Copyright © 2018 Yeo Hwee Lin. All rights reserved.
//

import Foundation

struct BMSData {
    
}

struct OtherData {
    
}

struct runID {
    var runID = 1;
//    if (endLap is posted){
//        runID += 1;
//    }
    
}

protocol DataManagerDelegate: class {
    func updateBMSUI()
}

final class DataManager {
    
    
    weak var delegate: DataManagerDelegate?
    fileprivate var prevBMSData: String?
    fileprivate var prevGPSData: String?
    fileprivate var wheelTruncatedTimeStamp: String?
    

    
    func parseRawData(data: String) {
        // assume it follows format
        print("raw data is \(data)")
        let dataArray = data.components(separatedBy: ";")
        
        // assert that data is _;_ else it may be secondary gps string
        guard dataArray.count > 2 else {
            if (data.first == "g") {
                guard let GPSData = prevGPSData else { return }
                prevGPSData = nil
                parseGPSData(GPSData: GPSData, GPSSecData: String(data.dropFirst()))
            }
            return
        }
        
        // parse data
        let dataType = dataArray[0]
        let dataValue = dataArray[1]
        
        switch dataType {
        case "b":
            prevBMSData = dataValue
            break
        case "bt":
            guard let bmsData = prevBMSData else { return }
            prevBMSData = nil
            parseBMSData(BMSData: bmsData, BMSTime: dataValue)
            break
        case "w":
            parseWheelData(wheelData: dataValue)
            break
        case "g1":
            prevGPSData = dataValue
            break
        
        default:
            print("error in parsing data")
            print("the unparsable data is \(data)")
            
        }
        
    }
    
    fileprivate func parseBMSData(BMSData: String, BMSTime: String) {
        print("parsing BMS Data: \(BMSData)")
        let dataArray = BMSData.components(separatedBy: "_")
        
        guard (dataArray.count == 3) else {
            print("BMSData corrupted: \(BMSData)")
            return
        }
        
        guard dataArray[0].first == "C" else {
            print("BMSData corrupted at 'C': \(BMSData)")
            return
        }
        
        guard dataArray[1].first == "T" else {
            print("BMSData corrupted at 'C': \(BMSData)")
            return
        }
        
        guard dataArray[2].first == "P" else {
            print("BMSData corrupted at 'C': \(BMSData)")
            return
        }
        
        let capacityRemaining = dataArray[0].dropFirst()
        let peakTemperature = dataArray[1].dropFirst()
        let powerConsumption = dataArray[2].dropFirst()
        let time = BMSTime
        
        
        
    }
    
    fileprivate func parseWheelData(wheelData: String) {
        print("parsing wheel Data: \(wheelData)")
        let dataArray = wheelData.components(separatedBy: "_")
        
        guard (dataArray.count == 2) else {
            print("Wheel Data corrupted: \(wheelData)")
            return
        }
        
//        let revolution = dataArray[0]
//        let time = dataArray[1]
        
    }
    fileprivate func parseGPSData(GPSData: String, GPSSecData: String) {
        print("parsing gps data: \(GPSData)")
    }
}


