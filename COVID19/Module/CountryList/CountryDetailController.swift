//
//  CountryDetailController.swift
//  COVID19
//
//  Created by Fei Su on 2020-06-05.
//  Copyright © 2020 Fei Su. All rights reserved.
//

import UIKit
import EasyPeasy
import RealmSwift
import SVProgressHUD

class CountryDetailController: UIViewController {
    
    var name: String!
    
    var countryData: Results<Country> {
        return DBManager.shared.getAllData(for: name)
    }
    
    
    let dataView = WorldView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = name
        
        guard let latestData = countryData.last else {
            SVProgressHUD.showInfo(withStatus: "Error occurred")
            self.navigationController?.popViewController(animated: true)
            return
        }
        dataView.populateContent(total: latestData.totalCases, death: latestData.totalDeaths, recovered: latestData.totalRecovered)
        self.view.backgroundColor = .white
        self.view.addSubview(dataView)
        dataView.easy.layout(Edges())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        createTotalCaseChart(view: dataView.totalCaseView)
        createTotalDeathChart(view: dataView.totalDeathView)
    }

    func createTotalCaseChart(view: UIView) {
        let array = Array(countryData)
        let ninetyDayData = Util.getEightyDayData(array: array)
        let chart = Util.createChart(data: ninetyDayData, view: view, multiple: 100000, lineColor: #colorLiteral(red: 0, green: 0.7863109368, blue: 1, alpha: 1), caseType: .totalCase)
        
        view.addSubview(chart.view)
        self.dataView.totalCaseChart = chart
    }
    
    func createTotalDeathChart(view: UIView){
        let ninetyDayData = Util.getEightyDayData(array: Array(countryData))
        let chart = Util.createChart(data: ninetyDayData, view: view, multiple: 1000, lineColor: #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), caseType: .totalDeath)
        view.addSubview(chart.view)
        self.dataView.totalDeathChart = chart
    }

}
