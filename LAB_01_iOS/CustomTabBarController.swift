//
//  CustomTabBarController.swift
//  LAB_01_iOS
//
//  Created by Użytkownik Gość on 19.01.2018.
//  Copyright © 2018 wizner. All rights reserved.
//

import UIKit
import CoreData

class CustomTabBarController: UITabBarController {
    
    var sensors: [SensorEntity] = []
    var readings: [ReadingEntity] = []
    var db: OpaquePointer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
