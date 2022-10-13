//
//  GraphsViewController.swift
//  Cyber_Booking
//
//  Created by Sofía Hernandez on 12/10/22.
//

import UIKit
import Charts

class GraphsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createChart()
        // Do any additional setup after loading the view.
        
        
    }
    
    private func createChart() {
        // Create bar chart
        let barChart = BarChartView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        // Configure axis
        
        
        // Configure legend
        
        
        // Supply data
        var entries = [BarChartDataEntry()]
        
        for x in 0..<10 {
            entries.append(
                BarChartDataEntry(
                    x: Double(x),
                    y: Double.random(in: 0...30)
                )
            )
        }
        
        let set = BarChartDataSet(entries: entries, label: "Cost")
        let data = BarChartData(dataSet: set)
        
        barChart.data = data
        
        view.addSubview(barChart)
        
        // Center the chart
        barChart.center = view.center
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
