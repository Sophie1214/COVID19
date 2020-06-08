//
//  WebManager.swift
//  COVID19
//
//  Created by Fei Su on 2020-04-05.
//  Copyright © 2020 Fei Su. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WebManager {
    
    static let headers: HTTPHeaders = [
        "x-rapidapi-host": "covid-19-data.p.rapidapi.com",
        "x-rapidapi-key": "22d7cc795bmsh2343ab2e04b361dp1324e4jsn583fce5462b2"
    ]
    
    static func getCountryList(_ completion: @escaping(([Country]) -> Void)) {
        getJson { (json) in
            
            var countryList: [Country] = []
            for (key, subJson) in json {
                var dayList: [Country] = []
                for day in subJson.arrayValue {
                    
                    if let country = Country(name: key, json: day) {
                        dayList.append(country)
                    }
                }
                dayList.sort { $0.date < $1.date }
                DBManager.shared.updateCountryList(dayList)
                countryList.append(contentsOf: dayList)
            }
            
            completion(countryList)
        }
    }
    
    static func getJson(completion:  @escaping ((JSON) -> Void))  {
        AF.request("https://pomber.github.io/covid19/timeseries.json").responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                completion(json)
            case .failure(let error):
                print("failed, error: \(error.localizedDescription)")
            }
        }
    }
    
//    static func getAllCountryData(completion: @escaping((JSON) -> Void)) {
//        AF.request("https://covid-19-data.p.rapidapi.com/country/all", headers: headers).responseJSON { response in
//            switch response.result {
//            case .success(let data):
//                let json = JSON(data)
//
//
//
//            case .failure(let error):
//                print("failed, error: \(error.localizedDescription)")
//            }
//        }
//    }
    
    static func getLatestData(for country: String, _ completion: @escaping (() -> Void)) {
        let params: [String: Any] = ["format": "json", "name": country]

        
        AF.request("https://covid-19-data.p.rapidapi.com/country", parameters: params, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data).arrayValue
                if let countryJson = json.first {
                    let date = Util.dateToBeginningOfDay(Date())
                    var countryName = country
                    if countryName == "usa"{
                        countryName = "US"
                    }
                    let country = Country(name: countryName, json: countryJson, date: date)
                    let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: date)!
                    if let previousDay = DBManager.shared.getData(for: "\(country.name)\(previousDay)"){
                        country.gainedCases = country.totalCases - previousDay.totalCases
                    }
                    
                    DBManager.shared.insertCountry(country)
                    completion()
                }
            case .failure(let error):
                print("failed, error: \(error.localizedDescription)")
            }
        }
    }
    
    static func getAllCountryTodayData(completion: @escaping((Country?) -> Void)) {
        AF.request("https://covid-19-data.p.rapidapi.com/country/all", headers: headers).responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data).arrayValue
                for countryJson in json {
                    if let country = Country(name: countryJson["country"].stringValue, json: countryJson){
                        DBManager.shared.insertCountry(country)
                    }
                }
            case .failure(let error):
                print("failed, error: \(error.localizedDescription)")
            }
        }
    }
    
    static func getWorldData(completion: @escaping((Country?) -> Void)) {
        
        AF.request("https://covid-19-data.p.rapidapi.com/totals?format=undefined",headers: headers).responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data).arrayValue
                if let day = Country(name: "world", json: json.first!){
                    DBManager.shared.insertWorldData(day)
                    completion(day)
                } else {
                    completion (nil)
                }
                
            case .failure(let error):
                completion(nil)
                print("failed, error: \(error.localizedDescription)")
                
            }
        }
        
    }
    
    static func getWorldDataBy(date: String, completion: @escaping((Country?) -> Void)) {
        
        let param = ["date": date, "format": "json", "date-format": "YYYY-MM-DD"]
        
        AF.request("https://covid-19-data.p.rapidapi.com/report/totals", parameters: param, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data).arrayValue
                if let day = Country(name: "world", json: json.first!) {
                    DBManager.shared.insertWorldData(day)
                    completion(day)
                } else {
                    completion(nil)
                }
                
            case .failure(let error):
                completion(nil)
                print("failed, error: \(error.localizedDescription)")
                
            }
        }
    }
}
