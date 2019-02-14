//
//  ViewController.swift
//  SW
//
//  Created by Shimona Agarwal on 2/2/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var laps: [String] = []
    
    var timer = Timer()
    var minutes: Int = 0
    var seconds: Int = 0
    var fractions: Int = 0
    
    var stopwatchString: String = ""
    
    var startStopWatch: Bool = true
    var addLap: Bool = false
    var startEndRun: Bool = true
    
    
    @IBOutlet weak var stopwatchLabel: UILabel!
    
    @IBOutlet weak var lapsTableView: UITableView!
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var lapresetButton: UIButton!
    
    @IBOutlet weak var startEndRunButton: UIButton!
    
    @IBOutlet var fNum: UILabel!
    @IBOutlet var sNum: UILabel!
    
    @IBOutlet weak var fuelEfficiencyLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var lapNumberLabel: UILabel!
    @IBOutlet weak var lapCountNumber: UILabel!
    
    
    @IBAction func startEndRun(_ sender: Any) {
        if startEndRun == true{
            startEndRunButton.setTitle("End Run", for: UIControl.State.normal)
            startEndRun = false
        }
        else{
            startEndRun = true
            startEndRunButton.setTitle("Start Run", for: UIControl.State.normal)
        }
    }
    
    @IBAction func startStop(_ sender:AnyObject) {
        
        if startStopWatch == true {
            
            
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateStopwatch), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
            startStopWatch = false
            
            startStopButton.setImage(UIImage(named:"stop.png"),for: UIControl.State.normal)
            lapresetButton.setImage(UIImage(named:"lap.png"),for:UIControl.State.normal)
            
            addLap = true
            
        } else{
            timer.invalidate()
            startStopWatch = true
            
            startStopButton.setImage(UIImage(named: "start.png"), for: .normal)
            lapresetButton.setImage(UIImage(named: "lap.png"), for: .normal)
            
            addLap = false
            
        }
    }
    
    @IBAction func lapReset(_ sender: AnyObject) {
        
        if addLap == true {
            
            laps.insert(stopwatchString, at:0)
            lapsTableView.reloadData()
            lapCountNumber.text = String(laps.count)
            
        }else{
            addLap = false
            lapresetButton.setImage(UIImage(named:"lap.png"), for: .normal)
            
            laps.removeAll(keepingCapacity: false)
            lapsTableView.reloadData()
            
            fractions = 0
            seconds = 0
            minutes = 0
            
            stopwatchString = "00:00.00"
            stopwatchLabel.text = stopwatchString
            
            lapCountNumber.text = String(0)
            
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopwatchLabel.text = "00:00.00"
        
        sNum.bounds.size = CGSize(width: 80, height: 80)
        sNum.backgroundColor = .orange
        self.sNum.layer.cornerRadius = sNum.frame.size.height/2
        sNum.clipsToBounds = true
        sNum.textAlignment = .center
        
        fNum.bounds.size = CGSize(width: 80, height: 80)
        fNum.backgroundColor = .yellow
        self.fNum.layer.cornerRadius = fNum.frame.size.height/2
        fNum.clipsToBounds = true
        fNum.textAlignment = .center
        
        startStopButton.layer.cornerRadius = startStopButton.frame.size.height/2
        startStopButton.clipsToBounds = true
        
        
        lapresetButton.layer.cornerRadius = lapresetButton.frame.size.height/2
        lapresetButton.clipsToBounds = true
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated
    }
    
    @objc func updateStopwatch(){
        
        self.fractions += 1
        if self.fractions == 100{
            self.seconds += 1
            self.fractions = 0
        }
        if self.seconds == 60 {
            self.minutes += 1
            self.seconds = 0
        }
            let fractionsString = self.fractions > 9 ? "\(self.fractions)" : "0\(self.fractions)"
            let secondsString = self.seconds > 9 ? "\(self.seconds)" : "0\(self.seconds)"
            let minutesString = self.minutes > 9 ? "\(self.minutes)" : "0\(self.minutes)"

            self.stopwatchString = "\(minutesString):\(secondsString).\(fractionsString)"
            self.stopwatchLabel.text = self.stopwatchString
    }
    
    //Table View Methods
    func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier:"Cell")
        
        cell.backgroundColor = self.view.backgroundColor
        cell.textLabel?.text = "Lap \(laps.count-indexPath.row)"
        cell.detailTextLabel?.text = laps[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return laps.count
    }
    
}

