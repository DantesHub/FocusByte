
import Foundation
import UIKit

extension TimerController {
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
        let thisMonth = dateHelper.getMonthNum(month: todayMonth)
        let lastMonth = dateHelper.intToMonth(num: thisMonth - 1)
        if begWeekNum == 0 {
            nextMonth = todayMonth
            todayMonth = lastMonth
            begWeekNum = dateHelper.getNumberOfDays(month: lastMonth)
            if menuLabel == "Month" {
                todayMonth = nextMonth
            }
        } else if begWeekNum < 0 {
            nextMonth = todayMonth
            todayMonth = lastMonth
            begWeekNum = begWeekNum + dateHelper.getNumberOfDays(month: lastMonth)
        }  else if endWeekNum > dateHelper.getNumberOfDays(month: todayMonth) {
            nextMonth = dateHelper.intToMonth(num: thisMonth + 1)
            endWeekNum = endWeekNum -  dateHelper.getNumberOfDays(month: todayMonth)
        }
    }
    func getWidgetData(timeData: [String]) -> [String] {
        setDateToToday()
        monthArray = [String]()
        weekArray = [String]()
        for day in timeData {
            if day.contains(todayMonth) {
                if day.contains(todayYear) {
                    monthArray.append(day)
                } else if todayMonth == "Dec" && nextMonth == "Jan" {
                    if day.contains(String(Int(todayYear)! - 1)) {
                        monthArray.append(day)
                    }
                }
            }
        }
        if nextMonth != "" {
            for day in timeData {
                if day.contains(nextMonth) {
                    if day.contains(todayYear) {
                        monthArray.append(day)
                    } else if todayMonth == "Dec" && nextMonth == "Jan" {
                        if day.contains(String(Int(todayYear)! - 1)) {
                            monthArray.append(day)
                        }
                    }
                }
            }
        }
        if nextMonth == "" {
            for day in monthArray {
                for i in (begWeekNum...endWeekNum) {
                    if day.contains(todayMonth  + " " + String(i) + "," + todayYear) {
                        weekArray.append(day)
                    }
                }
            }
        } else {
            for day in monthArray {
                let daysInThisMonth = dateHelper.getNumberOfDays(month: todayMonth)
                for i in (begWeekNum...daysInThisMonth) {
                    if day.contains(todayMonth  + " " + String(i) + "," + todayYear) {
                        weekArray.append(day)
                    }
                }
                for i in (1...endWeekNum) {
                    if day.contains(nextMonth  + " " + String(i) + "," + todayYear) {
                        weekArray.append(day)
                    }
                }
            }
        }
        var entries: [String] = ["0","0","0","0","0","0","0"]
        print(weekArray, "weekArray")
        var totalMins = 0
        var noData = true
        for day in weekArray {
            let equalIndex = day.firstIndex(of: "=")
            let equalIndexOffset = day.index(equalIndex!, offsetBy: 1)
            let dashIndex = day.firstIndex(of: "-")
            let totalTimeForDay = String(day[equalIndexOffset..<dashIndex!])
            if day.contains("Sun") {
                entries[0] = ((totalTimeForDay))
            } else if day.contains("Mon") {
                entries[1] = ((totalTimeForDay))
                totalMins += Int(totalTimeForDay) ?? 0
                noData = false
            } else if day.contains("Tue") {
                entries[2] = ((totalTimeForDay))
                totalMins += Int(totalTimeForDay) ?? 0
                noData = false
            } else if day.contains("Wed") {
                entries[3] = ((totalTimeForDay))
                noData = false
                totalMins += Int(totalTimeForDay) ?? 0
            } else if day.contains("Thu") {
                entries[4] = ((totalTimeForDay))
                noData = false
                totalMins += Int(totalTimeForDay) ?? 0
            } else if day.contains("Fri") {
                entries[5] = ((totalTimeForDay))
                noData = false
                totalMins += Int(totalTimeForDay) ?? 0
            } else if day.contains("Sat") {
                entries[6] = ((totalTimeForDay))
                noData = false
                totalMins += Int(totalTimeForDay) ?? 0
            }
        }
        if UserDefaults.standard.bool(forKey: "isPro") {
            userDefaults?.setValue(noData, forKey:"noData")
            userDefaults?.setValue(totalMins, forKey: "totalMins")
        } else {
            userDefaults?.setValue(false, forKey:"noData")
            userDefaults?.setValue(0, forKey: "totalMins")
        }
        return entries
    }
    
}
