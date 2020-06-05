//
//  StatisticsBarChartLogic.swift
//  Test
//
//  Created by Dante Kim on 5/19/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import Foundation
import UIKit
import Charts

extension StatisticsController {
    //MARK: - Create Charts
    @objc final func updateBarChartToWeek(notificaton: NSNotification) {
        noDataLabel.removeFromSuperview()
        resetChartValueSelected()
        daySessionDict = [:]
        setDateToToday()
        createWeekBarChart()
    }
    
    @objc final func updateBarChartToMonth(notificaton: NSNotification) {
        noDataLabel.removeFromSuperview()
        resetChartValueSelected()
        daySessionDict = [:]
        setDateToToday()
        createMonthBarChart()
        barChartView.animate(xAxisDuration: 1.5, easingOption: .easeOutExpo)
        barChartView.animate(yAxisDuration: 1.5, easingOption: .easeOutExpo)
    }
    
    @objc final func updateBarChartToYear(notificaton: NSNotification) {
        noDataLabel.removeFromSuperview()
        resetChartValueSelected()
        monthSessionDict = [:]
        setDateToToday()
        createYearBarChart()
        barChartView.animate(xAxisDuration: 1.5, easingOption: .easeOutExpo)
        barChartView.animate(yAxisDuration: 1.5, easingOption: .easeOutExpo)
    }
    final func setDateToToday() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        todayMonth = formatter.string(from: Date())
        formatter.dateFormat = "E"
        todayDayOfWeek = formatter.string(from: Date())
        formatter.dateFormat = "d"
        todayNum = Int(formatter.string(from: Date()))!
        formatter.dateFormat = "yyyy"
        todayYear = formatter.string(from: Date())
        switch todayDayOfWeek {
        case "Sun":
            begWeekNum = todayNum - 0
        case "Mon":
            begWeekNum = todayNum - 1
        case "Tue":
            begWeekNum = todayNum - 2
        case "Wed":
            begWeekNum = todayNum - 3
        case "Thu":
            begWeekNum = todayNum - 4
        case "Fri":
            begWeekNum = todayNum - 5
        case "Sat":
            begWeekNum = todayNum - 6
        default:
            print("rise")
        }
        endWeekNum = begWeekNum + 6
        if begWeekNum == 0 {
            nextMonth = todayMonth
            let thisMonth = dateHelper.getMonthNum(month: todayMonth)
            let lastMonth = dateHelper.intToMonth(num: thisMonth - 1)
            todayMonth = lastMonth
            begWeekNum = dateHelper.getNumberOfDays(month: lastMonth)
            if menuLabel == "Month" {
                    todayMonth = nextMonth
                }
        }
      
    
        
    }
    
    //MARK: - create charts
    final func createWeekBarChart() {
        dateLabel.text = "\(todayMonth) \(begWeekNum)  - \(nextMonth) \(endWeekNum), \(todayYear)"
        let set = createWeekData()
        let yAxis = barChartView.leftAxis
        if set.entries == BarChartUtil.createEmptyWeekData() {
            view.addSubview(noDataLabel)
            noDataLabel.center(in: barChartView)
        }
        set.drawValuesEnabled = false
        set.colors = [brightPurple]
        
        let data = BarChartData(dataSet: set)
        barChartView.data = data
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        let days = ["","Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        xAxis.labelFont = UIFont(name: "Menlo", size: 10)!
        xAxis.labelCount = 7
        xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        barChartView.xAxis.granularity = 1
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        xAxis.axisLineColor = backgroundColor
        
        
        yAxis.axisLineColor = backgroundColor
        yAxis.axisMinimum = 0
        barChartView.animate(xAxisDuration: 1.5, easingOption: .easeOutExpo)
        barChartView.animate(yAxisDuration: 1.5, easingOption: .easeOutExpo)
        totalMinutesLabel.text = "Total: \(totalMinutes) minutes"
        createWeekPieChart()
        
    }
    
    
     final func createMonthBarChart() {
        dateLabel.text = "\(todayMonth), \(todayYear)"
        let set = createMonthData()
        let yAxis = barChartView.leftAxis
        if set.entries == BarChartUtil.createEmptyMonthData() {
            view.addSubview(noDataLabel)
            noDataLabel.center(in: barChartView)
        }
        set.drawValuesEnabled = false
        set.colors = [brightPurple]
        let data = BarChartData(dataSet: set)
        barChartView.data = data
        barChartView.highlightValue(x: 1.0, dataSetIndex: 1, stackIndex: 1)
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont(name: "Menlo", size: 10)!
        let numDays = dateHelper.getNumberOfDays(month: todayMonth)
        xAxis.labelCount = numDays
        var days = [String]()
        days.append("")
        let firstDay = "\(dateHelper.getMonthNum(month: todayMonth))/1"
        days.append(firstDay)
        for i in 2...numDays {
            if i % 8 == 0 || i == numDays{
                days.append(String(i))
            } else {
                days.append("")
            }
        }
        
        xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        barChartView.xAxis.granularity = 1
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        xAxis.axisLineColor = backgroundColor
        
        yAxis.axisLineColor = backgroundColor
        yAxis.axisMinimum = 0
        
        
        totalMinutesLabel.text = "Total: \(totalMinutes) minutes"
        createMonthPieChart()
    }
    
    final func createYearBarChart() {
        dateLabel.text = todayYear
        let set = createYearData()
        set.colors = [brightPurple]
        if set.entries == BarChartUtil.createEmptyYearData() {
            view.addSubview(noDataLabel)
            noDataLabel.center(in: barChartView)
        }
        set.drawValuesEnabled = false
        let data = BarChartData(dataSet: set)
        barChartView.data = data
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont(name: "Menlo", size: 8)!
        xAxis.labelCount = 12
        let months = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul","Aug","Sep","Oct","Nov","Dec"]
        xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        
        totalMinutesLabel.text = "Total: \(totalMinutes) minutes"
        createYearPieChart()
    }
    
    private final func createYearData() -> BarChartDataSet {
        var entries = BarChartUtil.createEmptyYearData()
        thisYearArray = [String]()
        for day in timeData {
            if day.contains(todayYear) {
                thisYearArray.append(day)
            }
        }
        totalMinutes = 0
        for day in thisYearArray {
            let equalIndex = day.firstIndex(of: "=")
            let equalIndexOffset = day.index(equalIndex!, offsetBy: 1)
            let dashIndex = day.firstIndex(of: "-")
            let spaceIndex = day.firstIndex(of: " ")
            let plusIndex = day.firstIndex(of: "+")
            let dashIndexOffset = day.index(dashIndex!, offsetBy: 1)
            let totalTimeForDay = String(day[equalIndexOffset..<dashIndex!])
            let totalSessionsForDay = String(Int(day[dashIndexOffset..<plusIndex!])!)
            let month = String(day[..<spaceIndex!])
            if monthSessionDict[month] == nil {
                monthSessionDict[month] = Int(totalSessionsForDay)
            } else {
                monthSessionDict[month]! += Int(totalSessionsForDay)!
            }
            totalMinutes += Int(totalTimeForDay)!
            if day.contains("Jan") {
                entries[0].y = entries[0].y + Double(Int(totalTimeForDay)!)
            } else if day.contains("Feb") {
                entries[1].y = entries[1].y + Double(Int(totalTimeForDay)!)
            } else if day.contains("Mar") {
                entries[2].y = entries[2].y + Double(Int(totalTimeForDay)!)
            } else if day.contains("Apr") {
                entries[3].y = entries[3].y + Double(Int(totalTimeForDay)!)
            } else if day.contains("May") {
                entries[4].y = entries[4].y + Double(Int(totalTimeForDay)!)
            } else if day.contains("Jun") {
                entries[5].y = entries[5].y + Double(Int(totalTimeForDay)!)
            } else if day.contains("Jul") {
                entries[6].y = entries[6].y + Double(Int(totalTimeForDay)!)
            } else if day.contains("Aug") {
                entries[7].y = entries[7].y + Double(Int(totalTimeForDay)!)
            } else if day.contains("Sep") {
                entries[8].y = entries[8].y + Double(Int(totalTimeForDay)!)
            } else if day.contains("Oct") {
                entries[9].y = entries[9].y + Double(Int(totalTimeForDay)!)
            } else if day.contains("Nov") {
                entries[10].y = entries[10].y + Double(Int(totalTimeForDay)!)
            } else if day.contains("Dec") {
                entries[11].y = entries[11].y + Double(Int(totalTimeForDay)!)
            }
        }
        entries.sort(by: { $0.x < $1.x })
        let set = BarChartDataSet(entries: entries, label: "Minutes")
        return set
    }
    
    //MARK: - Create Chart Data
    private final func createWeekData() -> BarChartDataSet {
        thisWeekArray = [String]()
        thisMonthArray = [String]()
       
        for day in timeData {
            if day.contains(todayMonth) {
                if day.contains(todayYear) {
                    thisMonthArray.append(day)
                } else if todayMonth == "Dec" && nextMonth == "Jan" {
                    if day.contains(String(Int(todayYear)! - 1)) {
                        thisMonthArray.append(day)
                    }
                }
            }
        }
        if nextMonth != "" {
            for day in timeData {
                if day.contains(nextMonth) {
                    if day.contains(todayYear) {
                        thisMonthArray.append(day)
                    } else if todayMonth == "Dec" && nextMonth == "Jan" {
                        if day.contains(String(Int(todayYear)! - 1)) {
                            thisMonthArray.append(day)
                        }
                    }
                }
            }
        }
        if nextMonth == "" {
            for day in thisMonthArray {
                for i in (begWeekNum...endWeekNum) {
                    if day.contains(todayMonth  + " " + String(i) + "," + todayYear) {
                        thisWeekArray.append(day)
                    }
                }
            }
        } else {
            for day in thisMonthArray {
                let daysInThisMonth = dateHelper.getNumberOfDays(month: todayMonth)
                for i in (begWeekNum...daysInThisMonth) {
                    if day.contains(todayMonth  + " " + String(i) + "," + todayYear) {
                        thisWeekArray.append(day)
                    }
                }
                for i in (1...endWeekNum) {
                    if day.contains(nextMonth  + " " + String(i) + "," + todayYear) {
                        thisWeekArray.append(day)
                    }
                }
            }
        }
        
        totalMinutes = 0
        var entries = BarChartUtil.createEmptyWeekData()
        for day in thisWeekArray {
            let equalIndex = day.firstIndex(of: "=")
            let spaceIndex = day.secondIndex(of: " ")
            let plusIndex = day.firstIndex(of: "+")
            let equalIndexOffset = day.index(equalIndex!, offsetBy: 1)
            let dashIndex = day.firstIndex(of: "-")
            let dashIndexOffset = day.index(dashIndex!, offsetBy: 1)
            let totalSessionsForDay = String(Int(day[dashIndexOffset..<plusIndex!])!)
            let date =  String(day[..<spaceIndex!])
            
            daySessionDict[date] = Int(totalSessionsForDay)
            let totalTimeForDay = String(day[equalIndexOffset..<dashIndex!])
            totalMinutes += Int(totalTimeForDay)!
            if day.contains("Sun") {
                entries[0] = (BarChartDataEntry(x: 1.0, y: Double(Int(totalTimeForDay)!)))
            } else if day.contains("Mon") {
                entries[1] = (BarChartDataEntry(x: 2.0, y: Double(Int(totalTimeForDay)!)))
            } else if day.contains("Tue") {
                entries[2] = (BarChartDataEntry(x: 3.0, y: Double(Int(totalTimeForDay)!)))
            } else if day.contains("Wed") {
                entries[3] = (BarChartDataEntry(x: 4.0, y: Double(Int(totalTimeForDay)!)))
            } else if day.contains("Thu") {
                entries[4] = (BarChartDataEntry(x: 5.0, y: Double(Int(totalTimeForDay)!)))
            } else if day.contains("Fri") {
                entries[5] = (BarChartDataEntry(x: 6.0, y: Double(Int(totalTimeForDay)!)))
            } else if day.contains("Sat") {
                entries[6] = (BarChartDataEntry(x: 7.0, y: Double(Int(totalTimeForDay)!)))
            }
        }
        let set = BarChartDataSet(entries: entries, label: "Minutes")
        return set
    }
    
    private final func createMonthData() -> BarChartDataSet {
        var entries = BarChartUtil.createEmptyMonthData()
        thisMonthArray = [String]()
        
      for day in timeData {
                if day.contains(todayMonth) {
                    if day.contains(todayYear) {
                        thisMonthArray.append(day)
                    }
                }
            }
        totalMinutes = 0
        for day in thisMonthArray {
            let equalIndex = day.firstIndex(of: "=")
            let commaIndex = day.firstIndex(of: ",")
            let dashIndex = day.firstIndex(of: "-")
            let spaceIndex = day.secondIndex(of: " ")
            let dashIndexOffset = day.index(dashIndex!, offsetBy: 1)
            let startIndexBef = day.firstIndex(of: " ")
            let startIndex = day.index(startIndexBef!, offsetBy: 1)
            let dayNum = Int(day[startIndex..<commaIndex!])!
            let equalIndexOffset = day.index(equalIndex!, offsetBy: 1)
            let totalTimeForDay = String(day[equalIndexOffset..<dashIndex!])
            let plusIndex = day.firstIndex(of: "+")
            let totalSessionsForDay = String(Int(day[dashIndexOffset..<plusIndex!])!)
            let date =  String(day[..<spaceIndex!])
            daySessionDict[date] = Int(totalSessionsForDay)
            entries[dayNum - 1] = BarChartDataEntry(x: Double(dayNum), y: Double(Int(totalTimeForDay)!))
            totalMinutes += Int(totalTimeForDay)!
        }
        let set = BarChartDataSet(entries: entries, label: "Minutes")
        return set
    }
  
    //MARK: - minute/session logic
    //For Labels below bar chart
    final func resetChartValueSelected() {
        barPressedTitle.text = "No Bar Selected"
        barMinNumLabel.text = "0"
        barSessNumLabel.text = "0"
    }
    
    
    final func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        var sessNum = 0
        let numDays = dateHelper.getNumberOfDays(month: todayMonth)
        print(entry.x)
        print(begWeekNum)
        if menuLabel == "Week" {
            if nextMonth == "" {
                barPressedTitle.text = "\(todayMonth) \(begWeekNum + Int(entry.x) - 1), \(todayYear)"
                sessNum = daySessionDict["\(todayMonth) \(begWeekNum + Int(entry.x) - 1),\(todayYear)"] ?? 0
            } else {
                if begWeekNum + Int(entry.x) > numDays + 1 {
                    let start = numDays - begWeekNum + 1
                    barPressedTitle.text = "\(nextMonth) \(Int(entry.x) - start), \(todayYear)"
                    sessNum = daySessionDict["\(nextMonth) \(Int(entry.x) - start),\(todayYear)"] ?? 0
                } else {
                    barPressedTitle.text = "\(todayMonth) \(begWeekNum + Int(entry.x)  - 1), \(todayYear)"
                    sessNum = daySessionDict["\(todayMonth) \(begWeekNum + Int(entry.x) - 1),\(todayYear)"] ?? 0
                }
            }
       
        } else if menuLabel == "Month" {
            barPressedTitle.text = "\(todayMonth) \(Int(entry.x)), \(todayYear)"
            sessNum = daySessionDict["\(todayMonth) \(Int(entry.x)),\(todayYear)"] ?? 0
        } else if menuLabel == "Year" {
            barPressedTitle.text = dateHelper.intToMonth(num: Int(entry.x))
            let getMonth = dateHelper.intToMonth(num: Int(entry.x))
            sessNum = monthSessionDict[getMonth] ?? 0
        }
        barMinNumLabel.removeFromSuperview()
        barMinNumLabel.text = String(Int(entry.y))
        barMinNumLabel.sizeToFit()
        
        barSessNumLabel.removeFromSuperview()
        barSessNumLabel.text = String(sessNum)
        barSessNumLabel.sizeToFit()
        view.addSubview(barMinNumLabel)
        view.addSubview(barSessNumLabel)
        barMinNumLabel.topToBottom(of: barPressedTitle, offset: 30)
        if String(Int(entry.y)).count == 2 {
            barMinNumLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80).isActive = true
        } else if String(Int(entry.y)).count == 3 {
            barMinNumLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 65).isActive = true
        } else if String(Int(entry.y)).count == 1 {
            barMinNumLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90).isActive = true
        } else {
            barMinNumLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        }
        
        barSessNumLabel.topToBottom(of: barPressedTitle, offset: 30)
        if String(sessNum).count == 1{
            barSessNumLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90).isActive = true
        } else if String(sessNum).count == 2 {
            barSessNumLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70).isActive = true
        } else if String(sessNum).count == 3 {
            barSessNumLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -55).isActive = true
        } else {
            barSessNumLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        }
    }
    
}
