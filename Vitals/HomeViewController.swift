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
    @IBOutlet weak var homeDateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var hrs = [PFObject]()
    var cus = [PFObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
           }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className: "HeartRate")
        query.includeKey("User")
        query.limit = 5
        query.findObjectsInBackground{(hrst, error) in if hrst != nil {
            self.hrs = hrst!
//            print("AQUI", hrst!)
            self.tableView.reloadData()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hrs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"HeartRateTableViewCell") as! HeartRateTableViewCell
        let CurrentUser = PFUser.current()
        let cuObjectId = CurrentUser?.objectId
        let hr  = hrs[indexPath.row]
        let user  = hr["User"] as! PFUser
        print ("CU:", cuObjectId!)
        print ("POI:",user.objectId!)
        if cuObjectId == user.objectId //compares current user object id with the user post object id
        {
            usernameLabel.text = user.username
            print("THEY MATCH")
            let HRdata = hr["HeartRateReading"] as? Int
            cell.heartRateLabel.text = String(HRdata!)
            let creAt = hr.createdAt
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            var myString = formatter.string(from: Date())
            
            let myStringDBDateTime = formatter.string(from:creAt!)
            cell.tableViewTime.text = String(myStringDBDateTime)
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            myString = formatter.string(from: Date()) // string
            let yourDate = formatter.date(from: myString)
            formatter.dateFormat = "MMM dd, yyyy"
            let myStringafd = formatter.string(from: yourDate!)
            //        print("today:",myStringafd)
            homeDateLabel.text = myStringafd
            
            let myStringDBDate = formatter.string(from:creAt!)
            cell.tableViewDate.text = String(myStringDBDate)

        }
        else{
            print("DO NOT MATCH")
        }
        
        
        return cell
    }
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        let delagate = UIApplication.shared.delegate as! AppDelegate
        delagate.window?.rootViewController = loginViewController
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("loading new details")
        //find selected data
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let hrData = hrs[indexPath.row]
        let nav = segue.destination as! UINavigationController
        var svc = nav.topViewController as! SettingsViewController
        svc.hr = [hrData]
        
        //pass the data to the new controller
    }


}




