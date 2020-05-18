//
//  InventoryController.swift
//  Test
//
//  Created by Dante Kim on 5/13/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import UIKit
import TinyConstraints
import Charts
import Realm
import RealmSwift
var todayYear = ""

class StatisticsController: UIViewController, ChartViewDelegate{
    //MARK: - Variables
    var delegate: ContainerControllerDelegate!
    lazy var barChartView: BarChartView = {
        let barView = BarChartView()
        barView.backgroundColor = backgroundColor
        return barView
    }()
    lazy var monthChartView: BarChartView = {
        let barView = BarChartView()
        barView.backgroundColor = backgroundColor
        return barView
    }()
    let menuBar: MenuBar = {
           let mb = MenuBar()
           return mb
    }()
    var results: Results<User>!
    var timeData = [String]()
    var dateLabel = UILabel()
    var totalMinutesLabel = UILabel()
    var totalMinutes = 0
    var totalSessions = 0
    var barMinNumLabel = UILabel()
    var barMinDescLabel = UILabel()
    var barSessNumLabel = UILabel()
    var barSessDescLabel = UILabel()
    var barPressedTitle = UILabel()
    lazy var nextButton: UIButton = {
       let button = UIButton()
        let largeConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        let carrotGreat = UIImage(systemName: "greaterthan", withConfiguration: largeConfiguration)
        let carrotGreat2 = carrotGreat?.resized(to: CGSize(width: 25, height: 25)).withTintColor(.white, renderingMode:.alwaysOriginal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(carrotGreat2, for: .normal)
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return button
    }()
    lazy var backButton: UIButton = {
         let button = UIButton()
          let largeConfiguration = UIImage.SymbolConfiguration(weight: .bold)
          let carrotGreat = UIImage(systemName: "lessthan", withConfiguration: largeConfiguration)
          let carrotGreat2 = carrotGreat?.resized(to: CGSize(width: 25, height: 25)).withTintColor(.white, renderingMode:.alwaysOriginal)
          button.translatesAutoresizingMaskIntoConstraints = false
          button.setImage(carrotGreat2, for: .normal)
          button.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
          return button
      }()
    var begWeekNum = 0
    var endWeekNum = 0
    var todayNum = 0
    var todayMonth = ""
    var todayDayOfWeek = ""
    var noDataLabel = UILabel()
    var nextMonth = ""
    let dateHelper = DateHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        createObservers()
        barChartView.delegate = self
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setDateToToday()
        endWeekNum = begWeekNum + 6
          results = uiRealm.objects(User.self)
          for result  in results {
              if result.isLoggedIn == true {
                self.timeData = result.timeArray.map{ $0 }
              }
          }
        createWeekBarChart()
        barChartView.animate(xAxisDuration: 1.5, easingOption: .easeInOutBack)
        barChartView.animate(yAxisDuration: 1.5, easingOption: .easeInOutBack)
        barChartView.isUserInteractionEnabled = true
        barChartView.dragEnabled = true
        barChartView.pinchZoomEnabled = false
        barChartView.drawBarShadowEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.getAxis(.right).enabled = false
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false
        barChartView.legend.enabled = false

      }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        self.navigationItem.title = "Statistics"
        setUpTabBar()
        configureNavigationBar(color: backgroundColor, isTrans: false)
         navigationItem.leftBarButtonItem =  UIBarButtonItem(image: resizedMenuImage?.withTintColor(.white), style: .plain, target: self, action: #selector(handleMenuToggle))
        view.backgroundColor = backgroundColor
        dateLabel.font = UIFont(name: "Menlo", size: 20)
        view.addSubview(dateLabel)
        dateLabel.topToBottom(of: menuBar, offset: 30)
        dateLabel.centerX(to: view)
        
        view.addSubview(backButton)
        backButton.topToBottom(of: menuBar, offset: 30)
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        
        view.addSubview(nextButton)
        nextButton.topToBottom(of: menuBar, offset: 30)
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        view.addSubview(barChartView)
        barChartView.edgesToSuperview(excluding: .bottom, insets:  TinyEdgeInsets(top: 140, left: 25, bottom: 0, right: 25))
        barChartView.height(300)
        
        totalMinutesLabel.text = "Total: \(totalMinutes) minutes"
        totalMinutesLabel.textColor = .white
        totalMinutesLabel.font = UIFont(name: "Menlo-Bold", size: 15)
        view.addSubview(totalMinutesLabel)
        totalMinutesLabel.topToBottom(of: dateLabel, offset: 20)
        totalMinutesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45).isActive = true
        
        noDataLabel.text = "No Data For \nThis Page :("
        noDataLabel.numberOfLines = 2
        noDataLabel.textColor = .white
        noDataLabel.font = UIFont(name: "Menlo-Bold", size: 25)
        
        barPressedTitle.text = "No Bar Selected"
        barPressedTitle.textColor = .black
        barPressedTitle.font = UIFont(name: "Menlo", size: 22)
        view.addSubview(barPressedTitle)
        barPressedTitle.centerXToSuperview()
        barPressedTitle.topToBottom(of: barChartView, offset: 30)
        
        //vertical line
        let path = UIBezierPath()
        path.move(to: CGPoint(x: view.center.x, y: view.center.y + 100))
        path.addLine(to: CGPoint(x: view.center.x, y: view.center.y + 200))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 4
        view.layer.addSublayer(shapeLayer)
        
        barMinNumLabel.text = "0"
        barMinNumLabel.textColor = .white
        barMinNumLabel.textAlignment = .center
        barMinNumLabel.font = UIFont(name: "Menlo-Bold", size: 50)
        barMinNumLabel.sizeToFit()
        view.addSubview(barMinNumLabel)
        barMinNumLabel.topToBottom(of: barPressedTitle, offset: 30)
        barMinNumLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90).isActive = true
        
        barMinDescLabel.text = "minutes"
        barMinDescLabel.textColor = .white
        barMinDescLabel.font = UIFont(name: "Menlo", size: 25)
        view.addSubview(barMinDescLabel)
        barMinDescLabel.topToBottom(of: barPressedTitle, offset: 85)
        barMinDescLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        
        barSessNumLabel.text = "0"
        barSessNumLabel.textColor = .white
        barSessNumLabel.font = UIFont(name: "Menlo-Bold", size: 50)
        view.addSubview(barSessNumLabel)
        barSessNumLabel.topToBottom(of: barPressedTitle, offset: 30)
        barSessNumLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90).isActive = true
        
        barSessDescLabel.text = "sessions"
        barSessDescLabel.textColor = .white
        barSessDescLabel.font = UIFont(name: "Menlo", size: 25)
        view.addSubview(barSessDescLabel)
        barSessDescLabel.topToBottom(of: barPressedTitle, offset: 85)
        barSessDescLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        

    }
  
    @objc func backTapped() {
        noDataLabel.removeFromSuperview()
        if menuLabel == "Week" {
            backWeekTapped()
        } else if menuLabel == "Month" {
            backMonthTapped()
        } else {
            backYearTapped()
        }
    }
    
     func backYearTapped() {
        noDataLabel.removeFromSuperview()
        todayYear = String(Int(todayYear)! - 1)
        createYearBarChart()
     }
    func backMonthTapped() {
        let monthNum = dateHelper.getMonthNum(month: todayMonth)
        if monthNum == 1 {
            todayYear = String(Int(todayYear)! - 1)
        }
        todayMonth = dateHelper.intToMonth(num: monthNum - 1)
        createMonthBarChart()
    }
    
    func backWeekTapped() {
        begWeekNum -= 7
        endWeekNum = begWeekNum + 6
        if todayMonth == "Jan"  {
            if begWeekNum < 1 {
                todayYear = String(Int(todayYear)! - 1)
            }
            if todayMonth == "Dec" && nextMonth == "Jan" {
                todayYear = String(Int(todayYear)! - 1)
            }
        }
        nextMonth = ""
        
        if begWeekNum == -6 {
            let todayMonthInt = dateHelper.getMonthNum(month: todayMonth)
            todayMonth = dateHelper.intToMonth(num: todayMonthInt - 1)
            begWeekNum =  dateHelper.getNumberOfDays(month: todayMonth) - 6
            endWeekNum = dateHelper.getNumberOfDays(month: todayMonth)
            createWeekBarChart()
            return
        }
        if begWeekNum <= 0 {
            let todayMonthInt = dateHelper.getMonthNum(month: todayMonth)
            nextMonth = todayMonth
            todayMonth = dateHelper.intToMonth(num: todayMonthInt - 1)
            begWeekNum = dateHelper.getNumberOfDays(month: todayMonth) + begWeekNum
        }
        createWeekBarChart()
    }
    @objc func nextTapped() {
        noDataLabel.removeFromSuperview()
            if menuLabel == "Week" {
                nextWeekTapped()
            } else if menuLabel == "Month" {
                nextMonthTapped()
            } else {
                nextYearTapped()
            }
    }
    func nextMonthTapped() {
        let monthNum = dateHelper.getMonthNum(month: todayMonth)
        if monthNum == 12 {
            todayYear = String(Int(todayYear)! + 1)
        }
        todayMonth = dateHelper.intToMonth(num: monthNum + 1)
        createMonthBarChart()
    }
    func nextYearTapped() {
        noDataLabel.removeFromSuperview()
        todayYear = String(Int(todayYear)! + 1)
        createYearBarChart()
    }
    func nextWeekTapped() {
        begWeekNum += 7
        endWeekNum = begWeekNum + 6
        if todayMonth == "Dec"  {
            if begWeekNum == 32 {
                todayYear = String(Int(todayYear)! + 1)
            }
            if nextMonth != "Jan" && begWeekNum + 6 > 31  {
                todayYear = String(Int(todayYear)! + 1)
            }
        }
        nextMonth = ""
        let numOfDays = dateHelper.getNumberOfDays(month: todayMonth)
        if begWeekNum > numOfDays {
            begWeekNum -= numOfDays
            endWeekNum = begWeekNum + 6
            let todayMonthInt = dateHelper.getMonthNum(month: todayMonth)
            todayMonth = dateHelper.intToMonth(num: todayMonthInt + 1)
        } else if begWeekNum == numOfDays {
            let todayMonthInt = dateHelper.getMonthNum(month: todayMonth)
            begWeekNum = numOfDays
            nextMonth = dateHelper.intToMonth(num: todayMonthInt + 1)
            endWeekNum = 6
        } else if endWeekNum > numOfDays {
            let todayMonthInt = dateHelper.getMonthNum(month: todayMonth)
            nextMonth = dateHelper.intToMonth(num: todayMonthInt + 1)
            endWeekNum -= numOfDays
        }
        
        createWeekBarChart()
    }
    @objc func updateBarChartToWeek(notificaton: NSNotification) {
        noDataLabel.removeFromSuperview()
         setDateToToday()
         createWeekBarChart()

      }
    
    @objc func updateBarChartToMonth(notificaton: NSNotification) {
         noDataLabel.removeFromSuperview()
         setDateToToday()
         createMonthBarChart()
         barChartView.animate(xAxisDuration: 1.5, easingOption: .easeOutExpo)
         barChartView.animate(yAxisDuration: 1.5, easingOption: .easeOutExpo)
    }
    
    @objc func updateBarChartToYear(notificaton: NSNotification) {
        noDataLabel.removeFromSuperview()
        setDateToToday()
        createYearBarChart()
        barChartView.animate(xAxisDuration: 1.5, easingOption: .easeOutExpo)
        barChartView.animate(yAxisDuration: 1.5, easingOption: .easeOutExpo)
    }
    func createMonthBarChart() {
        dateLabel.text = "\(todayMonth), \(todayYear)"
        let set = createMonthData()
        let yAxis = barChartView.leftAxis
        if set.entries == createEmptyMonthData() {
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
    }
    
    func createWeekBarChart() {
        dateLabel.text = "\(todayMonth) \(begWeekNum)  - \(nextMonth) \(endWeekNum), \(todayYear)"
        let set = createWeekData()
        let yAxis = barChartView.leftAxis
        if set.entries == createEmptyWeekData() {
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

    }
    
    func createYearBarChart() {
        dateLabel.text = todayYear
        let set = createYearData()
        set.colors = [brightPurple]
        if set.entries == createEmptyYearData() {
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
    }
    
    func createYearData() -> BarChartDataSet {
        var entries = createEmptyYearData()
        var thisYearArray = [String]()
        for day in timeData {
            if day.contains(todayYear) {
                thisYearArray.append(day)
            }
        }
        totalMinutes = 0
        for day in thisYearArray {
            let equalIndex = day.firstIndex(of: "=")
            let equalIndexOffset = day.index(equalIndex!, offsetBy: 1)
            let totalTimeForDay = String(day[equalIndexOffset...])
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
  
    
    func createMonthData() -> BarChartDataSet {
        var entries = createEmptyMonthData()
        var thisMonthArray = [String]()
        
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
            let startIndexBef = day.firstIndex(of: " ")
            let startIndex = day.index(startIndexBef!, offsetBy: 1)
            let dayNum = Int(day[startIndex..<commaIndex!])!
            let equalIndexOffset = day.index(equalIndex!, offsetBy: 1)
            let totalTimeForDay = String(day[equalIndexOffset...])
            entries[dayNum - 1] = BarChartDataEntry(x: Double(dayNum), y: Double(Int(totalTimeForDay)!))
            totalMinutes += Int(totalTimeForDay)!
        }
        let set = BarChartDataSet(entries: entries, label: "Minutes")
        return set
    }
    
    func createWeekData() -> BarChartDataSet {
        var thisWeekArray = [String]()
        var thisMonthArray = [String]()

        for day in timeData {
            if day.contains(todayMonth) {
                if day.contains(todayYear) {
                    thisMonthArray.append(day)
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
        var entries = createEmptyWeekData()
        for day in thisWeekArray {
            let equalIndex = day.firstIndex(of: "=")
            let equalIndexOffset = day.index(equalIndex!, offsetBy: 1)
            let totalTimeForDay = String(day[equalIndexOffset...])
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
    
 
    private func setUpTabBar() {
        view.addSubview(menuBar)
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        menuBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //MARK: - Handlers
      @objc func handleMenuToggle() {
          delegate?.handleMenuToggle(forMenuOption: nil)
      }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if menuLabel == "Week" {
            barPressedTitle.text = "\(todayMonth) \(begWeekNum + Int(entry.x) - 1), \(todayYear)"
        } else if menuLabel == "Month" {
            barPressedTitle.text = "\(todayMonth) \(Int(entry.x)), \(todayYear)"
        } else if menuLabel == "Year" {
            barPressedTitle.text = dateHelper.intToMonth(num: Int(entry.x))
        }
        
            barMinNumLabel.removeFromSuperview()
            barMinNumLabel.text = String(Int(entry.y))
            barMinNumLabel.sizeToFit()
            view.addSubview(barMinNumLabel)
            barMinNumLabel.topToBottom(of: barPressedTitle, offset: 30)
            if String(Int(entry.y)).count == 2 {
                barMinNumLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80).isActive = true
            } else if String(Int(entry.y)).count == 3 {
                barMinNumLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 65).isActive = true
            } else {
                barMinNumLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90).isActive = true
            }
                
        }
}
