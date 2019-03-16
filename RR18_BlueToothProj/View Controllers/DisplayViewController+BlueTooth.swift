//
//  ViewController.swift
//  RR18_BlueToothProj
//
//  Created by Yeo Hwee Lin on 10/6/18.
//  Copyright © 2018 Yeo Hwee Lin. All rights reserved.
//

import UIKit
import SCLAlertView
import CoreBluetooth

// MARK: - DataManagerDelegate
extension DisplayViewController: DataManagerDelegate {
    func updateWheel(rev: String, time: String) {
        // diameter of wheel = 0.5m
        let circumference = (Double.pi * 0.5) * 3.28084
        guard let intRev = Int(rev) else { return }
        let speed = round(circumference * Double(intRev) / 88)
        
        sNum.text = String(speed)
        //later update using gps
        networkManager.updateWheel(time: rev, rpm: time)
    }
    
    func updateGPS(lat: String, long: String, alt: String, time: String) {
        networkManager.updateGPS(time: time, lat: lat, long: long)
    }
    
    func updateBMS(capRem: String, peakTemp: String, powerConsump: String, time: String) {
        networkManager.updateBMS(time: time, batLvl: capRem, batTemp: peakTemp, powerCons: powerConsump)
    }
    
    
    func setupDataManager() {
        dataManager.delegate = self
    }
}

// MARK: - CBCentralManagerDelegate
extension DisplayViewController: CBCentralManagerDelegate {
    
    func checkIfAlreadyPoweredOn() {
        let central = bluetoothManager.sharedCentralManager
        
        if (central.state == .poweredOn) {
            print("Bluetooth status is already SWITCHED ON")
            central.scanForPeripherals(withServices: [bluetoothManager.bleUUID], options: nil)
            
            DispatchQueue.main.async { () -> Void in
                self.bluetoothOnView.backgroundColor = .green
            }
            
        } else {
            DispatchQueue.main.async { () -> Void in
                SCLAlertView().showInfo("Important info", subTitle: "Switch on BlueTooth!")
            }
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            
        case .poweredOn:
            print("Bluetooth status is SWITCHED ON")
            central.scanForPeripherals(withServices: [bluetoothManager.bleUUID], options: nil)
            
            DispatchQueue.main.async { () -> Void in
                self.bluetoothOnView.backgroundColor = .green
            }
            
        default:
            
            DispatchQueue.main.async { () -> Void in
                self.bluetoothOnView.backgroundColor = .red
                self.peripheralView.backgroundColor = .red
                
                SCLAlertView().showInfo("Important info", subTitle: "Switch on BlueTooth!")
                return;
            }
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if (peripheral.name == bluetoothManager.bleName) {
            
            bluetoothManager.addPeripheral(peripheral: peripheral)
            bluetoothManager.setPeripheralDelegate(delegate: self)
            
            bluetoothManager.sharedCentralManager.stopScan()
            bluetoothManager.sharedCentralManager.connect(peripheral)
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        DispatchQueue.main.async { () -> Void in
            self.peripheralView.backgroundColor = .green
        }
        
        peripheral.discoverServices(nil)
    }
    
    // STEP 15: when a peripheral disconnects, take
    // use-case-appropriate action
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected!")
        
        
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        guard error != nil else { return }
        SCLAlertView().showInfo("Error", subTitle: "Failed to connect with bluefruit")
    }
    
}

// MARK: - CBPeripheralDelegate
extension DisplayViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        guard let services = peripheral.services else { return }
        
        services.forEach({ (service) in
            if (service.uuid == bluetoothManager.bleUUID) {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        })
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            
            // uuid for bluefruit's data characteristic
            if characteristic.uuid.uuidString == "6E400003-B5A3-F393-E0A9-E50E24DCCA9E" {
                peripheral.readValue(for: characteristic)
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        guard let err = error else { return }
        print(err)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        guard let value = characteristic.value else { return }
        
        guard let stringValue = String(data: value, encoding: String.Encoding.utf8) else { return }
        
        dataManager.parseRawData(data: stringValue)
        
        // TODO: updateUI
        // TODO: sendToServer
        
    }
    
}

// MARK: - Network Request Manager
extension DisplayViewController: NetworkRequestHandlerDelegate {
    
    func setupNetworkRequestManager() {
        networkRequestManager.delegate = self
    }
    
    func handleFetchedData(response: String) {
        
    }
    
    
    func testNetworkRequestData() {
        updateWheel(rev: "2394", time: "15323248239")
        
        updateGPS(lat: "4226.619N", long: "4623.874W", alt: "184.1", time: "12323456")
        
        updateBMS(capRem: "90", peakTemp: "50", powerConsump: "45", time: "23148727")
        
        updateWheel(rev: "2394", time: "1532482339")
        
        updateGPS(lat: "4226.619N", long: "4623.874W", alt: "184.1", time: "1234563")
        
        updateBMS(capRem: "90", peakTemp: "50", powerConsump: "65", time: "2314773")

        updateWheel(rev: "2394", time: "153248239")
        
        updateGPS(lat: "4226.619N", long: "4623.874W", alt: "184.1", time: "123456")
        
        updateBMS(capRem: "90", peakTemp: "50", powerConsump: "45", time: "231477")
    }
    
}
