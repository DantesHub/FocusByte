//
//  BarChartDataUtil.swift
//  Test
//
//  Created by Dante Kim on 5/19/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import Charts

class BarChartUtil {
    static func createEmptyMonthData() -> [BarChartDataEntry] {
        var entries = [BarChartDataEntry]()
        let numOfDays = DateHelper().getNumberOfDays(month: todayMonth)
        for i in 1...numOfDays {
            entries.append(BarChartDataEntry(x: Double(i), y: 0))
        }
        return entries
    }
    
    static  func createEmptyWeekData() -> [BarChartDataEntry] {
        return     [
            BarChartDataEntry(x: 1.0, y: 0.0),
            BarChartDataEntry(x: 2.0, y: 0.0),
            BarChartDataEntry(x: 3.0, y: 0.0),
            BarChartDataEntry(x: 4.0, y: 0.0),
            BarChartDataEntry(x: 5.0, y: 0.0),
            BarChartDataEntry(x: 6.0, y: 0.0),
            BarChartDataEntry(x: 7.0, y: 0.0)
        ]
    }
    
    static func createEmptyYearData() -> [BarChartDataEntry] {
        return [
            BarChartDataEntry(x: 1.0, y: 0.0),
            BarChartDataEntry(x: 2.0, y: 0.0),
            BarChartDataEntry(x: 3.0, y: 0.0),
            BarChartDataEntry(x: 4.0, y: 0.0),
            BarChartDataEntry(x: 5.0, y: 0.0),
            BarChartDataEntry(x: 6.0, y: 0.0),
            BarChartDataEntry(x: 7.0, y: 0.0),
            BarChartDataEntry(x: 8.0, y: 0.0),
            BarChartDataEntry(x: 9.0, y: 0.0),
            BarChartDataEntry(x: 10.0, y: 0.0),
            BarChartDataEntry(x: 11.0, y: 0.0),
            BarChartDataEntry(x: 12.0, y: 0.0)
        ]
    }
}
