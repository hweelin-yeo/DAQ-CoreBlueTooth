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
    fileprivate var prevWheelDataString: String?
    fileprivate var wheelTruncatedTimeStamp: String?
    

    
    func parseRawData(data: String) {
        // assume it follows format
        let dataArray = data.components(separatedBy: ";")
        
        // when wheel data gets truncated
        guard (dataArray.count > 1) else {
            
            guard Int(data) != nil else { return }
            wheelTruncatedTimeStamp = data
            
            return
        }
        
        // data clumping, e.g. gps clumps with wheel
        guard (dataArray.count == 2) else {
            
            if (dataArray.count == 3) {
                
                guard let secSemiColonIndex = data.lastIndex(of: ";")?.encodedOffset else { return }


                let dataStringOne = data.prefix(secSemiColonIndex - 1)
                
                parseRawData(data: String(dataStringOne))

                let stringLength = data.count
                prevWheelDataString = String(data.suffix(stringLength - (secSemiColonIndex - 1)))
                
                guard let prevWheel = prevWheelDataString, let wheelTime = wheelTruncatedTimeStamp else { return }
                
                parseRawData(data: prevWheel + wheelTime)


            }
            
            return
        }
        
        let dataType = dataArray[0]
        let dataValue = dataArray[1]
        
        switch dataType {
        case "b":
            parseBMSData(BMSData: dataValue)
            break
        case "w":
            parseWheelData(wheelData: dataValue)
            break
        case "gps":
            parseGPSData(GPSData: dataValue)
            break
        
        default:
            print("error in parsing data")
            print("the unparsable data is \(data)")
            
        }
        
    }
    
    fileprivate func parseBMSData(BMSData: String) {
        print("parsing BMS Data: \(BMSData)")
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
        print("parsing wheel Data: \(wheelData)")
        let dataArray = wheelData.components(separatedBy: "_")
        
        guard (dataArray.count == 2) else {
            print("Wheel Data corrupted: \(wheelData)")
            return
        }
        
//        let revolution = dataArray[0]
//        let time = dataArray[1]
        
    }
    fileprivate func parseGPSData(GPSData: String) {
        print("parsing gps data: \(GPSData)")
    }
}


