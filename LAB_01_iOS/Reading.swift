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
    
    static func deleteRecords(db: OpaquePointer?) {
        let delete = "delete from readings;"
        var stmt: OpaquePointer? = nil
        if(sqlite3_prepare_v2(db, delete, -1, &stmt, nil) == SQLITE_OK) {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("readings deleted!")
            }
        }
        sqlite3_finalize(stmt)
    }
    
    static func readReadingsFromDB(db: OpaquePointer?) -> [Reading]{
        var readings: [Reading] = []
        
        var stmt: OpaquePointer? = nil
        let select = "select sensorid, value, timestamp from readings;"
        if(sqlite3_prepare(db, select, -1, &stmt, nil) == SQLITE_OK){
            while(sqlite3_step(stmt) == SQLITE_ROW) {
                let sensorid = sqlite3_column_int(stmt, 0)
                let value = sqlite3_column_double(stmt, 1)
                let ts = sqlite3_column_int(stmt, 2)
                readings.append(Reading(sensor: Int(sensorid), value: value, ts: Int(ts)))
            }
        }else{
            let errorMessage = String.init(cString: sqlite3_errmsg(db))
            print("prepared stmt could not be created \(errorMessage)")
        }
        
        
        sqlite3_finalize(stmt)
        
        return readings
    }
    
    static func createTable(db: OpaquePointer?) {
        let createSQL = "CREATE TABLE readings(sensorid INTEGER, value NUMERIC, timestamp INTEGER);"
        
        var stmt: OpaquePointer? = nil
        if(sqlite3_prepare_v2(db, createSQL, -1, &stmt, nil) == SQLITE_OK) {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("READINGS table created")
            }else {
                print("readings table not created")
            }
        }else{
            let errorMessage = String.init(cString: sqlite3_errmsg(db))
            print("prepared stmt could not be created \(errorMessage)")
        }
        
        sqlite3_finalize(stmt)
    }
    
    static func saveReadingsToDB(db: OpaquePointer?, readings: [Reading]){
        
        var insertSQL = "INSERT INTO readings (timestamp, value, sensorid) VALUES "
        for reading in readings {
            insertSQL += "(\"\(reading.ts)\", \"\(reading.value)\", \"\(reading.sensor)\"),";
        }
        insertSQL = String(insertSQL.characters.dropLast())
        insertSQL += ";"
        
        sqlite3_exec(db, insertSQL, nil, nil, nil)
        
    }
    
    
    static func avgReadingAllSensors(db: OpaquePointer?) -> Double {
        let selectSQL = "select avg(value) from readings;"
        var stmt: OpaquePointer? = nil
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        sqlite3_step(stmt)
        let avg = sqlite3_column_double(stmt, 0)
        sqlite3_finalize(stmt)
        return avg;
    }
    
    static func readingsAvgEachSensor(db: OpaquePointer?) -> [String] {
        let selectSQL = "Select sensor.name, count(readings.timestamp), avg(readings.value) 
        from readings left join sensor ON sensorid=sensor.id group by sensor.name;"
        var stmt: OpaquePointer? = nil
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        sqlite3_step(stmt)
        var results: [String] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            let sensorName = String(cString: sqlite3_column_text(stmt, 0))
            let counter = sqlite3_column_int(stmt, 1)
            let avg = sqlite3_column_double(stmt, 2)
            let result = "Name " + sensorName + " ; readings: " + String(counter) + " ; avg: " + String(avg)
            results.append(result);
        }
        sqlite3_finalize(stmt)
        return results;
    }
    
    static func findMinMaxTimestamp(db: OpaquePointer?) -> String {
        let selectSQL = "select MIN(timestamp), MAX(timestamp) from readings;"
        var stmt: OpaquePointer? = nil
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        sqlite3_step(stmt)
        let min = sqlite3_column_double(stmt, 0)
        let max = sqlite3_column_double(stmt, 1)
        
        let value =  "Min: " + String(min) + "; Max: " + String(max)
        sqlite3_finalize(stmt)
        return value;
    }
        
    static func tableExists(db: OpaquePointer?) -> Bool{
        let select = "select count(*) from readings"
        var stmt : OpaquePointer? = nil
        sqlite3_prepare(db, select, -1, &stmt, nil)
        if(sqlite3_step(stmt) == SQLITE_ROW) {
            return true
        }else {
            return false
        }
    }
}
