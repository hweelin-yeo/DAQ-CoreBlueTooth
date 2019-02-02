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

class ViewController: UIViewController {
    
    // MARK: UI
    
    @IBOutlet weak var bluetoothOnLabel: UILabel!
    @IBOutlet weak var peripheralDiscoveredLabel: UILabel!
    @IBOutlet weak var bluetoothOnView: UIView!
    @IBOutlet weak var peripheralView: UIView!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedValueLabel: UILabel!
    @IBOutlet weak var speedUnitLabel: UILabel!
    
    fileprivate var bluetoothManager = RRBluetoothManager()
    fileprivate var networkRequestManager = NetworkRequestManager()
    fileprivate var dataManager = DataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataManager()
        setupNetworkRequestManager()
//        testAlamofire()
        
        bluetoothManager.setCentralManagerDelegate(delegate: self)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        SCLAlertView().showInfo("Important info", subTitle: "Switch on BlueTooth!")
    }

}

// MARK: - DataManagerDelegate
extension ViewController: DataManagerDelegate {
    func updateBMSUI() {
        // implement
    }
    
    
    func setupDataManager() {
        dataManager.delegate = self
    }
    
    
}

// MARK: - CBCentralManagerDelegate
extension ViewController: CBCentralManagerDelegate {
    
    // update State -> if PoweredOn, scan for peripherals -> discover peripherals
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            
        case .poweredOn:
            print("Bluetooth status is SWITCHED ON")
            central.scanForPeripherals(withServices: nil, options: nil)
            
            DispatchQueue.main.async { () -> Void in
                self.bluetoothOnView.backgroundColor = .green
            }
        
        default:
            DispatchQueue.main.async { () -> Void in
                self.bluetoothOnView.backgroundColor = .red
                return;
            }
        
            
            // STEP 3.2: scan for peripherals that we're interested in
            
//            RRcentralManager.shared.scanForPeripherals(withServices: [BLE_Heart_Rate_Service_CBUUID])
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // peripheral.identifier.uuidString == "0x282a7c000"
        if (peripheral.name == "Adafruit Bluefruit LE") {
            //            peripheral.delegate = self // NOTE 1: ORIGINAL
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
        
        
        // STEP 8: look for services of interest on peripheral
//        peripheralHeartRateMonitor?.discoverServices([BLE_Heart_Rate_Service_CBUUID])
        
    }
    
    // STEP 15: when a peripheral disconnects, take
    // use-case-appropriate action
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
         print("Disconnected!")
        
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        guard error != nil else { return }
        print("Failed to connect to peripheral")
    }
    
}

// MARK: - CBPeripheralDelegate
extension ViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        guard let services = peripheral.services else { return }
        
        services.forEach({ (service) in
            print("Service: \(service)")
            peripheral.discoverCharacteristics(nil, for: service)
        })

    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            
            peripheral.readValue(for: characteristic)
//            print(characteristic.value)
            print("this character has properties \(characteristic.properties)")
            
//            if (characteristic.uuid == ? ) {
            
            
                // STEP 11: subscribe to regular notifications
                // for characteristic of interest;
                // "When you enable notifications for the
                // characteristic’s value, the peripheral calls
                // ... peripheral(_:didUpdateValueFor:error:)
                //
                // Notify    Mandatory
                //
//                peripheral.setNotifyValue(true, for: characteristic)
            
            }
            
        }
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        guard let err = error else { return }
        print(err)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        guard characteristic.uuid.uuidString == "6E400003-B5A3-F393-E0A9-E50E24DCCA9E" else { return } // uuid for bluefruit's data characteristic
        
        guard let value = characteristic.value else { return }
        
        guard let stringValue = String(data: value, encoding: String.Encoding.utf8) else { return }
        
        peripheral.setNotifyValue(true, for: characteristic)
        if (characteristic.uuid.uuidString == "1") {
            dataManager.parseRawData(data: "sdfsd")
            // updateUI
            // sendToServer
            
            
            
//            let heartRateValue = heartRateMeasurementCharacteristic.value!
            
            // convert to an array of unsigned 8-bit integers
//            let buffer = [UInt8](heartRateValue)
            
            // the first byte (8 bits) in the buffer is flags
            // (meta data governing the rest of the packet);
            // if the least significant bit (LSB) is 0,
            // the heart rate (bpm) is UInt8, if LSB is 1, BPM is UInt16
//            if ((buffer[0] & 0x01) == 0) {
//                // second byte: "Heart Rate Value Format is set to UINT8."
//                print("BPM is UInt8")
//                // write heart rate to HKHealthStore
//                // healthKitInterface.writeHeartRateData(heartRate: Int(buffer[1]))
//                return Int(buffer[1])
//            } else { // I've never seen this use case, so I'll
//                // leave it to theoroticians to argue
//                // 2nd and 3rd bytes: "Heart Rate Value Format is set to UINT16."
//                print("BPM is UInt16")
//                return -1
//            }
            
            }
            
        }
    
    
    }

// MARK: - Network Request Manager
extension ViewController: NetworkRequestHandlerDelegate {
    
    func setupNetworkRequestManager() {
        networkRequestManager.delegate = self
    }
    
    func handleFetchedData(response: String) {
        print(response)
    }
    
    
    func testAlamofire() {
        networkRequestManager.makeGetRequest(url: "https://jsonplaceholder.typicode.com/posts/1")
        networkRequestManager.makePostRequest(url: "https://jsonplaceholder.typicode.com/posts", parameters: ["title" : "foo",
                                                                                                              "body" : "bar",
                                                                                                              "userId": "1 "])
    }
}

