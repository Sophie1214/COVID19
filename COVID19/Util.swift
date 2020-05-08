//
//  Util.swift
//  COVID19
//
//  Created by Fei Su on 2020-04-15.
//  Copyright © 2020 Fei Su. All rights reserved.
//

import Foundation
import SwiftCharts

enum CaseType {
    case totalCase
    case totalDeath
    case totalRecovered
}

class Util {
    
    static func parseTimeStamp(_ timeStamp: String) -> Date? {
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        if let date = dateFormat.date(from: timeStamp) {
            return date
        }
        return nil
    }
    
    static func dateToDayString(_ date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.timeZone = TimeZone.current
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter.string(from: date)
    }
    
    static func dateToDayOfMonth(_ date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.timeZone = TimeZone.current
        dateformatter.dateFormat = "MMM dd"
        return dateformatter.string(from: date)
    }
    
    static func dateToBeginningOfDay(_ date: Date) -> Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
    }
    
    static func createChart(data: [Country], view: UIView, multiple: Double, lineColor: UIColor, caseType: CaseType) -> Chart {
        let labelSettings = ChartLabelSettings()
        
        var valueArray: [(Date, Int)] = []
        for day in data {
            var number: Int
            switch caseType {
            case .totalCase:
                number = day.totalCases
            case .totalDeath:
                number = day.totalDeaths
            case .totalRecovered:
                number = day.totalRecovered
            }
            valueArray.append((day.date, number))
        }
        
        let xlabelSettings = ChartLabelSettings(font: UIFont.systemFont(ofSize: 12), fontColor: UIColor.darkGray, rotation: -60, rotationKeep: .top, shiftXOnRotation: true, textAlignment: .default)
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM dd"
        
        let chartPoints: [ChartPoint] = valueArray.map{ChartPoint(x: ChartAxisValueDate(date: $0.0, formatter: displayFormatter), y: ChartAxisValueDouble($0.1))}
        
        let xGeneratorDate = ChartAxisLabelsGeneratorDate(labelSettings: xlabelSettings, formatter: displayFormatter)
        let xGenerator = ChartAxisValuesGeneratorDate(unit: .day, preferredDividers:8, minSpace: 1, maxTextSize: 12)
        
        //        let labelsGenerator = ChartAxisLabelsGeneratorFunc { [unowned self] scalar in
        //            return ChartAxisLabel(text: Util.dateToDayOfMonth(self.worldDayData[Int(scalar)].date), settings: xlabelSettings)
        //        }
        
        let yValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(chartPoints, minSegmentCount: 5, maxSegmentCount: 5, multiple: multiple, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: false)
        
        
        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: lineColor, lineWidth: 5, animDuration: 0, animDelay: 0)
        
        let xModel = ChartAxisModel(firstModelValue: data.first!.date.timeIntervalSince1970, lastModelValue: data.last!.date.timeIntervalSince1970, axisTitleLabels: [ChartAxisLabel(text: "", settings: labelSettings)], axisValuesGenerator: xGenerator, labelsGenerator: xGeneratorDate)
        
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Total Cases", settings: labelSettings.defaultVertical()))
        let chartFrame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
        
        let chartSettings = getChartSettings()
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel], pathGenerator: CubicLinePathGenerator(tension1: 0.2, tension2: 0.2))
        
        let settings = ChartGuideLinesLayerSettings(linesColor: UIColor.black, linesWidth: 0.1)
        let guidelinesLayer = ChartGuideLinesLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, axis: .y, settings: settings)
        
        let chart = Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                guidelinesLayer,
                chartPointsLineLayer,
            ]
        )
        
        return chart
    }
    
    fileprivate static func getChartSettings() -> ChartSettings {
        var chartSettings = ChartSettings()
        chartSettings.leading = 10
        chartSettings.top = 10
        chartSettings.trailing = 10
        chartSettings.bottom = 10
        chartSettings.labelsToAxisSpacingX = 5
        chartSettings.labelsToAxisSpacingY = 5
        chartSettings.axisTitleLabelsToLabelsSpacing = 4
        chartSettings.axisStrokeWidth = 0.2
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8
        chartSettings.labelsSpacing = 0
        return chartSettings
    }
}
