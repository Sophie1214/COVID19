//
//  Country.swift
//  COVID19
//
//  Created by Fei Su on 2020-04-06.
//  Copyright © 2020 Fei Su. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Country: Object, Comparable {
    
    static func < (lhs: Country, rhs: Country) -> Bool {
        return lhs.date < rhs.date
    }
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.date == rhs.date
    }
    
    @objc dynamic var name: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var totalCases: Int = 0
    @objc dynamic var gainedCases = 0
    @objc dynamic var totalDeaths = 0
    @objc dynamic var gainedDeath = 0
    @objc dynamic var totalRecovered = 0
    @objc dynamic var activeCases: Int {
        return totalCases - totalDeaths - totalRecovered
    }
    @objc dynamic var id: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }

    
    convenience init?(name: String, json: JSON) {
        self.init()
        
        guard json["confirmed"] != JSON.null else {
            return nil
        }
        self.name = name
        
        self.totalCases = json["confirmed"].intValue
        self.totalDeaths = json["deaths"].intValue
        self.totalRecovered = json["recovered"].intValue
        
        //get new cases after saving all dates of the country
        
        //            if json.indices.contains(json.count - 2) {
        //                let secondLastDay = json[json.count - 2]
        //                self.newCases = totalCases - secondLastDay["confirmed"].intValue
        //                self.newDeaths = totalCases - secondLastDay["deaths"].intValue
        //            }
        
        
        let parsedDate = Util.parseTimeStamp(json["date"].stringValue)
        self.date = parsedDate ?? Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        self.id = "\(name)\(date)"
    }
    
    convenience init(name: String, json: JSON, date: Date) {
        self.init()
        
        self.name = name
        self.totalCases = json["confirmed"].intValue
        self.totalDeaths = json["deaths"].intValue
        self.totalRecovered = json["recovered"].intValue
        self.date = date
        self.id = "\(name)\(date)"
    }
}
