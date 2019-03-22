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

    // MARK: Constants
    
    final var WHEEL_CIRCUM = 59.4 //inches
    
    // MARK: Data
    
    weak var delegate: DataManagerDelegate?
//    fileprivate var prevBMSData: String?
//    fileprivate var prevGPSData: String?
//    fileprivate var wheelTruncatedTimeStamp: String?
    fileprivate var unparseable: String = ""
    
    var runData: RunData = RunData()
    var lapData: LapData = LapData()
    
    let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateStyle = .full
        testParseClumped()
    }
    
}

// MARK: - Run and Lap Data
extension DataManager {
    
    // MARK: Run Info
    
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
    
    // MARK: Lap Info
    
    func getLapID() -> Int {
        return lapData.lapNo
    }

    func getLapIDStr() -> String{
        return String(lapData.lapNo)
    }
    
    func incrementLapNo() {
        lapData.lapNo += 1
    }
    
    func setRunID(id: Int) {
        runData.runID = id
    }
    
    func setRunName(name: String) {
        runData.runName = name
    }
}

// MARK: - Test
extension DataManager {
    
    func testParseClumped() {
        unparseable = "94774g;4226.6191N04628.9844W184.1_1234567g;none_1234567w;0_95840b;C2134_T50_P90_1234567b;C2134_T50"
        parseClumped()
    }
}

// MARK: - Data Parsing
extension DataManager {
    
    func parseRawData(data: String) {
        unparseable = unparseable + data
        parseClumped()
    }
    
    func parseClumped() {
        
        let dataArray = unparseable.components(separatedBy: ";")
        guard (dataArray.count >= 3) else { // unparseable datastring not long enough
            print("unparseable is \(unparseable)")
            return
        }
        guard let firstSemiIndex = unparseable.firstIndex(of: ";") else { return }
        let start = firstSemiIndex.encodedOffset - 1
        guard let secondSemiIndex = unparseable.substring(from: firstSemiIndex).dropFirst().firstIndex(of: ";") else { return }
        let end = secondSemiIndex.encodedOffset - 2 + firstSemiIndex.encodedOffset + 1 // index of last char of the first coherent data string in unparseable
//        let beforeEnd = end + 1
//        let beforeEndIndex = unparseable.index(unparseable.startIndex, offsetBy: end + 1)
        
        let data = unparseable[start..<end]
        unparseable = unparseable.substring(from: end)
        print("the data is \(data)")
        print("the new unparseable is \(unparseable)")
        parseCorrectedData(data: data)
        
        parseClumped()
    }
    
    func parseCorrectedData(data: String) {
        // assume it follows format
        print("raw data is \(data)")

        let dataArray = data.components(separatedBy: ";")
        
        // assert that data is _;_
        guard dataArray.count == 2 else {
//            if (data.first == "g") {
//                guard let GPSData = prevGPSData else { return }
//                prevGPSData = nil
//                parseGPSData(GPSData: GPSData, GPSSecData: String(data.dropFirst()))
//            }
            return
        }
        
        // parse data
        let dataType = dataArray[0]
        let dataValue = dataArray[1]
        
        switch dataType {
        case "b":
            parseBMSData(BMSData: dataValue)
            break
        case "w":
            parseWheelData(wheelData: dataValue)
            break
        case "g":
            parseGPSData(GPSData: dataValue)
            break
        
        default:
            break
//            print("error in parsing data")
//            print("the unparsable data is \(data)")
            
        }
        
    }
    
    fileprivate func parseBMSData(BMSData: String) {
//        print("parsing BMS Data: \(BMSData)")
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
        
         print("capacityRemaining is \(capacityRemaining), peakTemperature is \(peakTemperature), powerConsumption is \(powerConsumption)")
        
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
    fileprivate func parseGPSData(GPSData: String) {

        let GPSdataArray = GPSData.components(separatedBy: "_")
        
        guard (GPSdataArray.count == 2) else {
            print("GPSData corrupted: \(GPSData)")
            return
        }
        
        let gps = GPSdataArray[0]
        guard let NIndex = gps.firstIndex(of: "N")?.encodedOffset else { return }
        guard let WIndex = gps.firstIndex(of: "W")?.encodedOffset else { return }
        let afterNIndex = NIndex + 1
        let afterWIndex = WIndex + 1
        
        
        let lat = gps.substring(to: NIndex)
        let long = gps[afterNIndex..<afterWIndex]
        let alt = gps.substring(from: afterWIndex)
        let time = String(Int(NSDate().timeIntervalSince1970))

        print("lat is \(lat), long is \(long), alt is \(alt)")
        delegate?.updateGPS(lat: lat, long: long, alt: alt, time: time)
        
    }
}


