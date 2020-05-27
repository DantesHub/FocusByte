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
var thisWeekArray = [String]()
var thisMonthArray = [String]()
var thisYearArray = [String]()
class StatisticsController: UIViewController, ChartViewDelegate{
    //MARK: - Properties and Views
        var contentViewSize: CGSize {
        get {
            var height: CGFloat = 0.0
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1920, 2208:
                    height = 350
                    //print("iphone 8plus")
                case 2436:
                    height = 280
                    //print("IPHONE X, IPHONE XS, IPHONE 11 PRO")
                case 2688:
                    height = 200
                    //print("IPHONE XS MAX, IPHONE 11 PRO MAX")
                case 1792:
                     height = 200
                    //print("IPHONE XR, IPHONE 11")
                default:
                    height = 430
                }
            }
            return CGSize(width: self.view.frame.width, height: self.view.frame.height + height)
        }
    }
    var delegate: ContainerControllerDelegate!
    lazy var barChartView: BarChartView = {
        let barView = BarChartView()
        barView.backgroundColor = backgroundColor
        return barView
    }()
    
    lazy var pieChartView: PieChartView = {
        let pieView = PieChartView()
        pieView.backgroundColor = superLightLavender
        return pieView
    }()
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = backgroundColor
        scrollView.frame = view.bounds
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.autoresizingMask = .flexibleHeight
        scrollView.contentSize = contentViewSize
        return scrollView
    }()
    lazy var containerView: UIView = {
        let view = UIView()
        view.frame.size = contentViewSize
        return view
    }()
    let menuBar: MenuBar = {
           let mb = MenuBar()
           return mb
    }()
    var descriptionLabel = UILabel()
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
    var tagChartTitle = UILabel()
    var tagTimeDictionary:[String:Int] = [:]
    var colors = [NSUIColor]()
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
                tagDictionary = result.tagDictionary.map{ $0 }
              }
          }
        colors = Array(repeating: NSUIColor(), count: tagDictionary.count)
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
        
        pieChartView.rotationAngle = 0
        pieChartView.rotationEnabled = false
        pieChartView.drawHoleEnabled = true
        pieChartView.holeColor = superLightLavender
//        pieChartView.line
        pieChartView.isUserInteractionEnabled = false
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: - Logic Funcs
    @objc final func backTapped() {
           resetChartValueSelected()
           noDataLabel.removeFromSuperview()
           if menuLabel == "Week" {
               backWeekTapped()
           } else if menuLabel == "Month" {
               backMonthTapped()
           } else {
               backYearTapped()
           }
       }
       
       private final func backYearTapped() {
           noDataLabel.removeFromSuperview()
           todayYear = String(Int(todayYear)! - 1)
           monthSessionDict = [:]
           createYearBarChart()
       }
       private final func backMonthTapped() {
           let monthNum = dateHelper.getMonthNum(month: todayMonth)
           if monthNum == 1 {
               todayYear = String(Int(todayYear)! - 1)
           }
           todayMonth = dateHelper.intToMonth(num: monthNum - 1)
           createMonthBarChart()
       }
       
       private final func backWeekTapped() {
           begWeekNum -= 7
           
           if todayMonth == "Jan" || nextMonth == "Jan"{
               if begWeekNum < 1 {
                   todayYear = String(Int(todayYear)! - 1)
               }
               if todayMonth == "Dec" && nextMonth == "Jan" {
                   todayYear = String(Int(todayYear)! - 1)
               }
           }
           endWeekNum = begWeekNum + 6
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
           if todayMonth == "Dec" && nextMonth == "Jan" {
               todayYear = String(Int(todayYear)! + 1)
           }
           createWeekBarChart()
       }
       @objc final func nextTapped() {
           resetChartValueSelected()
           noDataLabel.removeFromSuperview()
           if menuLabel == "Week" {
               nextWeekTapped()
           } else if menuLabel == "Month" {
               nextMonthTapped()
           } else {
               nextYearTapped()
           }
       }
       private final func nextMonthTapped() {
           let monthNum = dateHelper.getMonthNum(month: todayMonth)
           if monthNum == 12 {
               todayYear = String(Int(todayYear)! + 1)
           }
           todayMonth = dateHelper.intToMonth(num: monthNum + 1)
           createMonthBarChart()
       }
       private final func nextYearTapped() {
           noDataLabel.removeFromSuperview()
           todayYear = String(Int(todayYear)! + 1)
           monthSessionDict = [:]
           createYearBarChart()
       }
       private final func nextWeekTapped() {
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
    
    //MARK: - Helper Functions
    func configureUI() {
        self.navigationItem.title = "Statistics"
        setUpTabBar()
        configureNavigationBar(color: backgroundColor, isTrans: false)
         navigationItem.leftBarButtonItem =  UIBarButtonItem(image: resizedMenuImage?.withTintColor(.white), style: .plain, target: self, action: #selector(handleMenuToggle))
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        view.backgroundColor = backgroundColor
        dateLabel.font = UIFont(name: "Menlo", size: 20)
        containerView.addSubview(dateLabel)
        dateLabel.topToBottom(of: menuBar, offset: 30)
        dateLabel.centerX(to: view)
        
        containerView.addSubview(backButton)
        backButton.topToBottom(of: menuBar, offset: 30)
        backButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25).isActive = true
        
        containerView.addSubview(nextButton)
        nextButton.topToBottom(of: menuBar, offset: 30)
        nextButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25).isActive = true
        
        containerView.addSubview(barChartView)
        barChartView.edgesToSuperview(excluding: .bottom, insets:  TinyEdgeInsets(top: 140, left: 25, bottom: 0, right: 25))
        barChartView.height(300)
        
        totalMinutesLabel.text = "Total: \(totalMinutes) minutes"
        totalMinutesLabel.textColor = .white
        totalMinutesLabel.font = UIFont(name: "Menlo-Bold", size: 15)
        containerView.addSubview(totalMinutesLabel)
        totalMinutesLabel.topToBottom(of: dateLabel, offset: 20)
        totalMinutesLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 45).isActive = true
        
        noDataLabel.text = "No Data For \nThis Page :("
        noDataLabel.numberOfLines = 2
        noDataLabel.textColor = .white
        noDataLabel.font = UIFont(name: "Menlo-Bold", size: 25)
        
        barPressedTitle.text = "No Bar Selected"
        barPressedTitle.textColor = .black
        barPressedTitle.font = UIFont(name: "Menlo", size: 22)
        containerView.addSubview(barPressedTitle)
        barPressedTitle.centerXToSuperview()
        barPressedTitle.topToBottom(of: barChartView, offset: 30)
        
        //vertical line
        let path = UIBezierPath()
        path.move(to: CGPoint(x: containerView.center.x, y: containerView.center.y + 50))
        path.addLine(to: CGPoint(x: containerView.center.x, y: containerView.center.y - 30))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 4
        containerView.layer.addSublayer(shapeLayer)
        
        barMinNumLabel.text = "0"
        barMinNumLabel.textColor = .white
        barMinNumLabel.textAlignment = .center
        barMinNumLabel.font = UIFont(name: "Menlo-Bold", size: 50)
        barMinNumLabel.sizeToFit()
        containerView.addSubview(barMinNumLabel)
        barMinNumLabel.topToBottom(of: barPressedTitle, offset: 30)
        barMinNumLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 90).isActive = true
        
        barMinDescLabel.text = "minutes"
        barMinDescLabel.textColor = .white
        barMinDescLabel.font = UIFont(name: "Menlo", size: 25)
        containerView.addSubview(barMinDescLabel)
        barMinDescLabel.topToBottom(of: barPressedTitle, offset: 85)
        barMinDescLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 60).isActive = true
        
        barSessNumLabel.text = "0"
        barSessNumLabel.textColor = .white
        barSessNumLabel.font = UIFont(name: "Menlo-Bold", size: 50)
        containerView.addSubview(barSessNumLabel)
        barSessNumLabel.topToBottom(of: barPressedTitle, offset: 30)
        barSessNumLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -90).isActive = true
        
        barSessDescLabel.text = "sessions"
        barSessDescLabel.textColor = .white
        barSessDescLabel.font = UIFont(name: "Menlo", size: 25)
        containerView.addSubview(barSessDescLabel)
        barSessDescLabel.topToBottom(of: barPressedTitle, offset: 85)
        barSessDescLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40).isActive = true
        
        tagChartTitle.text = "Tag Distribution"
        tagChartTitle.font = UIFont(name: "Menlo-Bold", size: 25)
        tagChartTitle.textColor = .black
        containerView.addSubview(tagChartTitle)
        tagChartTitle.topToBottom(of: barSessDescLabel, offset: 45)
        tagChartTitle.centerX(to: view)
        containerView.addSubview(pieChartView)
        pieChartView.edgesToSuperview(excluding: .top, insets:  TinyEdgeInsets(top: 0, left: 25, bottom: 95, right: 25))
        pieChartView.height(300)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "💡 The percentage of time you spent\non different tags during the week,\nmonth or year"
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont(name: "Menlo", size: 15)
        containerView.addSubview(descriptionLabel)
        descriptionLabel.topToBottom(of: pieChartView, offset: 10)
        descriptionLabel.centerX(to: view)
        

    }
    func createObservers() {
           NotificationCenter.default.addObserver(self, selector: #selector(StatisticsController.updateBarChartToWeek(notificaton:)), name: NSNotification.Name(rawValue: weekKey), object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(StatisticsController.updateBarChartToMonth(notificaton:)), name: NSNotification.Name(rawValue: monthKey), object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(StatisticsController.updateBarChartToYear(notificaton:)), name: NSNotification.Name(rawValue: yearKey), object: nil)
        
       }
  
    
    private func setUpTabBar() {
        containerView.addSubview(menuBar)
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        menuBar.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        menuBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        menuBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //MARK: - Handlers
      @objc func handleMenuToggle() {
          delegate?.handleMenuToggle(forMenuOption: nil)
      }
    
   
  
}
