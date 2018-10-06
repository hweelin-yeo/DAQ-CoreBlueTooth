//
//  ViewController.swift
//  RR18_BlueToothProj
//
//  Created by Yeo Hwee Lin on 10/6/18.
//  Copyright © 2018 Yeo Hwee Lin. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    
    // MARK: UI

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - CBCentralManagerDelegate
extension ViewController: CBCentralManagerDelegate {
    
    // update State -> if PoweredOn, scan for peripherals -> discover peripherals
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            
        case .unknown:
            print("Bluetooth status is UNKNOWN")
        case .resetting:
            print("Bluetooth status is RESETTING")
        case .unsupported:
            print("Bluetooth status is UNSUPPORTED")
        case .unauthorized:
            print("Bluetooth status is UNAUTHORIZED")
        case .poweredOff:
            print("Bluetooth status is POWERED OFF")
        case .poweredOn:
            print("Bluetooth status is POWERED ON")
            
            DispatchQueue.main.async { () -> Void in
                
                // UI updates
                
            }
            
            // STEP 3.2: scan for peripherals that we're interested in
            
//            RRManager().sharedCentralManager.scanForPeripherals(withServices: [BLE_Heart_Rate_Service_CBUUID])
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print(peripheral.name ?? "")
//        decodePeripheralState(peripheralState: peripheral.state)
//        // STEP 4.2: MUST store a reference to the peripheral in
//        // class instance variable
//        peripheralHeartRateMonitor = peripheral
//        // STEP 4.3: since HeartRateMonitorViewController
//        // adopts the CBPeripheralDelegate protocol,
//        // the peripheralHeartRateMonitor must set its
//        // delegate property to HeartRateMonitorViewController
//        // (self)
//        peripheralHeartRateMonitor?.delegate = self
//        
//        // STEP 5: stop scanning to preserve battery life;
//        // re-scan if disconnected
//        centralManager?.stopScan()
//        
//        // STEP 6: connect to the discovered peripheral of interest
//        centralManager?.connect(peripheralHeartRateMonitor!)
//        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        DispatchQueue.main.async { () -> Void in
            // UI updates
        }
        
        // STEP 8: look for services of interest on peripheral
//        peripheralHeartRateMonitor?.discoverServices([BLE_Heart_Rate_Service_CBUUID])
        
    }
    
    // STEP 15: when a peripheral disconnects, take
    // use-case-appropriate action
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        // print("Disconnected!")
        
        DispatchQueue.main.async { () -> Void in
           // UI updates
        }
        
    }
    
}

// MARK: - CBPeripheralDelegate
extension ViewController: CBPeripheralDelegate {}

