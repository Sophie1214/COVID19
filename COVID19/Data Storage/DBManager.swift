//
//  DBManager.swift
//  COVID19
//
//  Created by Fei Su on 2020-04-17.
//  Copyright © 2020 Fei Su. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
    
    var database:Realm
    static let shared = DBManager()
    
    init() {
        
        //        let config = Realm.Configuration(
        //            // Set the new schema version. This must be greater than the previously used
        //            // version (if you've never set a schema version before, the version is 0).
        //            schemaVersion: 0,
        //            migrationBlock: { migration, oldSchemaVersion in
        //        })
        //        Realm.Configuration.defaultConfiguration = config
        
        database = try! Realm()
    }
    
    func insertCountry(_ country: Country) {
        do {
            try database.write {
                database.add(country, update: .modified)
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func updateCountryList(_ countries: [Country]){
        do {
            try database.write {
                database.add(countries, update: .modified)
                let lastday = countries[countries.count - 1]
                let secondLast = countries[countries.count - 2]
                updateCountry(lastday,
                              newCase: lastday.totalCases - secondLast.totalCases,
                              newDeath: lastday.totalDeaths - secondLast.totalDeaths)
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func updateCountry(_ country: Country, newCase: Int, newDeath: Int) {
        do {
            if !database.isInWriteTransaction {
                try database.write {
                    country.gainedCases = newCase
                    country.gainedDeath = newDeath
                }
            } else {
                country.gainedCases = newCase
                country.gainedDeath = newDeath
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func insertWorldData(_ country: Country) {
        do {
            try database.write {
                database.add(country, update: .modified)
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func getWorldCurrentData() -> Country? {
        return database.objects(Country.self).filter("name = %@", "world").sorted(byKeyPath: "date", ascending: false).first
    }
    
    func getWorldData(by dateString: String) -> Country? {
        return database.object(ofType: Country.self, forPrimaryKey: "world\(dateString)")
    }
    
    func getTodayCountryList() -> Results<Country>{
        let today = Util.dateToBeginningOfDay(Date())
        let array = database.objects(Country.self).filter("date = %@ and name != %@", today, "world").sorted(byKeyPath: "totalCases", ascending: false)
        return array
    }
}
