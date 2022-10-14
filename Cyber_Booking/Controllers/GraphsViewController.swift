//
//  GraphsViewController.swift
//  Cyber_Booking
//
//  Created by Sofía Hernandez on 12/10/22.
//

import UIKit
import Charts

class GraphsViewController: UIViewController, ChartViewDelegate {
    
    
    @IBOutlet weak var chart1: UIView!
    @IBOutlet weak var chart2: UIView!
    
    var barChart = BarChartView()
    var pieChart = PieChartView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        barChart.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        barChart.frame = CGRect(x: 0,
                                y: 0,
                                width: self.chart1.frame.size.width,
                                height: self.chart1.frame.size.height)
        
        //barChart.center = view.center
        
        view.addSubview(barChart)
        
        // Data
        var entries = [BarChartDataEntry]()
        
        for x in 0..<10 {
            entries.append(BarChartDataEntry(x: Double(x), y: Double(x)))
        }
        
        let set = BarChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.vordiplom()
        
        let data = BarChartData(dataSet: set)
        
        barChart.data = data
        
        // PIE
        /*
        pieChart.frame = CGRect(x: 0,
                               y: 0,
                               width: self.chart2.frame.size.width,
                               height: self.chart2.frame.size.height)
        
        //pieChart.center = view.center
        
        view.addSubview(pieChart)
        
        // Data
        var entriesPie = [PieChartDataEntry]()
        
        for x in 0..<3 {
            entriesPie.append(PieChartDataEntry(value: Double(x)))
        }
        
        let setPie = PieChartDataSet(entries: entries)
        setPie.colors = ChartColorTemplates.vordiplom()
        
        let dataPie = PieChartData(dataSet: setPie)
        
        pieChart.data = data
         */
    }

}
