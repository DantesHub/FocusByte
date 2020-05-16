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
    var timeData = List<String>()
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

    override func viewDidLoad() {
        super.viewDidLoad()
        createObservers()
        barChartView.delegate = self
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
          results = uiRealm.objects(User.self)
          for result  in results {
              if result.isLoggedIn == true {
                self.timeData = result.timeArray
              }
          }
        print(self.timeData)
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
        dateLabel.text = "May 13 - 19"
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

        createWeekBarChart()
        barChartView.animate(xAxisDuration: 1.5, easingOption: .easeInOutBack)
        barChartView.animate(yAxisDuration: 1.5, easingOption: .easeInOutBack)
        barChartView.dragEnabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.drawBarShadowEnabled = false
        barChartView.isUserInteractionEnabled = false
        
        barChartView.getAxis(.right).enabled = false
        let yAxis = barChartView.leftAxis
        yAxis.axisLineColor = backgroundColor

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
        
    }
    @objc func nextTapped() {
        
    }
    @objc func updateBarChartToMonth(notificaton: NSNotification) {
        let set = BarChartDataSet(entries: [
            BarChartDataEntry(x: 2.0, y: 67.0),
            BarChartDataEntry(x: 1.0, y: 40.0),
            BarChartDataEntry(x: 3.0, y: 25.0),
            BarChartDataEntry(x: 4.0, y: 125.0),
            BarChartDataEntry(x: 6.0, y: 125.0),
            BarChartDataEntry(x: 7.0, y: 180.0),
            BarChartDataEntry(x: 27.0, y: 280.0),
            BarChartDataEntry(x: 24, y: 5.0),
            BarChartDataEntry(x: 31, y: 2.0),
        ], label: "Minutes")
        set.colors = [brightPurple]
        //        set.colors = ChartColorTemplates.
        let data = BarChartData(dataSet: set)
        barChartView.legend.enabled = false
        barChartView.data = data
        
        let dateComponents = DateComponents(year: 2020, month: 5)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont(name: "Menlo", size: 8)!
        xAxis.labelCount = numDays + 2
        var values = ["", "5/1"]
        print(numDays)
        for i in (2...numDays + 1) {
            print(i)
            if i % 8 == 0 && i != 32 {
                values.append(String(i))
            } else if i == numDays {
                values.append(String(i))
            } else {
                values.append("")
            }
          
        }
        xAxis.valueFormatter = IndexAxisValueFormatter(values: values)
        barChartView.animate(xAxisDuration: 1.5, easingOption: .easeInOutBack)
               barChartView.animate(yAxisDuration: 1.5, easingOption: .easeInOutBack)
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
        let set = BarChartDataSet(entries: [
            BarChartDataEntry(x: 2.0, y: 67.0),
            BarChartDataEntry(x: 1.0, y: 40.0),
            BarChartDataEntry(x: 3.0, y: 25.0),
            BarChartDataEntry(x: 4.0, y: 125.0),
            BarChartDataEntry(x: 6.0, y: 125.0),
            BarChartDataEntry(x: 7.0, y: 180.0),
        ], label: "Minutes")
        set.colors = [brightPurple]
        //        set.colors = ChartColorTemplates.
        let data = BarChartData(dataSet: set)
        barChartView.legend.enabled = false
        barChartView.data = data
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        let days = ["", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat","Sun"]
        xAxis.labelFont = UIFont(name: "Menlo", size: 10)!
        xAxis.labelCount = 7
        xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        barChartView.xAxis.granularity = 1
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        xAxis.axisLineColor = backgroundColor
    
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
