//
//  Stopwatch.swift
//  RR18_BlueToothProj
//
//  Created by Yeo Hwee Lin on 2/16/19.
//  Copyright © 2019 Yeo Hwee Lin. All rights reserved.
//

import Foundation

struct Stopwatch {
    var timer: Timer  = Timer()
    var minutes: Int = 0
    var seconds: Int = 0
    var fractions: Int = 0
    
    var stopwatchString: String = ""
    
    var startStopWatch: Bool = true
    var addLap: Bool = false
}
