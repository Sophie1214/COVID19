//
//  WorldDay.swift
//  COVID19
//
//  Created by Fei Su on 2020-04-16.
//  Copyright © 2020 Fei Su. All rights reserved.
//

import Foundation
import SwiftyJSON

class WorldDay: Comparable {
    static func < (lhs: WorldDay, rhs: WorldDay) -> Bool {
        return lhs.date < rhs.date
    }
    
    static func == (lhs: WorldDay, rhs: WorldDay) -> Bool {
        return lhs.date == rhs.date
    }
    
    var date: Date
    var totalCases: Int
    var totalDeaths: Int
    var totalRecovered: Int
    var activeCases: Int
    
    init(date: Date, totalCases: Int, totalDeaths: Int, totalRecovered: Int, active: Int){
        self.date = date
        self.totalCases = totalCases
        self.totalDeaths = totalDeaths
        self.totalRecovered = totalRecovered
        self.activeCases = active
    }
    
    init?(json: JSON?) {
        guard let json = json else { return nil }
        let date = json["date"].stringValue
        let convertedDate = Util.parseTimeStamp(date)
        if convertedDate == nil {
            return nil
        }
        
        self.date = convertedDate!
        self.totalCases = json["confirmed"].intValue
        self.totalDeaths = json["deaths"].intValue
        self.totalRecovered = json["recovered"].intValue
        self.activeCases = json["active"].intValue
    }
    
}
