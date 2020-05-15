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


class StatisticsController: UIViewController, ChartViewDelegate{
    //MARK: - Variables
    var delegate: ContainerControllerDelegate!
    lazy var barChartView: BarChartView = {
        let barView = BarChartView()
        barView.backgroundColor = superLightLavender
        return barView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        barChartView.delegate = self
        configureUI()
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        configureNavigationBar(color: backgroundColor, isTrans: false)
         navigationItem.leftBarButtonItem =  UIBarButtonItem(image: resizedMenuImage?.withTintColor(.white), style: .plain, target: self, action: #selector(handleMenuToggle))
        view.backgroundColor = backgroundColor
        view.addSubview(barChartView)
        barChartView.edgesToSuperview(excluding: .bottom, insets:  TinyEdgeInsets(top: 25, left: 25, bottom: 0, right: 25))
        barChartView.height(300)

        
        let set = BarChartDataSet(entries: [
            BarChartDataEntry(x: 2.0, y: 67.0),
            BarChartDataEntry(x: 1.0, y: 40.0),
            BarChartDataEntry(x: 3.0, y: 25.0),
            BarChartDataEntry(x: 4.0, y: 125.0),
            BarChartDataEntry(x: 6.0, y: 125.0),
            BarChartDataEntry(x: 7.0, y: 180.0),
        ])
        set.colors = [brightPurple]
//        set.colors = ChartColorTemplates.
        let data = BarChartData(dataSet: set)
        barChartView.data = data
    
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelCount = 7
        xAxis.valueFormatter = DayAxisValueFormatter(chart: barChartView)
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        
        barChartView.getAxis(.right).enabled = false
        let yAxis = barChartView.leftAxis
     
        
        
    }
    
    //MARK: - Handlers
      @objc func handleMenuToggle() {
          delegate?.handleMenuToggle(forMenuOption: nil)
      }
}
