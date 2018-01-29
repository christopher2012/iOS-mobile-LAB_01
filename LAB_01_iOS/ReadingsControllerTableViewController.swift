//
//  ReadingsControllerTableViewController.swift
//  LAB_01_iOS
//
//  Created by Użytkownik Gość on 05.01.2018.
//  Copyright © 2018 wizner. All rights reserved.
//

import UIKit
import CoreData

class ReadingsControllerTableViewController: UITableViewController {

    var readings: [ReadingEntity] = []
    var ad: AppDelegate? = nil
    var moc: NSManagedObjectContext? = nil
    var readingEntity: NSEntityDescription? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tbvc = self.tabBarController as! CustomTabBarController
        readings = tbvc.readings
        self.tableView.reloadData()
        
        if readings.count > 0 {
        var startTime = NSDate()
        let findMinMaxTimestampText = Reading.findMinMaxTimestamp()
        let findMinMaxTimestamp = NSDate().timeIntervalSince(startTime as Date)
        
        startTime = NSDate()
        let avgReadingAllSensorsText = Reading.avgReadingAllSensors()
        let avgReadingAllSensors = NSDate().timeIntervalSince(startTime as Date)
        
        startTime = NSDate()
        let readingsAvgEachSensorText = Reading.readingsAvgEachSensor()
        let readingsAvgEachSensor = NSDate().timeIntervalSince(startTime as Date)
        
        print("Min and max timestamp: \(findMinMaxTimestampText), time: \(findMinMaxTimestamp)")
        print("Average readings from all sensors: \(avgReadingAllSensorsText), time: \(avgReadingAllSensors)")
        print("Number of readings and average value per each sensor: \(readingsAvgEachSensorText), time: \(readingsAvgEachSensor)")
        
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return readings.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReadingTableViewCell", for: indexPath) as? ReadingTableViewCell
        
        cell?.SensorText.text = "sensor: " + String(describing: readings[indexPath.row].sensor?.name)
        cell?.ValueText.text = "value: " + String(describing: readings[indexPath.row].value)
        cell?.DateText.text = "date: " + String(describing: NSDate(timeIntervalSince1970: TimeInterval(readings[indexPath.row].timestamp)))

        return cell!
        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
