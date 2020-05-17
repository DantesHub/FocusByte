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
    lazy var nextButton: UIButton = {
       let button = UIButton()
        let carrotGreat = UIImage(systemName: "greaterthan", withConfiguration: .none)
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
          results = uiRealm.objects(User.self)
          for result  in results {
              if result.isLoggedIn == true {
                self.timeData = result.timeArray.map{ $0 }
              }
          }
        createWeekBarChart()
        barChartView.animate(xAxisDuration: 1.5, easingOption: .easeInOutBack)
        barChartView.animate(yAxisDuration: 1.5, easingOption: .easeInOutBack)
        barChartView.dragEnabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.drawBarShadowEnabled = false
        barChartView.isUserInteractionEnabled = false
        
        barChartView.getAxis(.right).enabled = false

      }
    override func viewWillDisappear(_ animated: Bool) {
        print("dissapeared")
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
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        
        view.addSubview(nextButton)
        nextButton.topToBottom(of: menuBar, offset: 30)
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        
        view.addSubview(barChartView)
        barChartView.edgesToSuperview(excluding: .bottom, insets:  TinyEdgeInsets(top: 120, left: 25, bottom: 0, right: 25))
        barChartView.height(300)
        
        noDataLabel.text = "No Data For \nThis Page :("
        noDataLabel.numberOfLines = 2
        noDataLabel.textColor = .white
        noDataLabel.font = UIFont(name: "Menlo-Bold", size: 25)
        
    }

    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(StatisticsController.updateBarChartToWeek(notificaton:)), name: NSNotification.Name(rawValue: weekKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StatisticsController.updateBarChartToMonth(notificaton:)), name: NSNotification.Name(rawValue: monthKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StatisticsController.updateBarChartToYear(notificaton:)), name: NSNotification.Name(rawValue: yearKey), object: nil)
    }
    @objc func updateBarChartToWeek(notificaton: NSNotification) {
       createWeekBarChart()
    }
    @objc func backTapped() {
        noDataLabel.removeFromSuperview()
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
    @objc func updateBarChartToMonth(notificaton: NSNotification) {
        dateLabel.text = todayMonth
        let set = createMonthData()
        let yAxis = barChartView.leftAxis
        if set.entries == createEmptyMonthData() {
            //             yAxis.valueFormatter = IndexAxisValueFormatter(values: ["", "50","100","150","200","250","300"])
            set.drawValuesEnabled = true
            view.addSubview(noDataLabel)
            noDataLabel.center(in: barChartView)
        }
        set.colors = [brightPurple]
        
        let data = BarChartData(dataSet: set)
        barChartView.legend.enabled = false
        barChartView.data = data
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        let numDays = dateHelper.getNumberOfDays(month: todayMonth)
        var days = [String]()
        days.append("")
        let firstDay = "\(dateHelper.getMonthNum(month: todayMonth))/1"
        days.append(firstDay)
        for i in 2...numDays {
            days.append(String(i))
        }
        xAxis.labelFont = UIFont(name: "Menlo", size: 10)!
        xAxis.labelCount = 7
        xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        barChartView.xAxis.granularity = 1
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        xAxis.axisLineColor = backgroundColor
        
        yAxis.axisLineColor = backgroundColor
        yAxis.axisMinimum = 0.0
    }
    
    @objc func updateBarChartToYear(notificaton: NSNotification) {
          let set = BarChartDataSet(entries: [
                     BarChartDataEntry(x: 2.0, y: 67.0),
                     BarChartDataEntry(x: 1.0, y: 40.0),
                     BarChartDataEntry(x: 3.0, y: 25.0),
                     BarChartDataEntry(x: 4.0, y: 125.0),
                     BarChartDataEntry(x: 6.0, y: 125.0),
                     BarChartDataEntry(x: 7.0, y: 180.0),
                     BarChartDataEntry(x: 11.0, y: 180.0),
                 ], label: "Minutes")
                 set.colors = [brightPurple]
                 //        set.colors = ChartColorTemplates.
                 let data = BarChartData(dataSet: set)
                 barChartView.legend.enabled = false
                 barChartView.data = data
                 let xAxis = barChartView.xAxis
                 xAxis.labelPosition = .bottom
                 xAxis.labelFont = UIFont(name: "Menlo", size: 8)!
                 xAxis.labelCount = 12
                 let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul","Aug","Sep","Oct","Nov","Dec"]
                 xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        barChartView.animate(xAxisDuration: 1.5, easingOption: .easeInOutBack)
               barChartView.animate(yAxisDuration: 1.5, easingOption: .easeInOutBack)
    }
    
    func createWeekBarChart() {
        let set = createWeekData()
        let yAxis = barChartView.leftAxis
        if set.entries == createEmptyWeekData() {
//             yAxis.valueFormatter = IndexAxisValueFormatter(values: ["", "50","100","150","200","250","300"])
            set.drawValuesEnabled = true
            view.addSubview(noDataLabel)
            noDataLabel.center(in: barChartView)
        }
        set.colors = [brightPurple]
        
        let data = BarChartData(dataSet: set)
        barChartView.legend.enabled = false
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
        yAxis.axisMinimum = 0.0
       
    }
    func createEmptyMonthData() -> [BarChartDataEntry] {
        var entries = [BarChartDataEntry]()
        let numOfDays = dateHelper.getMonthNum(month: todayMonth)
        for i in 1...numOfDays {
            entries.append(BarChartDataEntry(x: Double(i), y: 0.0))
        }
        return entries
    }
    func createMonthData() -> BarChartDataSet {
        var entries = createEmptyMonthData()
        let set = BarChartDataSet(entries: entries, label: "Minutes")
        return set
    }
    func createWeekData() -> BarChartDataSet {
        var thisWeekArray = [String]()
        var thisMonthArray = [String]()
        
        dateLabel.text = "\(todayMonth) \(begWeekNum)  - \(nextMonth) \(endWeekNum), \(todayYear)"
        

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
        
        var entries = createEmptyWeekData()
        for day in thisWeekArray {
            let equalIndex = day.firstIndex(of: "=")
            let equalIndexOffset = day.index(equalIndex!, offsetBy: 1)
            let totalTimeForDay = String(day[equalIndexOffset...])
            
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
    
    
    func createEmptyWeekData() -> [BarChartDataEntry] {
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
        print(entry)
    }
}
