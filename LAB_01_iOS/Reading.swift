//
//  Reading.swift
//  LAB_01_iOS
//
//  Created by Użytkownik Gość on 12.01.2018.
//  Copyright © 2018 wizner. All rights reserved.
//

import CoreData
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
    
    static func deleteRecords(moc: NSManagedObjectContext, ad :AppDelegate) {
        let fetchedReadings: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "ReadingEntity");
               
        do {
            let readings = try moc.fetch(fetchedReadings)as! [NSManagedObject]
            for reading in readings {
                moc.delete(reading )
            }
            
            try moc.save()
        } catch {
            fatalError("error: \(error)")
        }
        
    }
    
    static func readReadingsFromDB(moc: NSManagedObjectContext, ad: AppDelegate) -> [ReadingEntity]{
        var readings: [ReadingEntity] = []
        
        let fetchedReadings: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "ReadingEntity");
        
        do {
            readings = try moc.fetch(fetchedReadings) as! [ReadingEntity]
        } catch {
            fatalError("error: \(error)")
        }
        
        return readings
    }
    
    static func saveReadingsToDB(moc: NSManagedObjectContext, sensors: [SensorEntity], readings: [Reading], entity : NSEntityDescription) {
        
        for reading in readings {
            let timestamp = reading.ts
            let value = reading.value
            let readingEntity: ReadingEntity = NSManagedObject(entity: entity, insertInto: moc) as! ReadingEntity
            readingEntity.setValue(timestamp, forKey: "timestamp");
            readingEntity.setValue(sensors[reading.sensor], forKey: "sensor");
            readingEntity.setValue(value, forKey: "value");
        }
        try? moc.save()
    }
    
    
    static func avgReadingAllSensors() -> NSDictionary {
        let ad = UIApplication.shared.delegate as? AppDelegate
        let moc = ad!.persistentContainer.viewContext
        var result: NSDictionary
        
        let readings = NSFetchRequest<NSFetchRequestResult>(entityName: "ReadingEntity");
        
        let valueKeyExp = NSExpression(forKeyPath: "value")
        let avgExpression = NSExpression(forFunction: "average:", arguments: [valueKeyExp])
        let countDesc = NSExpressionDescription()
        countDesc.expression = avgExpression
        countDesc.name = "average"
        countDesc.expressionResultType = .doubleAttributeType
        
        readings.returnsObjectsAsFaults = false
        readings.propertiesToFetch = [countDesc]
        readings.resultType = .dictionaryResultType
        
        
        do {
            result = try moc.fetch(readings)[0] as! NSDictionary
        } catch {
            fatalError("Failed to fetch sensors: \(error)")
        }
        return result
    }
    
    static func readingsAvgEachSensor() -> [NSDictionary] {
        
        var ad = UIApplication.shared.delegate as? AppDelegate
        let moc = ad!.persistentContainer.viewContext
        var result: [NSDictionary]
        
        let readings = NSFetchRequest<NSFetchRequestResult>(entityName: "ReadingEntity");
        
        let valueKeyExp = NSExpression(forKeyPath: "value")
        let countExpression = NSExpression(forFunction: "count:", arguments: [valueKeyExp])
        let avgExpression = NSExpression(forFunction: "average:", arguments: [valueKeyExp])
        let countDesc = NSExpressionDescription()
        countDesc.expression = countExpression
        countDesc.name = "count"
        countDesc.expressionResultType = .integer64AttributeType
        let avgDesc = NSExpressionDescription()
        avgDesc.expression = avgExpression
        avgDesc.name = "average"
        avgDesc.expressionResultType = .integer64AttributeType
        
        readings.returnsObjectsAsFaults = false
        readings.propertiesToGroupBy = ["sensor"]
        readings.propertiesToFetch = [countDesc, avgDesc]
        readings.resultType = .dictionaryResultType
        
        
        do {
            result = try moc.fetch(readings) as! [NSDictionary]
        } catch {
            fatalError("Failed to fetch sensors: \(error)")
        }
        return result;
    }
    
    static func findMinMaxTimestamp() -> String {
    
        let ad = UIApplication.shared.delegate as? AppDelegate
        let moc = ad!.persistentContainer.viewContext
        var result = ""
        
        let readings = NSFetchRequest<NSFetchRequestResult>(entityName: "ReadingEntity");
        
        var sd = NSSortDescriptor(key: "timestamp", ascending: true);
        
        readings.sortDescriptors = [sd]
        readings.fetchLimit = 1
        
        var readingEntities: [ReadingEntity] = []
        
        do {
            readingEntities = try moc.fetch(readings) as! [ReadingEntity]
        } catch {
            fatalError("Failed to fetch sensors: \(error)")
        }
        
        result = String(readingEntities[0].timestamp)
        
        sd = NSSortDescriptor(key: "timestamp", ascending: false);
        readings.sortDescriptors = [sd]
        
        do {
            readingEntities = try moc.fetch(readings) as! [ReadingEntity]
        } catch {
            fatalError("Failed to fetch sensors: \(error)")
        }
        
        result += " " + String(readingEntities[0].timestamp)
        
        return result;
    }

}
