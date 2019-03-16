//
//  DataManager.swift
//  RR18_BlueToothProj
//
//  Created by Yeo Hwee Lin on 11/17/18.
//  Copyright © 2018 Yeo Hwee Lin. All rights reserved.
//

import Foundation

struct RunData {
    var runID: Int?
    var runName: String?
    
}

struct LapData{
    var lapNo = 0
}

protocol DataManagerDelegate: class {
    func updateWheel(rev: String, time: String)
    func updateGPS(lat: String, long: String, alt: String, time: String)
    func updateBMS(capRem: String, peakTemp: String, powerConsump: String, time: String)
}

final class DataManager {

    weak var delegate: DataManagerDelegate?
    fileprivate var prevBMSData: String?
    fileprivate var prevGPSData: String?
    fileprivate var wheelTruncatedTimeStamp: String?
    fileprivate var unparseable: String = ""
    
    var runData: RunData = RunData()
    var lapData: LapData = LapData()
    
    let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateStyle = .full
    }
    
    //get Run Info
    func getRunIDInt() -> Int?{
        guard let runID = runData.runID else { return nil }
        return runID
    }
    func getRunIDString() -> String? {
        guard let runID = runData.runID else { return nil }
        return String(runID)
    }
    func getRunName() -> String? {
        return runData.runName
    }
    
    //Lap Info
    func getLapID() -> Int {
        return lapData.lapNo
    }

    func getLapIDStr() -> String{
        return String(lapData.lapNo)
    }
    
    func incrementLapNo() {
        lapData.lapNo += 1
    }
    
    
    //setting functions
    func setRunID(id: Int) {
        runData.runID = id
    }
    
    func setRunName(name: String) {
        runData.runName = name
    }
    
    func parseClumped() {
        
        let dataArray = unparseable.components(separatedBy: ";")
        guard (dataArray.count > 3) else { return } // unparseable datastring not long enough
        guard let firstSemiIndex = unparseable.firstIndex(of: ";") else { return }
        let start = firstSemiIndex.encodedOffset - 1
        guard let secondSemiIndex = unparseable.substring(from: firstSemiIndex).dropFirst().firstIndex(of: ";") else { return }
        let end = secondSemiIndex.encodedOffset + 2
        let beforeEndIndex = str.index(str.startIndex, offsetBy: end - 1)
        
        let data = unparseable[start..<end]
        unparseable = unparseable[...beforeEndIndex]
        parseRawData(data: data)
        
        parseClumped()
    }
    
    func parseRawData(data: String) {
        // assume it follows format
        print("raw data is \(data)")
        print("the number of characters is \(data.count)")
        print("printing out the characters")
        for char in str { print("the character is \(char)") }
        print("stopped printing out the characters")

        let dataArray = data.components(separatedBy: ";")
        
        // assert that data is _;_ else it may be secondary gps string
        guard dataArray.count == 2 else {
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
            let timeInterval = String(Int(NSDate().timeIntervalSince1970))
            guard let bmsData = prevBMSData else { return }
            prevBMSData = nil
            parseBMSData(BMSData: bmsData, BMSTime: timeInterval)
            break
        case "w":
            parseWheelData(wheelData: dataValue)
            break
        case "g1":
            prevGPSData = dataValue
            break
        
        default:
            break
//            print("error in parsing data")
//            print("the unparsable data is \(data)")
            
        }
        
    }
    
    fileprivate func parseBMSData(BMSData: String, BMSTime: String) {
//        print("parsing BMS Data: \(BMSData)")
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
            print("BMSData corrupted at 'T': \(BMSData)")
            return
        }
        
        guard dataArray[2].first == "P" else {
            print("BMSData corrupted at 'P': \(BMSData)")
            return
        }
        
        let capacityRemaining = dataArray[0].dropFirst()
        let peakTemperature = dataArray[1].dropFirst()
        let powerConsumption = dataArray[2].dropFirst()
        let time = String(Int(NSDate().timeIntervalSince1970))
        
        delegate?.updateBMS(capRem: String(capacityRemaining), peakTemp: String(peakTemperature), powerConsump: String(powerConsumption), time: time)
        
        
    }
    
    fileprivate func parseWheelData(wheelData: String) {
//        print("parsing wheel Data: \(wheelData)")
        let dataArray = wheelData.components(separatedBy: "_")
        
        guard (dataArray.count == 2) else {
            print("Wheel Data corrupted: \(wheelData)")
            return
        }
        
        let revolution = dataArray[0]
        let time = dataArray[1]
        
        delegate?.updateWheel(rev: revolution, time: time)
    }
    fileprivate func parseGPSData(GPSData: String, GPSSecData: String) {
        let GPSdataArray = GPSData.components(separatedBy: ",")
        let GPSSecdataArray = GPSSecData.components(separatedBy: "_")
        
        guard (GPSdataArray.count == 2 && GPSSecData.count == 2) else {
            print("GPSData corrupted: \(GPSData)")
            return
        }
        
        let lat = GPSdataArray[0]
        let long = GPSSecdataArray[0]
        let alt = GPSdataArray[1]
        let time = String(Int(NSDate().timeIntervalSince1970))
        
        delegate?.updateGPS(lat: lat, long: long, alt: alt, time: time)
        
    }
}


