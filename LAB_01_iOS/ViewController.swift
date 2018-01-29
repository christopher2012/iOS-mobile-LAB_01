//
//  ViewController.swift
//  LAB_01_iOS
//
//  Created by Użytkownik Gość on 15.12.2017.
//  Copyright © 2017 wizner. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var numberOfRecordText: UITextField!
    @IBOutlet weak var outputText: UITextView!
    
    var sensors: [SensorEntity] = []
    var readings: [ReadingEntity] = []
    var readingObjects: [Reading] = []
    var moc: NSManagedObjectContext? = nil
    var ad: AppDelegate? = nil
    var readingEntityDescription: NSEntityDescription? = nil;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ad = UIApplication.shared.delegate as? AppDelegate
        moc = ad!.persistentContainer.viewContext
        
        readingEntityDescription = NSEntityDescription.entity(forEntityName: "ReadingEntity", in: self.moc!)!
        
        let sensorEntityDescription = NSEntityDescription.entity(forEntityName: "SensorEntity", in: self.moc!)!
        
        if(Sensor.readSensorsFromDB(moc: self.moc!, ad: self.ad!).count == 0) {
            Sensor.generateSensors(moc: self.moc!, entity: sensorEntityDescription)
        }
        
        self.sensors = Sensor.readSensorsFromDB(moc: self.moc!, ad: self.ad!)
        self.readings = Reading.readReadingsFromDB(moc: self.moc!, ad: self.ad!)
        
        let tbvc = tabBarController as! CustomTabBarController
        tbvc.sensors = self.sensors
        tbvc.readings = self.readings
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        self.readings = []
        Reading.deleteRecords(moc: self.moc!, ad: self.ad!)
        outputText.text = ""
        let tbvc = tabBarController as! CustomTabBarController
        tbvc.readings = self.readings
    }
    
    
    
    @IBAction func saveReadingButton(_ sender: Any) {
        let startTime = NSDate()
        
        if self.readingObjects.count > 0 {
            let ctbc = tabBarController as! CustomTabBarController
            Reading.saveReadingsToDB(moc: self.moc!, sensors: self.sensors, readings: self.readingObjects, entity: self.readingEntityDescription!)
            ctbc.readings = Reading.readReadingsFromDB(moc: self.moc!, ad: self.ad!)
            let finishTime = NSDate()
            print("saving files to database time: \(finishTime.timeIntervalSince(startTime as Date))")
        }
        
    }
    
    @IBAction func generateButton(_ sender: Any) {
        let numberOfRecords = Int(numberOfRecordText.text!)!
        
        let ts = Int(NSDate().timeIntervalSince1970)
        var output = ""
        
        self.readingObjects = []
        
        let time = NSDate().timeIntervalSince1970
        
        for _ in 1...numberOfRecords {
            let ts = time - Double(arc4random_uniform(31556926))
            let val = Double(arc4random_uniform(1000))
            let sensor = Int(arc4random_uniform(19))
            
            self.readingObjects.append(Reading(sensor: sensor, value: val, ts: Int(ts)))
                
            output += "sensor: \(sensor), "
            output += "value: \(val), "
            output += "timestamp: \(NSDate(timeIntervalSince1970: TimeInterval(ts)))\n"
        }
        
        outputText.text = output
    }
}

