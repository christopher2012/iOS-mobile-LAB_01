//
//  Sensor.swift
//  LAB_01_iOS
//
//  Created by Użytkownik Gość on 05.01.2018.
//  Copyright © 2018 wizner. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Sensor {
    
    static func generateSensors(moc: NSManagedObjectContext, entity: NSEntityDescription) -> [SensorEntity] {
        var result: [SensorEntity] = []
        for i in 0...19 {
            let sensorName = "S"  + String(i + 1)
            let description = " Sensor number " + String(i + 1)
            let sensorEntity: SensorEntity = NSManagedObject(entity: entity, insertInto: moc) as! SensorEntity
            sensorEntity.setValue(sensorName, forKey: "name");
            sensorEntity.setValue(description, forKey: "desc");
            result.append(sensorEntity)
        }
        try? moc.save()
        return result;
    }
    
    static func readSensorsFromDB(moc: NSManagedObjectContext, ad: AppDelegate) -> [SensorEntity]{
        
        var sensors: [SensorEntity] = []
       
        let moc = ad.persistentContainer.viewContext
        let fetchedSensors: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "SensorEntity");
        
        do {
            sensors = try moc.fetch(fetchedSensors) as! [SensorEntity]
        } catch {
            fatalError("error: \(error)")
        }
        
        return sensors;
    }
}
