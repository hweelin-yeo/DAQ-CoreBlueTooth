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
    
    fileprivate var RRcentralManager = RRCentralManager.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        RRcentralManager.setDelegate(delegate: self)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SCLAlertView().showInfo("Important info", subTitle: "Switch on BlueTooth!")
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
            SCLAlertView().showInfo("Important info", subTitle: "Device Bluetooth Status: Not Powered On")
            DispatchQueue.main.async { () -> Void in
                self.bluetoothOnView.backgroundColor = .red
                return;
            }
        
            
            // STEP 3.2: scan for peripherals that we're interested in
            
//            RRcentralManager.shared.scanForPeripherals(withServices: [BLE_Heart_Rate_Service_CBUUID])
            
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
            self.bluetoothOnView.backgroundColor = .green
        }
        
        // STEP 8: look for services of interest on peripheral
//        peripheralHeartRateMonitor?.discoverServices([BLE_Heart_Rate_Service_CBUUID])
        
    }
    
    // STEP 15: when a peripheral disconnects, take
    // use-case-appropriate action
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        // print("Disconnected!")
        for service in peripheral.services! {
            let thisService = service as CBService
            print (service.uuid)
//            if service.UUID == BEAN_SERVICE_UUID {
//                peripheral.discoverCharacteristics(
//                    nil,
//                    forService: thisService
//                )
//            }
        }
        DispatchQueue.main.async { () -> Void in
           // UI updates
        }
        
    }
    
}

// MARK: - CBPeripheralDelegate
extension ViewController: CBPeripheralDelegate {}

