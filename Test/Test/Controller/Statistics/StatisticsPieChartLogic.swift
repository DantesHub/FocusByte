import UIKit
import Foundation
import Charts


extension StatisticsController {
    
    //MARK: - Create Charts
    final func createWeekPieChart() {
        let dataSet = createWeekPieData()
        dataSet.colors = colors
//        dataSet.drawValuesEnabled =
        let data = PieChartData(dataSet: dataSet)
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 3
        formatter.percentSymbol = "%"
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        pieChartView.data = data
        pieChartView.drawSlicesUnderHoleEnabled = true
        pieChartView.legend.calculateDimensions(labelFont: UIFont(name: "Menlo", size: 10)!, viewPortHandler: .init(width: 1000, height: 1000))

    }
    
    final func createMonthPieChart() {
        let dataSet = createMonthPieData()
        dataSet.colors = colors
        //        dataSet.drawValuesEnabled =
        let data = PieChartData(dataSet: dataSet)
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 3
        formatter.percentSymbol = "%"
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        pieChartView.data = data
        pieChartView.drawSlicesUnderHoleEnabled = true
        pieChartView.legend.calculateDimensions(labelFont: UIFont(name: "Menlo", size: 10)!, viewPortHandler: .init(width: 1000, height: 1000))
    }
    
    final func createYearPieChart() {
        let dataSet = createYearPieData()
        dataSet.colors = colors
        //        dataSet.drawValuesEnabled =
        let data = PieChartData(dataSet: dataSet)
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 3
        formatter.percentSymbol = "%"
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        pieChartView.data = data
        pieChartView.drawSlicesUnderHoleEnabled = true
        pieChartView.legend.calculateDimensions(labelFont: UIFont(name: "Menlo", size: 10)!, viewPortHandler: .init(width: 100, height: 100))
    }
    
    
    //MARK: - Create Data
    private final func createWeekPieData() -> PieChartDataSet {
        let entries = addDataToTagDictionary(array: thisWeekArray)
        tagTimeDictionary = [:]
        let set = PieChartDataSet(entries: entries, label: "")
        set.drawValuesEnabled = true
        set.sliceSpace = 1.0
        return set
    }
    
    private final func createMonthPieData() -> PieChartDataSet {
        let entries = addDataToTagDictionary(array: thisMonthArray)
        
        tagTimeDictionary = [:]
        let set = PieChartDataSet(entries: entries, label: "")
        set.sliceSpace = 1.0
        set.drawValuesEnabled = true
        return set
    }
    
    private final func createYearPieData() -> PieChartDataSet {
        let entries = addDataToTagDictionary(array: thisYearArray)
        tagTimeDictionary = [:]
        let set = PieChartDataSet(entries: entries, label: "")
        set.sliceSpace = 1.0
        set.drawValuesEnabled = true
        return set
    }
    
    private final func addDataToTagDictionary(array: [String]) -> [PieChartDataEntry] {
        for day in array {
            var time = 0
            for tag in tagDictionary {
                if day.contains(tag.name) {
                    //get time from string
                    if let begIndex = day.index(of: tag.name) {
                        let secondHalf = String(day[begIndex...])
                        let slashIndex = secondHalf.firstIndex(of: "/")
                        let slashIndexOffset = secondHalf.index(slashIndex!, offsetBy: 1)
                        let pIndex = secondHalf.firstIndex(of: "+") ?? String.Index(encodedOffset: secondHalf.count)
                        time = Int(String(secondHalf[slashIndexOffset..<pIndex]))!
                    }
                    if tagTimeDictionary[tag.name] != nil {
                        tagTimeDictionary[tag.name]! += time
                    } else {
                        tagTimeDictionary[tag.name] = time
                    }
                }
            }
        }
        
        var entries = PieChartUtil.createEmptyPieData(len: tagTimeDictionary.count)
        if array.count != 0 {
            for (i, tag)  in tagTimeDictionary.enumerated() {
                let calculatedTime = Double(tag.value)/Double(totalMinutes)
                let col = K.getColor(color: PieChartUtil.getTagColor(tagTitle: tag.key))
                colors[i] = col
                entries[i] = (PieChartDataEntry(value: calculatedTime.rounded(toPlaces: 2), label: tag.key))
            }
        }
        return entries

    }
    
}


