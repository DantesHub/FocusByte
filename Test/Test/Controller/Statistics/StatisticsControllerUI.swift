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
var todayMonth = ""
class StatisticsController: UIViewController, ChartViewDelegate{
    //MARK: - Properties
    var delegate: ContainerControllerDelegate!
    lazy var barChartView: BarChartView = {
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
    var todayDayOfWeek = ""
    var noDataLabel = UILabel()
    var nextMonth = ""
    let dateHelper = DateHelper()
    var daySessionDict: [String : Int] = [:]
    var monthSessionDict: [String : Int] = [:]
    
    
    //MARK: - init
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
    func createObservers() {
           NotificationCenter.default.addObserver(self, selector: #selector(StatisticsController.updateBarChartToWeek(notificaton:)), name: NSNotification.Name(rawValue: weekKey), object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(StatisticsController.updateBarChartToMonth(notificaton:)), name: NSNotification.Name(rawValue: monthKey), object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(StatisticsController.updateBarChartToYear(notificaton:)), name: NSNotification.Name(rawValue: yearKey), object: nil)
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
    
   
  
}
