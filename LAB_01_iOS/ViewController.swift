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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dbFilePath = NSURL(fileURLWithPath: docDir).appendingPathComponent("demo.db")?.path
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(dbFilePath, &db) == SQLITE_OK {
            print("ok")
        } else {
            print("fail")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func generateButton(_ sender: Any) {
        let numberOfRecords = Int(numberOfRecordText.text!)
        print(numberOfRecords);
        
    }


}

