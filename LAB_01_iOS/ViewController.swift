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
    var readings: [Reading] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dbFilePath = NSURL(fileURLWithPath: docDir).appendingPathComponent("demo5.db")?.path

        print(dbFilePath ?? "")
        
        var dbOK = false
        
        if sqlite3_open(dbFilePath, &db) == SQLITE_OK {
            print("ok")
            dbOK =  true
        } else {
            print("fail")
        }
        
        if(dbOK){
        
            if(!Sensor.tableExists(db: db)){
                print("create table sensor")
                sensors = Sensor.generateSensors()
                Sensor.saveSensorsToDB(db: db, sensors: sensors)
            } else {
                sensors = Sensor.readSensorsFromDB(db: db)
                print("reading sensors from db")
            }
            
            if(!Reading.tableExists(db: db)){
                print("table not exists or empty reading")
               Reading.createTable(db: db)
            } else {
                print("data reading")
              readings = Reading.readReadingsFromDB(db: db)
            }
            
            let tbvc = tabBarController as! CustomTabBarController
            tbvc.sensors = self.sensors
            tbvc.readings = self.readings
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        Reading.deleteRecords(db: db)
        self.readings = []
        outputText.text = ""
    }
    
    
    
    @IBAction func saveReadingButton(_ sender: Any) {
        let startTime = NSDate()
        
    //    sqlite3_exec(db, "BEGIN", nil, nil, nil)
        
      //  var sqlString = "INSERT INTO readings (sensor_id, value, ts) vales "
        
        //execTime = NSDate() - execTime
        
        if self.readings.count > 0 {
        Reading.saveReadingsToDB(db: db, readings: self.readings)
        
        
        let tbvc = tabBarController as! CustomTabBarController
        tbvc.readings = Reading.readReadingsFromDB(db: self.db)
        
        let finishTime = NSDate()
        
        print("saving files to database time: \(finishTime.timeIntervalSince(startTime as Date))")
        }
        
        
    }
    
    @IBAction func generateButton(_ sender: Any) {
        let numberOfRecords = Int(numberOfRecordText.text!)!
        
        let ts = Int(NSDate().timeIntervalSince1970)
        var output = ""
        
        readings = []
        
        let time = NSDate().timeIntervalSince1970
        
        for _ in 1...numberOfRecords {
            let ts = time - Double(arc4random_uniform(31556926))
            let val = Double(arc4random_uniform(1000))
            let sensor = Int(arc4random_uniform(19))
            self.readings.append(Reading(sensor: sensor, value: val, ts: Int(ts)))
            
            output += "sensor: \(sensor), "
            output += "value: \(val), "
            output += "timestamp: \(NSDate(timeIntervalSince1970: TimeInterval(ts)))\n"
        }
        
        

        outputText.text = output
        
        
    }
    
    


}

