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

protocol DataManagerDelegate: class {
    func updateBMSUI()
}

final class DataManager {
    
    weak var delegate: DataManagerDelegate?
    
    func parseRawData(data: String) {
        // assume it follows format
        let dataArray = data.components(separatedBy: ";")
        guard (dataArray.count > 1) else {
            return
        }
        
        let dataType = dataArray[0]
        let dataValue = dataArray[1]
        
        switch dataType {
        case "bms":
            parseBMSData(BMSData: dataValue)
            break
        case "wheel":
            parseWheelData(wheelData: dataValue)
            break
        case "gps":
            parseGPSData(GPSData: dataValue)
            break
        
        default:
            print("error in parsing data")
            print(data)
            
        }
        
    }
    
    fileprivate func parseBMSData(BMSData: String) {
        print("parsing BMS Data")
        let dataArray = BMSData.components(separatedBy: "_")
        
        guard (dataArray.count == 4) else {
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
        
//        let capacityRemaining = dataArray[0].dropFirst()
//        let peakTemperature = dataArray[1].dropFirst()
//        let powerConsumption = dataArray[2].dropFirst()
//        let time = dataArray[3]
        
    }
    
    fileprivate func parseWheelData(wheelData: String) {
        print("parsing wheel Data")
        let dataArray = wheelData.components(separatedBy: "_")
        
        guard (dataArray.count == 2) else {
            print("BMSData corrupted: \(wheelData)")
            return
        }
        
//        let revolution = dataArray[0]
//        let time = dataArray[1]
        
    }
    fileprivate func parseGPSData(GPSData: String) {
        
    }
}


