//
//  Reading.swift
//  LAB_01_iOS
//
//  Created by Użytkownik Gość on 12.01.2018.
//  Copyright © 2018 wizner. All rights reserved.
//

import UIKit

class Reading {

    var ts: Int = 0
    var sensor: Int
    var value: Double
    
    init(sensor: Int, value: Double, ts: Int){
        self.ts = ts
        self.sensor = sensor
        self.value = value
    }
    
}
