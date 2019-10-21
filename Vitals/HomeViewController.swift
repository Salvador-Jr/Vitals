//
//  HomeViewController.swift
//  Vitals
//
//  Created by Salvador Rodriguez on 9/10/19.
//  Copyright © 2019 009252542SalvadorRodriguez. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    
    @IBOutlet weak var tableView: UITableView!
    
    var hrs = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
           }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className: "HeartRate")
        query.includeKey("user")
        query.limit = 7
        query.findObjectsInBackground{(hrs, error) in if hrs != nil {
            self.hrs = hrs!
            self.tableView.reloadData()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hrs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"HeartRateTableViewCell") as! HeartRateTableViewCell
        
        let hr  = hrs[indexPath.row]
//        let user  = hr["User"] as! PFUser
//        let DateCreated = hr["Time"] as? Int
        let HRdata = hr["HeartRateReading"] as? Int
        cell.heartRateLabel.text = String(HRdata!)
//        cell.tableViewDate.text = String (hr.createdAt!)
        let creAt = hr.createdAt
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "HH:mm:ss"
        
        let myString = formatter.string(from: Date()) // string purpose I add here
        let myStringDBDateTime = formatter.string(from:creAt!)
        cell.tableViewTime.text = String(myStringDBDateTime)

        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "MMM dd, yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        print(myStringafd)
        
        let myStringDBDate = formatter.string(from:creAt!)
        cell.tableViewDate.text = String(myStringDBDate)

        
        
        return cell
    }
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        let delagate = UIApplication.shared.delegate as! AppDelegate
        delagate.window?.rootViewController = loginViewController
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


//let formatter = DateFormatter()
//// initially set the format based on your datepicker date / server String
//formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//let myString = formatter.string(from: Date()) // string purpose I add here
//// convert your string to date
//let yourDate = formatter.date(from: myString)
////then again set the date format whhich type of output you need
//formatter.dateFormat = "MMM dd, yyyy"
//// again convert your date to string
//let myStringafd = formatter.string(from: yourDate!)
//dateField.text = myStringafd
//print(myStringafd)
//super.viewDidLoad()
