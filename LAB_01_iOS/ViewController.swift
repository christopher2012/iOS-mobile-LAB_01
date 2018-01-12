//
//  ViewController.swift
//  LAB_01_iOS
//
//  Created by Użytkownik Gość on 15.12.2017.
//  Copyright © 2017 wizner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var numberOfRecordText: UITextField!
    @IBOutlet weak var outputText: UITextView!
    
    var db: OpaquePointer? = nil
    var sensors: [Sensor] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dbFilePath = NSURL(fileURLWithPath: docDir).appendingPathComponent("demo.db")?.path
        
        
        
        
        
        sensors = Sensor.generateSensors()
        
        
        
        /*
        if sqlite3_open(dbFilePath, &db) == SQLITE_OK {
            print("ok")
        } else {
            print("fail")
        }
         */
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        outputText.text = ""
    }
    
    
    
    @IBAction func saveReadingButton(_ sender: Any) {
        var execTime = NSDate()
        
        sqlite3_exec(db, "BEGIN", nil, nil, nil)
        
        var sqlString = "INSERT INTO readings (sensor_id, value, ts) vales "
        
        //execTime = NSDate() - execTime
        
        print("saving files to database time: \(execTime)")
        
        
        
    }
    
    @IBAction func generateButton(_ sender: Any) {
        let numberOfRecords = Int(numberOfRecordText.text!)!
        
        var readings: [Reading] = []
        
        let ts = Int(NSDate().timeIntervalSince1970)
        var output = ""
        
        for i in 1...numberOfRecords {
            let ts = ts+1000
            let val = Double(arc4random_uniform(1000))
            let sensor = Int(arc4random_uniform(19))
            readings.append(Reading(sensor: sensor, value: val, ts: ts))
            
            output += "sensor: \(sensor), "
            output += "value: \(val), "
            output += "timestamp: \(ts)\n"
        }
        
        outputText.text = output
        
        
    }
    
    


}

