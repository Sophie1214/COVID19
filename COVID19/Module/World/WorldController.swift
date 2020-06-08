//
//  WorldController.swift
//  COVID19
//
//  Created by Fei Su on 2020-04-07.
//  Copyright © 2020 Fei Su. All rights reserved.
//

import UIKit
import SwiftCharts
import EasyPeasy
import SwiftyJSON
import SVProgressHUD
import RealmSwift

class WorldController: UIViewController {
    
    let worldView = WorldView()
    var worldDayData: [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "World Numbers"
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        self.view.addSubview(worldView)
        worldView.easy.layout(Edges())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        populateContent()
        generateGraphData()
    }
    
    func populateContent(){
        
        if let worldData = DBManager.shared.getWorldCurrentData() {
            worldView.populateContent(total: worldData.totalCases, death: worldData.totalDeaths, recovered: worldData.totalRecovered)
        }
        
        WebManager.getWorldData { [weak self] (country) in
            guard let self = self else { return }
            
            self.worldDayData.removeAll()
            if let country = country {
                self.worldDayData.append(country)
                self.worldView.populateContent(total: country.totalCases, death: country.totalDeaths, recovered: country.totalRecovered)
                self.generateGraphData()
            }
        }
    }
    
    func generateGraphData(){
        SVProgressHUD.show()
        
        let firstDay = Date(timeIntervalSince1970: 1583024934)
        var currentDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let myGroup = DispatchGroup()
        while currentDate > firstDay {
            myGroup.enter()
            let dateString = Util.dateToDayString(currentDate)
            if let worldData = DBManager.shared.getWorldData(by: dateString) {
                if !self.worldDayData.contains(worldData) {
                    self.worldDayData.append(worldData)
                }
            } else {
                
                WebManager.getWorldDataBy(date: dateString) { [weak self] (dayData) in
                    guard let self = self else { return }
                    if let data = dayData{
                        if !self.worldDayData.contains(data) {
                            self.worldDayData.append(data)
                        }
                    }
                    myGroup.leave()
                }
            }
            currentDate = currentDate.addingTimeInterval(-777600)
        }
        
        myGroup.notify(queue: .main){ [weak self] in
            SVProgressHUD.dismiss()
            guard let self = self else { return }
            self.worldDayData.sort { $0.date < $1.date }
            self.createTotalCaseChart(view: self.worldView.totalCaseView)
            self.createTotalDeathChart(view: self.worldView.totalDeathView)
        }
    }
    
    func createTotalCaseChart(view: UIView) {
        let ninetyDayData = Util.getEightyDayData(array: worldDayData)
        let chart = Util.createChart(data: ninetyDayData, view: view, multiple: 250000, lineColor: #colorLiteral(red: 0, green: 0.7863109368, blue: 1, alpha: 1), caseType: .totalCase)
        
        view.addSubview(chart.view)
        self.worldView.totalCaseChart = chart
    }
    
    func createTotalDeathChart(view: UIView){
        let ninetyDayData = Util.getEightyDayData(array: worldDayData)
        let chart = Util.createChart(data: ninetyDayData, view: view, multiple: 25000, lineColor: #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), caseType: .totalDeath)
        view.addSubview(chart.view)
        self.worldView.totalDeathChart = chart
    }
    
}
