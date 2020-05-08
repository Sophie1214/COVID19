//
//  WorldView.swift
//  COVID19
//
//  Created by Fei Su on 2020-04-08.
//  Copyright © 2020 Fei Su. All rights reserved.
//

import UIKit
import EasyPeasy
import SwiftCharts

class WorldView: UIView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var totalCaseChart: Chart?
    var totalDeathChart: Chart?
    var newCaseChart: Chart?
    
    
    let totalCaseLabel: UILabel = {
        let label = UILabel()
        label.text = "Total Cases"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textColor = UIColor.darkText
        return label
    }()
    
    let totalCasesNumber: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    let deathLabel: UILabel = {
        let label = UILabel()
        label.text = "Total Death"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textColor = UIColor.darkText
        return label
    }()
    let deathNumber: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        label.textColor = #colorLiteral(red: 0.4218355429, green: 0.01088446572, blue: 0, alpha: 1)
        return label
    }()
    let deathPercent: UILabel = {
        let label = UILabel()
        label.text = "(0%)"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        label.textColor = #colorLiteral(red: 0.4218355429, green: 0.01088446572, blue: 0, alpha: 1)
        return label
    }()
    
    let recoveredLabel: UILabel = {
        let label = UILabel()
        label.text = "Total Recovered"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textColor = UIColor.darkText
        return label
    }()
    let recoveredNumber: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        label.textColor = #colorLiteral(red: 0.04178928651, green: 0.5608921244, blue: 0, alpha: 1)
        return label
    }()
    let recoveredPercent: UILabel = {
        let label = UILabel()
        label.text = "(0%)"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        label.textColor = #colorLiteral(red: 0.04178928651, green: 0.5608921244, blue: 0, alpha: 1)
        return label
    }()
    
    let totalCaseTitle: UILabel = {
        let label = UILabel()
        label.text = "Total Cases Linear Graph"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        label.textColor = UIColor.darkText
        return label
    }()
    var totalCaseView: UIView = {
        let view = UIView()
        return view
    }()
    
    let totalDeathTitle: UILabel = {
        let label = UILabel()
        label.text = "Total Deaths Linear Graph"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        label.textColor = UIColor.darkText
        return label
    }()
    var totalDeathView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI(){
        contentView.addSubview(totalCaseLabel)
        totalCaseLabel.easy.layout(Top(46), CenterX())
        
        contentView.addSubview(totalCasesNumber)
        totalCasesNumber.easy.layout(Top(15).to(totalCaseLabel, .bottom),CenterX())
        
        contentView.addSubview(deathLabel)
        deathLabel.easy.layout(Top(55).to(totalCasesNumber, .bottom), CenterX())
        
        contentView.addSubview(deathNumber)
        deathNumber.easy.layout(Top(15).to(deathLabel, .bottom), CenterX())
        
        contentView.addSubview(deathPercent)
        deathPercent.easy.layout(Top().to(deathNumber, .bottom), CenterX())
        
        contentView.addSubview(recoveredLabel)
        recoveredLabel.easy.layout(Top(55).to(deathPercent, .bottom), CenterX())
        
        contentView.addSubview(recoveredNumber)
        recoveredNumber.easy.layout(Top(15).to(recoveredLabel, .bottom), CenterX())
        
        contentView.addSubview(recoveredPercent)
        recoveredPercent.easy.layout(Top().to(recoveredNumber, .bottom), CenterX())
        
        contentView.addSubview(totalCaseTitle)
        totalCaseTitle.easy.layout(Top(60).to(recoveredPercent, .bottom), CenterX())
        
        contentView.addSubview(totalCaseView)
        totalCaseView.easy.layout(Top(10).to(totalCaseTitle, .bottom), Left(15), Right(15), Height(250))
        
        contentView.addSubview(totalDeathTitle)
        totalDeathTitle.easy.layout(Top(60).to(totalCaseView, .bottom), CenterX())
        
        contentView.addSubview(totalDeathView)
        totalDeathView.easy.layout(Top(10).to(totalDeathTitle, .bottom), Left(15), Right(15), Height(250), Bottom(15))
        
        scrollView.addSubview(contentView)
        contentView.easy.layout(Edges(),
                                Width(UIScreen.main.bounds.width))
        
        self.addSubview(scrollView)
        scrollView.easy.layout(Edges())
    }
    
    func populateContent(total: Int, death: Int, recovered: Int){
        guard total != 0 else { return }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let totalNum = numberFormatter.string(from: NSNumber(value:total))
        totalCasesNumber.text = totalNum ?? "\(total)"
        let totalDeath = numberFormatter.string(from: NSNumber(value: death))
        deathNumber.text = totalDeath ?? "\(death)"
        deathPercent.text = "(\((death * 100)/total)%)"
        let totalRecover = numberFormatter.string(from: NSNumber(value: recovered))
        recoveredNumber.text = totalRecover ?? "\(recovered)"
        recoveredPercent.text = "(\((recovered * 100)/total)%)"
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
}
