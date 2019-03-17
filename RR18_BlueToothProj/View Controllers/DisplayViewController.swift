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
    
    @IBOutlet weak var sideTouchView: UIView!
    // @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet var fNum: UILabel!
    @IBOutlet var sNum: UILabel!
    
    @IBOutlet weak var fuelEfficiencyLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var lapNumberLabel: UILabel!
    @IBOutlet weak var lapCountNumber: UILabel!
    
    
    @IBOutlet weak var peripheralView: UIView!
    @IBOutlet weak var bluetoothOnView: UIView!
    
    
    // MARK: Managers
    var bluetoothManager = RRBluetoothManager()
    var networkManager = NetworkManager()
    var dataManager = DataManager()
    
    // MARK: Data
    var laps: [String] = []
    let dateFormatter = DateFormatter()
    
    var stopwatch: Stopwatch = Stopwatch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpeedComponent()
        setupFuelEffComponent()
        setupStopwatch()
        setupLapButton()
        
        setupDataManager()
        bluetoothManager.setCentralManagerDelegate(delegate: self)
        dataManager.delegate = self
        checkIfAlreadyPoweredOn()
        
        dateFormatter.dateStyle = .full
        
        testNetworkRequestData()
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        // Set the number of required taps=2 for a double click
        tapGestureRecognizer.numberOfTapsRequired = 2
        sideTouchView.isUserInteractionEnabled = true
        sideTouchView.addGestureRecognizer(tapGestureRecognizer)
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
        
        sideTouchView.backgroundColor = UIColor(white: 1, alpha: 0.0)
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
    
    func date()->String{
        // get the current date and time
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        // get the date time String from the date object
        return formatter.string(from: currentDateTime) // October 8, 2016 at 10:48:53 PM
    }
    
    
    @IBAction func startStop(_ sender:AnyObject) {
        
        let timeInterval = Int(NSDate().timeIntervalSince1970)
        let timeIntervalDelayed = timeInterval + 1
        let timeIntervalString = String(timeInterval)
        
        if stopwatch.startStopWatch == true {
            
        
            let date = dateFormatter.string(from: NSDate() as Date)
            
            //get runID
            networkManager.getLatestRunID { (runid, error) in
                
                guard let runid = runid else {
                    guard let error = error else { return }
                    print ("error in getting latest runid \(error)")
                    return
                }
                
                guard let runIDInt = Int(runid) else {
                    print ("error occured: runid is not an int")
                    return
                }
                
                self.dataManager.setRunID(id: runIDInt + 1)
                self.dataManager.setRunName(name: "\(date) Run No. \(runIDInt)")
                self.dataManager.incrementLapNo()
                
                guard let runIDString = self.dataManager.getRunIDString() else { return }
                
                //start run
                self.networkManager.startRun(time: timeIntervalString, id: runIDString, name: self.dataManager.getRunName() ?? "run unnamed", completion: { (_, _) in
                    print("post request for start run completed")})
                
                self.networkManager.startLap(time: String(timeIntervalDelayed), id: runIDString, name: self.dataManager.getRunName() ?? "run unnamed", lapID: self.dataManager.getLapIDStr())
                
                print("started lap 1")
                
                
            }
            
            
            //timer
            stopwatch.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateStopwatch), userInfo: nil, repeats: true)
            
            RunLoop.main.add(stopwatch.timer, forMode: RunLoop.Mode.commonModes)
            stopwatch.startStopWatch = false
            
            startStopButton.setImage(UIImage(named:"stop.png"),for: UIControl.State.normal)
            lapresetButton.setImage(UIImage(named:"lap.png"),for:UIControl.State.normal)
            
            stopwatch.addLap = true
            
            //add lapid
            
            
            
        } else{ //stop
            
            stopwatch.timer.invalidate()
            stopwatch.startStopWatch = true
            
            startStopButton.setImage(UIImage(named: "start.png"), for: .normal)
            lapresetButton.setImage(UIImage(named: "reset.png"), for: .normal)
            
            stopwatch.addLap = false
            
            guard let runIDString = self.dataManager.getRunIDString() else { return }
            
            networkManager.endLap(time: timeIntervalString, id: runIDString, name: self.dataManager.getRunName() ?? "run unnamed", lapID: self.dataManager.getLapIDStr())
            print("end current lap")
            
            self.networkManager.endRun(time: String(timeIntervalDelayed), id: runIDString, name: self.dataManager.getRunName() ?? "run unnamed")
        }
        
    }
    
    func didTap(sender: UITapGestureRecognizer) {
        print("Gesture recognized")
        stopwatch.addLap = true
        laps.insert(stopwatch.stopwatchString, at:0)
        lapsTableView.reloadData()
        lapCountNumber.text = String(laps.count)
    }
    
    @IBAction func lapReset(_ sender: AnyObject) {
        
        if stopwatch.addLap == true {
            
            //start lap of one lap = the end lap of another
            let timeInterval = Int(NSDate().timeIntervalSince1970)
            let timeIntervalDelayed = timeInterval + 1
            let timeIntervalString = String(timeInterval)
            
            guard let runIDString = self.dataManager.getRunIDString() else { return }
            
            //start lap will be current lap
            
            //end current lap
            
            networkManager.endLap(time: timeIntervalString, id: runIDString, name: self.dataManager.getRunName() ?? "run unnamed", lapID: self.dataManager.getLapIDStr())
            print("end current lap")
            
            //start current lap
            dataManager.incrementLapNo()
            //should be the same as information of end lap but different lap number
            networkManager.startLap(time: String(timeIntervalDelayed), id: runIDString, name: self.dataManager.getRunName() ?? "run unnamed", lapID: dataManager.getLapIDStr())
            print("started next lap\(dataManager.getLapID())")
            
            
            laps.insert(stopwatch.stopwatchString, at:0)
            lapsTableView.reloadData()
            lapCountNumber.text = String(laps.count)
            
            
            //BMSData
            //GPS
            //Wheel
            
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

