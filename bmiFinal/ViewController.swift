//
//  ViewController.swift
//  bmiFinal
//
//  Created by Emmanuel Etti on 2016-03-18.
//  Copyright © 2016 Emmanuel Etti. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController,ChartViewDelegate{

    @IBOutlet weak var lineChartView: LineChartView!
    let record_key : String = "bmiArray"
    
    var bmiArray = [Double]()
    var weightArray = [String]()
    
    @IBOutlet weak var labelTxt: UILabel!
    
    let defaults = NSUserDefaults.standardUserDefaults() //set defaults ? localStorage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        self.lineChartView.delegate = self
        // 2
        self.lineChartView.descriptionText = "Tap node for details"
        // 3
        self.lineChartView.descriptionTextColor = UIColor.whiteColor()
        self.lineChartView.gridBackgroundColor = UIColor.darkGrayColor()
        // 4
        self.lineChartView.fitScreen()
        self.lineChartView.pinchZoomEnabled = true
        
        // 5
        let myElement = defaults.objectForKey(record_key) as? [[String:Float]] ?? [[String:Float]]()
        if myElement.count > 0 {
            for (key) in myElement {
                let bmi = Double(key["bmi"]!)
                let weight  = String(key["weight"]!)
//                let height  = String(key["height"]!)
                bmiArray.insert(bmi, atIndex: 0)
                weightArray.insert(weight, atIndex: 0)
//                let obj   = ["bmi": bmi,"weight": weight, "height": height]
            }
            setChartData(weightArray)
            self.lineChartView.notifyDataSetChanged();
            labelTxt.text = String("Your current BMI is: \(myElement.first!["bmi"]!)")
        }else{
            self.lineChartView.noDataText = "No data provided"
        }
        
    }
    
    func setChartData(weights : [String]) {
        // 1 - creating an array of data entries
        print(bmiArray)
        print(weightArray)
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for var i = 0; i < weights.count; i++ {
            yVals1.append(ChartDataEntry(value: bmiArray[i], xIndex: i))
        }
        
        // 2 - create a data set with our array
        let set1: LineChartDataSet = LineChartDataSet(yVals: yVals1, label: "Body Mass Index")
        set1.axisDependency = .Right // Line will correlate with left axis values
        set1.setColor(UIColor.redColor().colorWithAlphaComponent(0.5)) // our line's opacity is 50%
        set1.setCircleColor(UIColor.redColor()) // our circle will be dark red
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.redColor()
        set1.highlightColor = UIColor.whiteColor()
        set1.drawCircleHoleEnabled = true
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        //4 - pass our bmi in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(xVals: weightArray, dataSets: dataSets)
        data.setValueTextColor(UIColor.whiteColor())
        
        //5 - finally set our data
        self.lineChartView.data = data
        self.lineChartView.setVisibleXRangeMaximum(5);
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

