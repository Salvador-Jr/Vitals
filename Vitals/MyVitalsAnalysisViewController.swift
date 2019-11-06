//
//  MyVitalsAnalysisViewController.swift
//  Vitals
//
//  Created by Salvador Rodriguez on 11/5/19.
//  Copyright © 2019 009252542SalvadorRodriguez. All rights reserved.
//

import UIKit
import Charts
import Parse

class MyVitalsAnalysisViewController: UIViewController {
    var heartRateValue : [Double] = []
    var hrs = [PFObject]()
    var oldhrs = [PFObject]()
    var clickCount = 0

    let query = PFQuery(className: "HeartRate")
    var startDateQuery = "12-30-2030"

    @IBOutlet weak var chartLine: LineChartView!
    @IBOutlet weak var startDateLabel: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        startDateQuery = "0"
//        number.append(10)
//        number.append(2)
//        number.append(15)
//        number.append(13)
//        updateChartData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goButton(_ sender: Any) {
        clickCount = clickCount + 1
        print ("CC:", clickCount)
        if startDateLabel.text != nil{
            startDateQuery = startDateLabel.text!
        }
//        print("s:", startDateQuery)
        let date = NSDate()
        let calendar = NSCalendar.current
        let lastWeek = calendar.date(byAdding: .weekday , value: Int(-Double(startDateQuery)!), to: date as Date)
//        print(lastWeek!)
//        let lastWeek = calendar.dateByAddingUnit(.Week, value: -1, toDate: NSDate(), options: [])
        query.whereKey("createdAt", greaterThanOrEqualTo: lastWeek!)
        query.whereKey("User", equalTo: PFUser.current()!)

        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                // The find succeeded.
                self.hrs = objects
//                print("Successfully retrieved \(objects.count) scores.")
                // Do something with the found objects
                for object in objects {
//                    print(object.objectId as Any)
//                    print(self.hrs.count)
                    self.heartRateValue.append(object["HeartRateReading"] as! Double)
                }
            }
            self.updateChartData()
        }
    }
    func updateChartData(){
//        print ("CC in UPDATE:", clickCount)

        var lineChartEntry = [ChartDataEntry]()
        
        for i in 0..<heartRateValue.count{
            let value = ChartDataEntry(x: Double(i), y: heartRateValue[i])
            lineChartEntry.append(value)
        }
        let heartRateDataLine = LineChartDataSet(values: lineChartEntry, label: "HeartRate")
        heartRateDataLine.colors = [NSUIColor.orange]
        
        let data = LineChartData()

        /*
         if data.dataSetCount == 1{
         data.removeDataSet(heartRateDataLine)
         print("remove", data.dataSetCount)
         }
         else{
         data.addDataSet(heartRateDataLine)
         print("add", data.dataSetCount)
         
         }
 */
        
//        if clickCount > 2
//        {
//            print("remove then add")
//            data.removeDataSet(heartRateDataLine)
//            print("remove", data.dataSetCount)
//            chartLine.data = data
//        }
//        else{
//            data.addDataSet(heartRateDataLine)
//            print("add", data.dataSetCount)
//            chartLine.data = data
//        }
        
//        if data.dataSetCount == 1
//        {
//            print("TREUdd= ", data.dataSetCount)
//            data.removeDataSet(heartRateDataLine)
//            print("new = ", data.dataSetCount)
//
//        }
//        else{
//            print("FALSEdd= ", data.dataSetCount)
//            data.addDataSet(heartRateDataLine)
//            print("new = ", data.dataSetCount)
//        }
//        chartLine.data = data
//        chartLine.chartDescription?.text = "chart"
        
        
        print("START = ", data.dataSetCount)
        if clickCount == 1{
            print("first time being clicked on")
            data.addDataSet(heartRateDataLine)
            chartLine.data = data
        }
        else{
            print("all the other times")
            data.removeDataSet(heartRateDataLine)
            chartLine.data = data

            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                data.addDataSet(heartRateDataLine)
                self.chartLine.data = data


            }
        }
        chartLine.chartDescription?.text = "chart"
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
