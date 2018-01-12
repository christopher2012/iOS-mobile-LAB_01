//
//  Sensor.swift
//  LAB_01_iOS
//
//  Created by Użytkownik Gość on 05.01.2018.
//  Copyright © 2018 wizner. All rights reserved.
//

import Foundation

class Sensor {
    var id: Int
    var name: String
    var desc: String
    
    init (id: Int, name: String, description: String) {
        self.id = id
        self.name = name
        self.desc = description
    }
    
    static func generateSensors() -> [Sensor] {
        var result: [Sensor] = []
        for i in 0...19 {
            let sensorName = "S"  + String(i + 1)
            let description = "Sensor number " + String(i + 1)
            let sensor = Sensor(id: i, name: sensorName, description: description)
            result.append(sensor)
        }
        return result;
    }

    static func createTable(db: OpaquePointer?) {
        let createSQL = "CREATE TABLE sensor(id INTEGER PRIMARY KEY, name VARCHAR(255), desc VARCHAR(255));"
        sqlite3_exec(db, createSQL, nil, nil, nil)
    }
    
}
