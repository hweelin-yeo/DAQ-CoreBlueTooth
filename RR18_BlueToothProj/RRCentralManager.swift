//
//  RRCentralManager.swift
//  RR18_BlueToothProj
//
//  Created by Yeo Hwee Lin on 10/6/18.
//  Copyright © 2018 Yeo Hwee Lin. All rights reserved.
//

import UIKit
import CoreBluetooth

// Specify GATT "Assigned Numbers" as
// constants so they're readable and updatable

// MARK: - Core Bluetooth service IDs
// e.g. let BLE_Heart_Rate_Service_CBUUID = CBUUID(string: "0x180D")

// MARK: - Core Bluetooth characteristic IDs
// e.g. let BLE_Heart_Rate_Measurement_Characteristic_CBUUID = CBUUID(string: "0x2A37")
// e.g. let BLE_Body_Sensor_Location_Characteristic_CBUUID = CBUUID(string: "0x2A38")

struct RRCentralManager {
    
    var shared: CBCentralManager = CBCentralManager(delegate: nil,
                                                                  queue: DispatchQueue(label: "com.iosbrain.centralQueueName", attributes: .concurrent))
    
    var peripheralArray: [CBPeripheral] = []
    
    func setDelegate(delegate: CBCentralManagerDelegate) {
        sharedCentralManager.delegate = delegate
    }

    mutating func addPeripheral (peripheral: CBPeripheral) {
        peripheralArray.append(peripheral)
    }
}


