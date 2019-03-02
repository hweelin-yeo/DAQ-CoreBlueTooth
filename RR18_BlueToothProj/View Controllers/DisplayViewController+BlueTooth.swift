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
    func updateBMSUI() {
        // implement
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
 
        SCLAlertView().showInfo("Error", subTitle: "Bluefruit Disconnected")
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
    
    
    func testAlamofire() {
        networkRequestManager.makeGetRequest(url: "https://jsonplaceholder.typicode.com/posts/1")
        networkRequestManager.makePostRequest(url: "https://jsonplaceholder.typicode.com/posts", parameters: ["title" : "foo",
                                                                                                              "body" : "bar",
                                                                                                              "userId": "1 "])
    }
}

