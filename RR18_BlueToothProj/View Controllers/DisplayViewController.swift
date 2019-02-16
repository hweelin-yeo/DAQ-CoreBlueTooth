//
//  ViewController.swift
//  SW
//
//  Created by Shimona Agarwal on 2/2/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import QuartzCore

class DisplayViewController: UIViewController {
    
    // MARK: UI
    @IBOutlet weak var stopwatchLabel: UILabel!
    @IBOutlet weak var lapsTableView: UITableView!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var lapresetButton: UIButton!
    
    // @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet var fNum: UILabel!
    @IBOutlet var sNum: UILabel!
    
    @IBOutlet weak var fuelEfficiencyLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var lapNumberLabel: UILabel!
    @IBOutlet weak var lapCountNumber: UILabel!
    
    // MARK: Managers
    var bluetoothManager = RRBluetoothManager()
    var networkRequestManager = NetworkRequestManager()
    var dataManager = DataManager()
    
    // MARK: Data
    var laps: [String] = []
    
    var stopwatch: Stopwatch = Stopwatch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpeedComponent()
        setupFuelEffComponent()
        setupStopwatch()
        setupLapButton()
        
        setupDataManager()
        setupNetworkRequestManager()
        bluetoothManager.setCentralManagerDelegate(delegate: self)
        checkIfAlreadyPoweredOn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated
    }
    
}

// MARK: UITableView
extension DisplayViewController: UITableViewDelegate, UITableViewDataSource {
    //Table View Methods
    func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier:"Cell")
        
        cell.backgroundColor = .black//self.view.backgroundColor
        
        cell.textLabel?.text = "Lap \(laps.count-indexPath.row)"
        cell.detailTextLabel?.text = laps[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return laps.count
    }
}

// MARK: - UI
extension DisplayViewController {
    
    func setupSpeedComponent() {
        sNum.bounds.size = CGSize(width: 80, height: 80)
        sNum.backgroundColor = .orange
        self.sNum.layer.cornerRadius = sNum.frame.size.height/2
        sNum.clipsToBounds = true
        sNum.textAlignment = .center
    }
    
    func setupFuelEffComponent() {
        fNum.bounds.size = CGSize(width: 80, height: 80)
        fNum.backgroundColor = .red
        self.fNum.layer.cornerRadius = fNum.frame.size.height/2
        fNum.clipsToBounds = true
        fNum.textAlignment = .center
    }
    
    func setupStopwatch() {
        stopwatchLabel.text = "00:00.00"
        startStopButton.layer.cornerRadius = startStopButton.frame.size.height/2
        startStopButton.clipsToBounds = true
    }
    
    func setupLapButton() {
        lapresetButton.layer.cornerRadius = lapresetButton.frame.size.height/2
        lapresetButton.clipsToBounds = true
        
        lapsTableView.backgroundColor = .black
    }
    
    @objc func updateStopwatch(){
        
        self.stopwatch.fractions += 1
        if self.stopwatch.fractions == 100{
            self.stopwatch.seconds += 1
            self.stopwatch.fractions = 0
        }
        if self.stopwatch.seconds == 60 {
            self.stopwatch.minutes += 1
            self.stopwatch.seconds = 0
        }
        let fractionsString = self.stopwatch.fractions > 9 ? "\(self.stopwatch.fractions)" : "0\(self.stopwatch.fractions)"
        let secondsString = self.stopwatch.seconds > 9 ? "\(self.stopwatch.seconds)" : "0\(self.stopwatch.seconds)"
        let minutesString = self.stopwatch.minutes > 9 ? "\(self.stopwatch.minutes)" : "0\(self.stopwatch.minutes)"
        
        self.stopwatch.stopwatchString = "\(minutesString):\(secondsString).\(fractionsString)"
        self.stopwatchLabel.text = self.stopwatch.stopwatchString
    }
    
    @IBAction func startStop(_ sender:AnyObject) {
        
        if stopwatch.startStopWatch == true {
            
            
            stopwatch.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateStopwatch), userInfo: nil, repeats: true)
            RunLoop.main.add(stopwatch.timer, forMode: RunLoop.Mode.commonModes)
            stopwatch.startStopWatch = false
            
            startStopButton.setImage(UIImage(named:"stop.png"),for: UIControl.State.normal)
            lapresetButton.setImage(UIImage(named:"lap.png"),for:UIControl.State.normal)
            
            stopwatch.addLap = true
            
        } else{
            stopwatch.timer.invalidate()
            stopwatch.startStopWatch = true
            
            startStopButton.setImage(UIImage(named: "start.png"), for: .normal)
            lapresetButton.setImage(UIImage(named: "reset.png"), for: .normal)
            
            stopwatch.addLap = false
            
        }
    }
    
    @IBAction func lapReset(_ sender: AnyObject) {
        
        if stopwatch.addLap == true {
            
            laps.insert(stopwatch.stopwatchString, at:0)
            lapsTableView.reloadData()
            lapCountNumber.text = String(laps.count)
            
        } else{
            stopwatch.addLap = false
            lapresetButton.setImage(UIImage(named:"lap.png"), for: .normal)
            
            laps.removeAll(keepingCapacity: false)
            lapsTableView.reloadData()
            
            stopwatch.fractions = 0
            stopwatch.seconds = 0
            stopwatch.minutes = 0
            
            stopwatch.stopwatchString = "00:00.00"
            stopwatchLabel.text = stopwatch.stopwatchString
            
            lapCountNumber.text = String(0)
            
        }
    }
}

