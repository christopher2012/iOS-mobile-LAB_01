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
            let description = " Sensor number " + String(i + 1)
            let sensor = Sensor(id: i, name: sensorName, description: description)
            result.append(sensor)
        }
        return result;
    }
    
    static func readSensorsFromDB(db: OpaquePointer?) -> [Sensor]{
        var sensors: [Sensor] = []
        
        var stmt: OpaquePointer? = nil
        let select = "select id, name, desc from sensor;"
        sqlite3_prepare(db, select, -1, &stmt, nil)
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let desc = String(cString: sqlite3_column_text(stmt, 2))
            sensors.append(Sensor(id: Int(id), name: name, description: desc))
        }
        
        sqlite3_finalize(stmt)
        
        return sensors
    }
    
    static func createTable(db: OpaquePointer?) {
        let createSQL = "CREATE TABLE sensor(id INTEGER PRIMARY KEY, name VARCHAR(255), desc VARCHAR(255));"
        
        var stmt: OpaquePointer? = nil
        if(sqlite3_prepare_v2(db, createSQL, -1, &stmt, nil) == SQLITE_OK) {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Sensor table created")
            }else {
                print("Sensor table not created")
            }
        }else{
            let errorMessage = String.init(cString: sqlite3_errmsg(db))
            print("prepared stmt could not be created \(errorMessage)")
        }
        
        sqlite3_finalize(stmt)
    }

    static func saveSensorsToDB(db: OpaquePointer?, sensors: [Sensor]){
        createTable(db: db)
        var stmt: OpaquePointer? = nil
        let insertStatementString = "INSERT INTO sensor (id, name, desc) values (?, ?, ?);"
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &stmt, nil) == SQLITE_OK {
            for sensor in sensors {
                let name11 = sensor.name;
                sqlite3_bind_int(stmt, 1, Int32(sensor.id))
                sqlite3_bind_text(stmt, 2, name11, -1, nil)
                sqlite3_bind_text(stmt, 3, sensor.desc, -1, nil)
                if !(sqlite3_step(stmt) == SQLITE_DONE) {
                    print("something goes wrong")
                }
                sqlite3_reset(stmt)
            }
        
            sqlite3_finalize(stmt)
        }
    }
    
    static func tableExists(db: OpaquePointer?) -> Bool{
        let select = "select count(*) from sensor;"
        var stmt : OpaquePointer? = nil
        sqlite3_prepare(db, select, -1, &stmt, nil)
        if(sqlite3_step(stmt) == SQLITE_ROW) {
            return true
        }else {
            return false
        }
        
    }
    
    static func deleteRecords(db: OpaquePointer?) {
        let delete = "delete from sensor;"
        var stmt: OpaquePointer? = nil
        if(sqlite3_prepare_v2(db, delete, -1, &stmt, nil) == SQLITE_OK) {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("sensor deleted!")
            }
        }
        sqlite3_finalize(stmt)
    }
    
}
